//
//  HZ_PhotoBrowser.m
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/11/21.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import "HZ_PhotoBrowser.h"
#import <Masonry/Masonry.h>
#import "HZ_PhotoBrowserView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "HZ_PhotoAlertSheetView.h"
#import <HZHUD.h>

CGFloat const HZPhotoBrowserImageViewMargin = 10;
CGFloat const kSpacing = 5;
static HZ_PhotoBrowser *photoBrowser;

@interface HZ_PhotoBrowser ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIImageView *tempView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) HZ_PhotoBrowserView *photoBrowserView;
@property (nonatomic, strong) UICollectionView *scrollView;
@property (nonatomic, assign) BOOL hasShowedFistView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIViewController *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation HZ_PhotoBrowser

//当视图移动完成后调用
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    //处理下标可能越界的bug
    _currentImageIndex = _currentImageIndex < 0 ? 0 : _currentImageIndex;
    NSInteger count = _imageCount - 1;
    if (count > 0) {
        if (_currentImageIndex > count) {
            _currentImageIndex = 0;
        }
    }
    [self setupScrollView];
    [self setupToolbars];
    [self addGestureRecognizer:self.singleTap];
    [self addGestureRecognizer:self.doubleTap];
    [self addGestureRecognizer:self.pan];
    self.photoBrowserView = (HZ_PhotoBrowserView *)[_scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentImageIndex inSection:0]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.imageCount) {
        HZ_PhotoBrowserView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HZ_PhotoBrowserView" forIndexPath:indexPath];
        if ([self highQualityImageURLForIndex:indexPath.row]) {
            [cell setImageWithURL:[self highQualityImageURLForIndex:indexPath.row] placeholderImage:[self placeholderImageForIndex:indexPath.row]];
        } else {
            cell.imageview.image = [self placeholderImageForIndex:indexPath.row];
        }
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (void)showFirstImage {
    self.userInteractionEnabled = NO;
    if (_photoBrowserStyle == HZ_PhotoBrowserStyleNine) {
        UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
        CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.frame = rect;
        tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
        [self addSubview:tempView];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGFloat placeImageSizeW = tempView.image.size.width;
        CGFloat placeImageSizeH = tempView.image.size.height;
        CGRect targetTemp;
        CGFloat selfW = self.frame.size.width;
        CGFloat selfH = self.frame.size.height;
        
        CGFloat placeHolderH = (placeImageSizeH * selfW)/placeImageSizeW;
        if (placeHolderH <= selfH) {
            targetTemp = CGRectMake(0, (selfH - placeHolderH) * 0.5 , selfW, placeHolderH);
        } else {//图片高度>屏幕高度
            targetTemp = CGRectMake(0, 0, selfW, placeHolderH);
        }
        //先隐藏scrollview
        _scrollView.hidden = YES;
        _indexLabel.hidden = YES;
        _saveButton.hidden = YES;
        [UIView animateWithDuration:0.35f animations:^{
            //将点击的临时imageview动画放大到和目标imageview一样大
            tempView.frame = targetTemp;
        } completion:^(BOOL finished) {
            //动画完成后，删除临时imageview，让目标imageview显示
            _hasShowedFistView = YES;
            [tempView removeFromSuperview];
            _scrollView.hidden = NO;
            _indexLabel.hidden = NO;
            _saveButton.hidden = NO;
            self.userInteractionEnabled = YES;
            [_scrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentImageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }];
    }else {
        [_scrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentImageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        _photoBrowserView.alpha = 0;
        _contentView.view.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            //将点击的临时imageview动画放大到和目标imageview一样大
            _photoBrowserView.alpha = 1;
            _contentView.view.alpha = 1;
        } completion:^(BOOL finished) {
            _hasShowedFistView = YES;
            self.userInteractionEnabled = YES;
        }];
    }
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.dataSource photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.dataSource photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

//保存图像
- (void)saveImage {
    
    HZ_PhotoAlertSheetView *alertView = [[HZ_PhotoAlertSheetView alloc] init];
    alertView.dataArray = @[@"保存图片"];
    [alertView show];
    alertView.onClick = ^(NSInteger index) {
        [self save];
    };
    
    return;
}

- (void)save {
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    HZ_PhotoBrowserView *currentView = (HZ_PhotoBrowserView *)[_scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (currentView.imageview == nil) {
        return;
    }
    if ([[self highQualityImageURLForIndex:index].absoluteString hasSuffix:@".gif"]) {
        NSData *data = [NSData dataWithContentsOfURL:[self highQualityImageURLForIndex:index] options:0 error:nil];// 保存到本地相册
        if (data == nil) {
            return;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            [self saveHint:!error ? @"图片保存成功":@"图片保存失败"];
            NSLog(@"Success at %@", [assetURL path] );
        }];
    }else {
        UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self saveHint:!error ? @"图片保存成功":@"图片保存失败"];
}

- (void)saveHint:(NSString *)message {
    [HZHUD showWithText:message afterDelay:1.0];
}

- (void)hidePhotoBrowser {
    if (photoBrowser == nil) {
        return;
    }
    [self prepareForHide];
    [self hideAnimation];
}

- (void)hideAnimation {
    self.userInteractionEnabled = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    CGRect targetTemp;
    if (self.photoBrowserStyle == HZ_PhotoBrowserStyleNine) {
        UIView *sourceView = [self getSourceView];
        if (!sourceView) {
            targetTemp = CGRectMake(window.center.x, window.center.y, 0, 0);
        }
        targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        [UIView animateWithDuration:0.35f animations:^{
            _tempView.transform = CGAffineTransformInvert(self.transform);
            _coverView.alpha = 0;
            _tempView.frame = targetTemp;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_tempView removeFromSuperview];
            _tempView = nil;
            [_contentView.view removeFromSuperview];
            _contentView = nil;
            photoBrowser = nil;
        }];
    }else {
        targetTemp = [self.sourceImagesContainerView convertRect:_sourceView.frame toView:self];
        [UIView animateWithDuration:0.35f animations:^{
            _tempView.transform = CGAffineTransformInvert(self.transform);
            _coverView.alpha = 0;
            _tempView.frame = targetTemp;
            _tempView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_tempView removeFromSuperview];
            _tempView = nil;
            [_contentView.view removeFromSuperview];
            _contentView = nil;
            photoBrowser = nil;
            
        }];
    }
}

