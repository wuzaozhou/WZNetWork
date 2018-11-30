//
//  HZ_PhotoBrowserView.h
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/11/21.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZ_ProgressModel : NSObject
@property (nonatomic, assign) CGFloat progress;
@end

@interface HZ_PhotoBrowserView : UICollectionViewCell
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) YYAnimatedImageView *imageview;

@property (nonatomic, assign) CGSize zoomImageSize;
@property (nonatomic, assign) CGPoint scrollOffset;
@property (nonatomic, strong) void(^scrollViewDidScroll)(CGPoint offset);
@property (nonatomic, copy) void(^scrollViewWillEndDragging)(CGPoint velocity,CGPoint offset);//返回scrollView滚动速度
@property (nonatomic,copy) void(^scrollViewDidEndDecelerating)(void);
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end

NS_ASSUME_NONNULL_END
