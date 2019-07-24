//
//  HZEmptyView.m
//  HZEmptyView
//
//  Created by 兔兔 on 2018/9/29.
//  Copyright © 2018年 tutu. All rights reserved.
//

#import "HZEmptyView.h"
#import <Masonry/Masonry.h>

@interface HZEmptyView()


@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation HZEmptyView

+ (instancetype)createEmptyViewWithType:(HZEmptyType)type {
    return [[HZEmptyView alloc] initWithType:type];
}


+ (instancetype)createEmptyViewWithType:(HZEmptyType)type resetBlock:(HZEmptyResetBlock)block {
    return [[HZEmptyView alloc] initWithType:type resetBlock:block];
}

#pragma mark -init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUpViews];
        _autoShowAndHideEmptyView = YES;
    }
    return self;
}

- (instancetype)initWithType:(HZEmptyType)type {
    if (self = [super init]) {
        _type = type;
        
    }
    return self;
}


- (instancetype)initWithType:(HZEmptyType)type resetBlock:(HZEmptyResetBlock)block {
    if (self = [self initWithType:type]) {
        _resetBlock = block;
    }
    return self;
}



- (void)setUpViews {
    
    self.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetButtonAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_imageView addGestureRecognizer:tap];
    [self addSubview:_imageView];
    
    [self setType:_type];
    
    [self hz_setAutoLayout];
}

- (void)hz_setAutoLayout {
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}


#pragma mark -- set
- (void)setType:(HZEmptyType)type {
    _type = type;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image;
    switch (type) {
        case HZEmptyTypeNotNetwork:{
            NSString *filePath1 = [bundle pathForResource:@"bg_wuwangluo@2x.png" ofType:nil inDirectory:@"HZFrameWork.bundle"];
            image = [UIImage imageWithContentsOfFile:filePath1];
        }
            break;
        case HZEmptyTypeNotContent: {
            NSString *filePath = [bundle pathForResource:@"bg_wunrong@2x.png" ofType:nil inDirectory:@"HZFrameWork.bundle"];
            image = [UIImage imageWithContentsOfFile:filePath];
        }
            break;
       default:
            break;
    }
    self.imageView.image = image;
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

- (void)resetButtonAction {
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