- (void)prepareForHide {
    [_contentView.view insertSubview:self.coverView belowSubview:self];
    _saveButton.hidden = YES;
    _indexLabel.hidden = YES;
    _photoBrowserView.hidden = YES;
    [self addSubview:self.tempView];
    self.backgroundColor = [UIColor clearColor];
    _contentView.view.backgroundColor = [UIColor clearColor];
    _scrollView.hidden = YES;
}

- (UIView *)getSourceView {
    if (_currentImageIndex <= self.sourceImagesContainerView.subviews.count - 1) {
        UIView *sourceView = self.sourceImagesContainerView.subviews[_currentImageIndex];
        return sourceView;
    }
    return nil;
}

- (void)bounceToOrigin {
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.35f animations:^{
        self.tempView.transform = CGAffineTransformIdentity;
        _coverView.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        _scrollView.hidden = NO;
        _saveButton.hidden = NO;
        _indexLabel.hidden = NO;
        [_tempView removeFromSuperview];
        [_coverView removeFromSuperview];
        _tempView = nil;
        _coverView = nil;
        _photoBrowserView.hidden = NO;
        _contentView.view.backgroundColor = [UIColor blackColor];
        UIView *view = [self getSourceView];
        view.hidden = NO;
    }];
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
}

//scrollview结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    _pageControl.currentPage = self.currentImageIndex;
}

#pragma mark - tap
/** 单击 */
- (void)photoClick:(UITapGestureRecognizer *)recognizer {
    [self hidePhotoBrowser];
}

