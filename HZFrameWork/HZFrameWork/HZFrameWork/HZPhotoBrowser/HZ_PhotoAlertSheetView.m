//
//  HZ_PhotoAlertSheetView.m
//  AFNetworking
//
//  Created by 吴灶洲 on 2019/4/17.
//

#import "HZ_PhotoAlertSheetView.h"
#import <Masonry/Masonry.h>
#import "HZ_FontFile.h"
#import "HZTool.h"
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
    _tableView.backgroundColor = [[UIColor colorWithHexString:@"#737373"] colorWithAlphaComponent:0.51];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 56;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    _tableView.sectionHeaderHeight = CGFLOAT_MIN;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [HZTool isBangsPhone] ? 34 : CGFLOAT_MIN)];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = view;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return _type == HZ_PhotoAlertSheetTypeCancel ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == HZ_PhotoAlertSheetTypeCancel) {
        return section == 0 ? _dataArray.count : 1;
    }else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [HZ_FontFile mediumFont:18];
    
    if (_type == HZ_PhotoAlertSheetTypeCancel && indexPath.section == 1) {
        cell.textLabel.text = @"取消";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#272727"];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, [UIScreen mainScreen].bounds.size.width);
    }else {
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //    cell.textLabel.font = [HZ_FontFile font:20];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#686868"];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_type == HZ_PhotoAlertSheetTypeCancel) {
        return section == 1 ? 6 : CGFLOAT_MIN;
    }else {
        return CGFLOAT_MIN;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_type == HZ_PhotoAlertSheetTypeCancel && indexPath.section == 1) {
        
    }else {
        _onClick ? _onClick(indexPath.row) : nil;
    }
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
        self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGFLOAT_MIN);
    } completion:^(BOOL finished) {
        alerView.hidden = YES;
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
    CGFloat height = _dataArray.count * self.tableView.rowHeight+_tableView.sectionFooterHeight+([HZTool isBangsPhone] ? 34 : 0);
    if (_type == HZ_PhotoAlertSheetTypeCancel) {
        height += 6 + self.tableView.rowHeight;
    }
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



