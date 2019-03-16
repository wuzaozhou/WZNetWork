//
//  HZPageContentView.m
//  HZFramework
//
//  Created by JTom on 2018/10/9.
//  Copyright © 2018年 leejtom. All rights reserved.
//

#import "HZPageContentView.h"
#import <Masonry/Masonry.h>

#define HZCollectionViewCellID @"HZCollectionViewCellID"

@interface HZPageContentView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *mainFlowLayout;
@property (nonatomic, strong) NSArray *childViewControllerArray;
@property (nonatomic, weak) UIViewController *parentViewController;

@end

@implementation HZPageContentView

- (instancetype)initWithChildArray:(NSArray<UIViewController *> *)childArray parentViewController:(UIViewController *) parentVC{
    _childViewControllerArray = childArray;
    _parentViewController = parentVC;
    return [super init];
}

- (instancetype)initWithChildArray:(NSArray<UIViewController *> *)childArray parentViewController:(UIViewController *) parentVC frame:(CGRect)frame {
    _childViewControllerArray = childArray;
    _parentViewController = parentVC;
    return [self initWithFrame:frame];
}

- (void)setPageContentViewWithTargetIndex:(NSUInteger)index{
    CGFloat targetIndex = index < _childViewControllerArray.count? index: _childViewControllerArray.count;
    [_mainCollectionView setContentOffset:CGPointMake(targetIndex * self.frame.size.width, 0) animated:YES];
}
- (UIViewController *)getChildViewControllerWithIndex:(NSInteger)index{
    if (_childViewControllerArray.count > index) {
        return _childViewControllerArray[index];
    }else
        return [[UIViewController alloc] init];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubViews];
    [self setupLayoutSubviews];
    
}

- (void)setupSubViews {
    _mainFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _mainFlowLayout.minimumLineSpacing = 0;
    _mainFlowLayout.minimumInteritemSpacing = 0;
    _mainFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_mainFlowLayout];
    _mainCollectionView.backgroundColor = [UIColor whiteColor];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.pagingEnabled = YES;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HZCollectionViewCellID];
    _mainCollectionView.bounces = NO;
    
    [self addSubview:_mainCollectionView];
}

- (void)setupLayoutSubviews {
    [_mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_mainCollectionView reloadData];
}


#pragma mark-- lazy init
- (NSArray *)childViewControllerArray {
    if (!_childViewControllerArray) {
        _childViewControllerArray = [NSArray array];
    }
    return _childViewControllerArray;
}

//- (UICollectionViewFlowLayout *)mainFlowLayout {
//    if (!_mainFlowLayout) {
//        _mainFlowLayout = [[UICollectionViewFlowLayout alloc] init];
//        _mainFlowLayout.minimumLineSpacing = 0;
//        _mainFlowLayout.minimumInteritemSpacing = 0;
//        _mainFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    }
//    return _mainFlowLayout;
//}

//- (UICollectionView *)mainCollectionView {
//    if (!_mainCollectionView) {
//        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mainFlowLayout];
//        _mainCollectionView.backgroundColor = [UIColor whiteColor];
//        _mainCollectionView.delegate = self;
//        _mainCollectionView.dataSource = self;
//        _mainCollectionView.pagingEnabled = YES;
//        _mainCollectionView.showsVerticalScrollIndicator = NO;
//        _mainCollectionView.showsHorizontalScrollIndicator = NO;
//        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HZCollectionViewCellID];
//        _mainCollectionView.bounces = NO;
//    }
//    return _mainCollectionView;
//}

#pragma mark-- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _childViewControllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HZCollectionViewCellID forIndexPath:indexPath];
    
    UIViewController *vc = _childViewControllerArray[indexPath.row];
    vc.view.frame = self.bounds;
    [self.parentViewController addChildViewController:vc]; //A
    [cell.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self.parentViewController]; //B
    return cell;
    //A B这两个操作是为了让子vc继承父vc的一些方法，比如navigation push等等。。
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(pageContentView:index:)]) {
        _selectorIndex = scrollView.contentOffset.x / self.frame.size.width;
        [_delegate pageContentView:self index:_selectorIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

@end
