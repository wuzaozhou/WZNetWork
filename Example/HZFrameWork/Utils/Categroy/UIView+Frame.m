//
//  UIView+RYExtension.m
//  生活的味道2.0.0
//
//  Created by 兔兔 on 2017/8/17.
//  Copyright © 2017年 兔兔. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setHz_x:(CGFloat)hz_x {
    CGRect hzFrame = self.frame;
    hzFrame.origin.x = hz_x;
    self.frame = hzFrame;
}

- (CGFloat)hz_x {
    return self.frame.origin.x;
}

- (void)setHz_y:(CGFloat)hz_y {
    CGRect hzFrame = self.frame;
    hzFrame.origin.y = hz_y;
    self.frame = hzFrame;
}

- (CGFloat)hz_y {
    return self.frame.origin.y;
}

-(void)setHz_origin:(CGPoint)hz_origin {
    CGRect hzFrame = self.frame;
    hzFrame.origin = hz_origin;
    self.frame = hzFrame;
}

- (CGPoint)hz_origin {
    return self.frame.origin;
}


- (void)setHz_width:(CGFloat)hz_width {
    CGRect hzFrame = self.frame;
    hzFrame.size.width = hz_width;
    self.frame = hzFrame;
}

- (CGFloat)hz_width {
    return self.frame.size.width;
}

- (void)setHz_height:(CGFloat)hz_height {
    CGRect hzFrame = self.frame;
    hzFrame.size.height = hz_height;
    self.frame = hzFrame;
}

- (CGFloat)hz_height {
    return self.frame.size.height;
}

- (void)setHz_size:(CGSize)hz_size {
    CGRect hzFrame = self.frame;
    hzFrame.size = hz_size;
    self.frame = hzFrame;
}

- (CGSize)hz_size {
    return self.frame.size;
}


- (CGFloat)hz_centerX {
    return self.center.x;
}

- (void)setHz_centerX:(CGFloat)hz_centerX {
    CGPoint hzFrame = self.center;
    hzFrame.x = hz_centerX;
    self.center = hzFrame;
}

- (void)setHz_centerY:(CGFloat)hz_centerY {
    CGPoint hzFrame = self.center;
    hzFrame.y = hz_centerY;
    self.center = hzFrame;
}

- (CGFloat)hz_centerY {
    return self.center.y;
}

- (CGFloat)hz_right{
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)hz_bottom{
    
    return CGRectGetMaxY(self.frame);
}

- (void)setHz_right:(CGFloat)hz_right{
    
    self.hz_x = hz_right - self.hz_width;
}

- (void)setHz_bottom:(CGFloat)hz_bottom{
    
    self.hz_y = hz_bottom - self.hz_height;
}

@end
