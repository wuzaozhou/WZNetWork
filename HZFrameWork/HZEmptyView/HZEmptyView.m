//
//  HZEmptyView.m
//  HZEmptyView
//
//  Created by 兔兔 on 2018/9/29.
//  Copyright © 2018年 tutu. All rights reserved.
//

#import "HZEmptyView.h"
#import "Masonry.h"
@interface HZEmptyView()

@property (nonatomic, assign) HZEmptyType type;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, assign) BOOL hideResetButton;

@end


@implementation HZEmptyView

+ (instancetype)createEmptyViewWithType:(HZEmptyType)type {
    return [[HZEmptyView alloc] initWithType:type];
}


+ (instancetype)createEmptyViewWithType:(HZEmptyType)type resetBlock:(HZEmptyResetBlock)block {
    return [[HZEmptyView alloc] initWithType:type resetBlock:block];
}

#pragma mark -init
- (instancetype)init {
    if (self == [super init]) {
        [self setUpViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpViews];
}


- (instancetype)initWithType:(HZEmptyType)type {
    self.type = type;
    return [super init];
}


- (instancetype)initWithType:(HZEmptyType)type resetBlock:(HZEmptyResetBlock)block {
    if (self = [self initWithType:type]) {
        _resetBlock = block;
    }
    return self;
}



- (void)setUpViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.resetButton];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize viewSize = self.bounds.size;
    if (viewSize.width ==0 || viewSize.height == 0) {
        viewSize = self.superview.bounds.size;
        self.frame = self.superview.bounds;
    }
    CGFloat margin = 15;
    CGFloat imageW = 200;
    CGFloat imageH = 100;
    CGFloat tipH = 14;
    CGFloat btnH = self.hideResetButton? 0: 35;
    CGFloat btnW = self.hideResetButton? 0: 100;
    CGFloat marginH = margin + (self.hideResetButton? 0: margin);
    CGFloat contentH = imageH + tipH + btnH + marginH;
    CGFloat topPoint = (viewSize.height - contentH)/2;
    
    UIView *supView = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageW, imageH));
        make.centerX.equalTo(supView);
        make.top.equalTo(supView).offset(topPoint);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(margin);
        make.height.mas_equalTo(tipH);
    }];
    
    if(!self.hideResetButton){
        [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(margin);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
    }
}

#pragma mark -- set
- (void)setType:(HZEmptyType)type {
    _type = type;
    UIImage *image;
    NSString *string;
    BOOL hideBtn = YES;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"empty_network.png" ofType:nil inDirectory:@"HZFrameWork.bundle"];
    //按钮 在无网络状态才显示
    switch (type) {
        case HZEmptyTypeNotNetwork:{
            image = [UIImage imageWithContentsOfFile:filePath];
            string = @"哎呀！！您的网络好像断了刷新试试吧";
            hideBtn = NO;
        }
            break;
        case HZEmptyTypeNotContent: {
            image = [UIImage imageWithContentsOfFile:filePath];
            string = @"暂无内容";
            hideBtn = YES;
        }
            break;
        default:
            break;
    }
    self.imageView.image = image;
    self.tipLabel.text = string;
    self.resetButton.hidden = hideBtn;
    self.hideResetButton = hideBtn;
}

#pragma mark -- init view
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] init];
        _resetButton.backgroundColor = [UIColor redColor];
        [_resetButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        _resetButton.layer.cornerRadius = 10;
        [_resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

#pragma mark -- method
- (void)show {
    [self.superview layoutSubviews];
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
}

- (void)dismiss {
    self.hidden = YES;
}

- (void)resetButtonAction:(UIButton *)btn {
    if(self.resetBlock){
        self.resetBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
