//
//  HZ_PhotoBrowserView.m
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/11/21.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import "HZ_PhotoBrowserView.h"
#import "HZ_LoadingView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

CGFloat const kMinZoomScale = 0.6f;
CGFloat const kMaxZoomScale = 2.0f;

@implementation HZ_ProgressModel

@end

@interface HZ_PhotoBrowserView() <UIScrollViewDelegate>
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) HZ_LoadingView *loadingView;
@property (nonatomic, strong) UIButton *reloadButton;
@end

@implementation HZ_PhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hz_addSubViews];
    }
    return self;
}

- (void)hz_addSubViews {
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.frame = CGRectZero;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    [_scrollview addSubview:self.imageview];
    _scrollview.delegate = self;
    _scrollview.clipsToBounds = YES;
    [self.contentView addSubview:_scrollview];
    
    //添加进度指示器
    _loadingView = [[HZ_LoadingView alloc] init];
    [self.contentView addSubview:_loadingView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadButton = button;
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    [button setTitle:@"图片加载失败，点击重新加载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
    button.hidden = YES;
    [self.contentView addSubview:button];
    [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

- (void)adjustFrame {
    CGRect frame = self.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;//获得图片的size
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        CGFloat ratio = frame.size.width/imageFrame.size.width;
        imageFrame.size.height = imageFrame.size.height*ratio;
        imageFrame.size.width = frame.size.width;
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        
        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        //初始化
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        //重置内容大小
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
    self.zoomImageSize = self.imageview.frame.size;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageview;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.zoomImageSize = view.frame.size;
    self.scrollOffset = scrollView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(self.scrollViewWillEndDragging){
        self.scrollViewWillEndDragging(velocity, scrollView.contentOffset);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollViewDidEndDecelerating) {
        self.scrollViewDidEndDecelerating();
    }
}
//这里是缩放进行时调整
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.scrollOffset = scrollView.contentOffset;
    if (self.scrollViewDidScroll) {
        self.scrollViewDidScroll(self.scrollOffset);
    }
}

#pragma mark getter setter
- (YYAnimatedImageView *)imageview {
    if (!_imageview) {
        _imageview = [[YYAnimatedImageView alloc] init];
        _imageview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _imageview.userInteractionEnabled = YES;
    }
    return _imageview;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    _imageUrl = url;
    _placeHolderImage = placeholder;
    [self reloadImage];
}


- (void)reloadImage {
    _loadingView.hidden = NO;
    _reloadButton.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [_imageview setImageWithURL:_imageUrl placeholder:_placeHolderImage options:YYWebImageOptionSetImageWithFadeAnimation|YYWebImageOptionIgnoreFailedURL progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //在主线程做UI更新
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.loadingView.progress = (CGFloat)receivedSize / expectedSize;
        });
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        weakSelf.loadingView.hidden = YES;
        if (error == nil && image != nil) {
            [weakSelf setNeedsLayout];
            weakSelf.reloadButton.hidden = YES;
        }else {
            weakSelf.reloadButton.hidden = NO;
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollview.frame = self.bounds;
    [self adjustFrame];
}

@end
