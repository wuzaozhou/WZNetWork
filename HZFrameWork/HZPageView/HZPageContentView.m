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
@property (nonatomic, strong) UIViewController *parentViewController;
@end

@implementation HZPageContentView

- (instancetype)initWithChildArray:(NSArray<UIViewController *> *)childArray parentViewController:(UIViewController *) parentVC{
    self.childViewControllerArray = childArray;
    self.parentViewController = parentVC;
    return [super init];
}

- (instancetype)initWithChildArray:(NSArray<UIViewController *> *)childArray parentViewController:(UIViewController *) parentVC frame:(CGRect)frame {
    self.childViewControllerArray = childArray;
    self.parentViewController = parentVC;
    return [self initWithFrame:frame];
}

- (void)setPageContentViewWithTargetIndex:(NSUInteger)index{
    CGFloat targetIndex = index < self.childViewControllerArray.count? index: self.childViewControllerArray.count;
    [self.mainCollectionView setContentOffset:CGPointMake(targetIndex * self.frame.size.width, 0) animated:YES];
}
- (UIViewController *)getChildViewControllerWithIndex:(NSInteger)index{
    if (self.childViewControllerArray.count > index) {
        return self.childViewControllerArray[index];
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
    [self addSubview:self.mainCollectionView];
}

- (void)setupLayoutSubviews {
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.mainCollectionView reloadData];
}


#pragma mark-- lazy init
- (NSArray *)childViewControllerArray {
    if (!_childViewControllerArray) {
        _childViewControllerArray = [NSArray array];
    }
    return _childViewControllerArray;
}

- (UICollectionViewFlowLayout *)mainFlowLayout {
    if (!_mainFlowLayout) {
        _mainFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _mainFlowLayout.minimumLineSpacing = 0;
        _mainFlowLayout.minimumInteritemSpacing = 0;
        _mainFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _mainFlowLayout;
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mainFlowLayout];
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HZCollectionViewCellID];
        _mainCollectionView.bounds = NO;
    }
    return _mainCollectionView;
}

#pragma mark-- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HZCollectionViewCellID forIndexPath:indexPath];
    
    UIViewController *vc = self.childViewControllerArray[indexPath.row];
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
        [_delegate pageContentView:self index:scrollView.contentOffset.x / self.frame.size.width];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

@end
