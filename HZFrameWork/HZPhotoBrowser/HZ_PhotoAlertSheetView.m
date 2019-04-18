//
//  HZ_PhotoAlertSheetView.m
//  AFNetworking
//
//  Created by 吴灶洲 on 2019/4/17.
//

#import "HZ_PhotoAlertSheetView.h"
#import <Masonry/Masonry.h>
//#import "HZ_FontFile.h"
//#import "HZTool.h"
#import <YYKit/UIColor+YYAdd.h>

static HZ_PhotoAlertSheetView *alerView;

@interface HZ_PhotoAlertSheetView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;

@end


@implementation HZ_PhotoAlertSheetView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hz_addSubView];
        [self hz_autoLayout];
    }
    return self;
}

- (void)hz_addSubView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 56;
    _tableView.sectionHeaderHeight = CGFLOAT_MIN;
    _tableView.scrollEnabled = NO;
//    _tableView.sectionFooterHeight = [HZTool isBangsPhone] ? 34 : CGFLOAT_MIN;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _topView = [[UIView alloc] init];
    [self addSubview:_topView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_topView addGestureRecognizer:tap];
    
}

- (void)hz_autoLayout {
    _tableView.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.font = [HZ_FontFile font:20];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _onClick ? _onClick(indexPath.row) : nil;
    [self dismiss];
}

- (void)onClick:(UIGestureRecognizer *)gest {
    CGPoint touchPoint = [gest locationInView:self];
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-_dataArray.count*_tableView.rowHeight);
    if (CGRectContainsPoint(rect,touchPoint) ) {
        [self dismiss];
    }
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.5 animations:^{
        alerView.hidden = YES;
    } completion:^(BOOL finished) {
        [alerView removeFromSuperview];
        alerView = nil;
    }];
    
}


- (void)show {
    alerView = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    alerView.frame = window.bounds;
    [window addSubview:alerView];
    
    window.userInteractionEnabled = NO;
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(self.dataArray.count*56);
//    }];
    CGFloat height = _dataArray.count * self.tableView.rowHeight+_tableView.sectionFooterHeight;
    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-height);
    [UIView animateWithDuration:0.5 animations:^{
        [window layoutIfNeeded];
        self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-height, CGRectGetWidth(self.frame), height);
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.7];
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}


- (NSArray<NSString *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
@end