/** 双击 */
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    HZ_PhotoBrowserView *view = (HZ_PhotoBrowserView *)[_scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentImageIndex inSection:0]];
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
        [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark 长按
- (void)didPan:(UIPanGestureRecognizer *)panGesture {
    //transPoint : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
    //locationPoint ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
    //velocity： 手指在视图上移动的速度（x,y）, 正负也是代表方向。
    CGPoint transPoint = [panGesture translationInView:self];
    //    CGPoint locationPoint = [panGesture locationInView:self];
    CGPoint velocity = [panGesture velocityInView:self];//速度
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self prepareForHide];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            _saveButton.hidden = YES;
            _indexLabel.hidden = YES;
            double delt = 1 - fabs(transPoint.y) / self.frame.size.height;
            delt = MAX(delt, 0);
            double s = MAX(delt, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(transPoint.x/s, transPoint.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            self.tempView.transform = CGAffineTransformConcat(translation, scale);
            self.coverView.alpha = delt;
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (fabs(transPoint.y) > 220 || fabs(velocity.y) > 500) {//退出图片浏览器
                [self hideAnimation];
            } else {//回到原来的位置
                [self bounceToOrigin];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark public methods
- (void)show {
    if (photoBrowser) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    _contentView = [[UIViewController alloc] init];
    _contentView.view.backgroundColor = [UIColor blackColor];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.view.center = window.center;
    _contentView.view.bounds = window.bounds;
    
    if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
        self.frame = CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 34);
    } else {
        self.frame = _contentView.view.bounds;
    }
    window.windowLevel = UIWindowLevelStatusBar+10.0f;//隐藏状态栏
    [_contentView.view addSubview:self];
    [window addSubview:_contentView.view];
    
    photoBrowser = self;
}


#pragma mark getter settter
-(void)setSourceImagesContainerView:(UIView *)sourceImagesContainerView{
    _sourceImagesContainerView = sourceImagesContainerView;
}

- (UITapGestureRecognizer *)singleTap {
    if (_singleTap == nil) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (_doubleTap == nil) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)pan {
    if (_pan == nil) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    }
    return _pan;
}

- (UIImageView *)tempView{
    if (_tempView == nil) {
        HZ_PhotoBrowserView *photoBrowserView = (HZ_PhotoBrowserView *)[_scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentImageIndex inSection:0]];
        UIImageView *currentImageView = photoBrowserView.imageview;
        CGFloat tempImageX = currentImageView.frame.origin.x - photoBrowserView.scrollOffset.x;
        CGFloat tempImageY = currentImageView.frame.origin.y - photoBrowserView.scrollOffset.y;
        CGFloat tempImageW = photoBrowserView.zoomImageSize.width;
        CGFloat tempImageH = photoBrowserView.zoomImageSize.height;
        _tempView = [[UIImageView alloc] init];
        _tempView.contentMode = UIViewContentModeScaleAspectFill;
        _tempView.clipsToBounds = YES;
        _tempView.frame = CGRectMake(tempImageX, tempImageY, tempImageW, tempImageH);
        _tempView.image = currentImageView.image;
    }
    return _tempView;
}

//做颜色渐变动画的view，让退出动画更加柔和
- (UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _coverView;
}

- (void)setPhotoBrowserView:(HZ_PhotoBrowserView *)photoBrowserView{
    _photoBrowserView = photoBrowserView;
    __weak typeof(self) weakSelf = self;
    _photoBrowserView.scrollViewWillEndDragging = ^(CGPoint velocity,CGPoint offset) {
        if (((velocity.y < -2 && offset.y < 0) || offset.y < -100)) {
            [weakSelf hidePhotoBrowser];
        }
    };
}

- (void)setCurrentImageIndex:(int)currentImageIndex{
    _currentImageIndex = currentImageIndex < 0 ? 0 : currentImageIndex;
    NSInteger count0 = _imageCount;
    if (count0 > 0) {
        if (_currentImageIndex > count0) {
            _currentImageIndex = 0;
        }
    }
}

- (void)setupToolbars {
    // 1. 序标
    if (self.imageCount > 9) {
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.font = [UIFont boldSystemFontOfSize:20];
        indexLabel.clipsToBounds = YES;
        if (self.imageCount > 1) {
            indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
            _indexLabel = indexLabel;
            [self addSubview:indexLabel];
            [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(30);
                make.centerX.equalTo(self);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(30);
            }];
        }
    }
    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"download_icon@2x.png" ofType:nil inDirectory:@"HZFrameWork.bundle"];
    [saveButton setImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
    saveButton.imageView.contentMode = UIViewContentModeRedraw;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
}


- (void)setupScrollView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scrollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _scrollView.delegate = self;
    _scrollView.dataSource = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView registerClass:[HZ_PhotoBrowserView class] forCellWithReuseIdentifier:@"HZ_PhotoBrowserView"];
    [self addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    if (self.imageCount <= 9) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.imageCount;
        _pageControl.currentPage = self.currentImageIndex;
        [self addSubview:_pageControl];
        
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            } else {
                make.bottom.equalTo(self).offset(-10);
            }
            make.centerX.equalTo(self);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(40);
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
}
@end
