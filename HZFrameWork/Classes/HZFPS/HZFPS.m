//
//  WZZFPSView.m
//  WZZFPS
//
//  Created by 吴灶洲 on 2017/11/11.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "HZFPS.h"

@interface HZFPS ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;
@end

@implementation HZFPS

+ (void)showFPS {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat y = 0;
        if (statusRect.size.height > 20) {
            y = 44;
        }
        CGRect fpsViewFrame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, y, 80, 20);
        HZFPS *fpsview = [[HZFPS alloc] initWithFrame:fpsViewFrame];
        fpsview.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        [[UIApplication sharedApplication].keyWindow addSubview:fpsview];
    });
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    //添加拖拽手势-改变控件的位置
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewPostion:)];
    [self addGestureRecognizer:pan];
    
    __weak typeof(self) weakSelf = self;
    _displayLink = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(tick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    //设置颜色
    [attText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attText.length)];
    self.titleLabel.attributedText = attText;
    
}

- (void)changeViewPostion:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
    
    CGRect originalFrame = self.frame;
    
    originalFrame = [self changeXWithFrame:originalFrame point:point];
    originalFrame = [self changeYWithFrame:originalFrame point:point];
    
    self.frame = originalFrame;
    
    [pan setTranslation:CGPointZero inView:self];
    
    UIButton *button = (UIButton *)pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        button.enabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
    } else {
        
        CGRect frame = self.frame;
        
        if (self.center.x <= [UIScreen mainScreen].bounds.size.width / 2.0){
            frame.origin.x = 0;
        }else
        {
            frame.origin.x = [UIScreen mainScreen].bounds.size.width - frame.size.width;
        }
        
        if (frame.origin.y < 20) {
            frame.origin.y = 20;
        } else if (frame.origin.y + frame.size.height > [UIScreen mainScreen].bounds.size.height) {
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
        
        button.enabled = YES;
        
    }
}

//拖动改变控件的水平方向x值
- (CGRect)changeXWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    BOOL q1 = originalFrame.origin.x >= 0;
    BOOL q2 = originalFrame.origin.x + originalFrame.size.width <= [UIScreen mainScreen].bounds.size.width;
    
    if (q1 && q2) {
        originalFrame.origin.x += point.x;
    }
    return originalFrame;
}

//拖动改变控件的竖直方向y值
- (CGRect)changeYWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    
    BOOL q1 = originalFrame.origin.y >= 20;
    BOOL q2 = originalFrame.origin.y + originalFrame.size.height <= [UIScreen mainScreen].bounds.size.height;
    if (q1 && q2) {
        originalFrame.origin.y += point.y;
    }
    return originalFrame;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
}


@end
