//
//  UIView+HZKit.m
//  HZEmptyView
//
//  Created by 兔兔 on 2018/9/29.
//  Copyright © 2018年 tutu. All rights reserved.
//

#import "UIView+HZKit.h"
#import <objc/runtime.h>
#import "HZEmptyView.h"
#import <Masonry/Masonry.h>

@implementation UIView (HZKit)
static char  kHZEmptyView;
static char  kIsFirst;

+ (void)hz_exchangeInstanceMethod:(SEL)method targetMethod:(SEL)target{
    method_exchangeImplementations(class_getInstanceMethod(self, method), class_getInstanceMethod(self, target));
}

- (void)setEmptyView:(HZEmptyView *)emptyView {
    if (emptyView != self.emptyView) {
        objc_setAssociatedObject(self, &kHZEmptyView, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[HZEmptyView class]]) {
                [view removeFromSuperview];
            }
        }
        
        [self addSubview:self.emptyView];
        [self setEmptyViewAutoLayout];
        self.emptyView.hidden = YES;
    }
}


- (void)getDataCountAndSet {
    if (!self.emptyView) {
        return;
    }
    if ([self itemTotalCount] > 0 || self.isFist == 0) {
        [self hide];
    }else {
        [self show];
    }
    self.isFist = 1;
}


- (void)show {
    if (!self.emptyView.autoShowAndHideEmptyView) {
        self.emptyView.hidden = NO;
        return;
    }
    [self hz_showEmptyView];
}


- (void)hide {
    if (!self.emptyView.autoShowAndHideEmptyView) {
        self.emptyView.hidden = YES;
        return;
    }
    [self hz_hideEmptyView];
}



- (void)hz_showEmptyView {
    [self.emptyView.superview layoutSubviews];
    self.emptyView.hidden = NO;
    [self bringSubviewToFront:self.emptyView];
    [self setEmptyViewAutoLayout];
}

- (void)hz_hideEmptyView {
    self.emptyView.hidden = YES;
}


- (void)hz_startLoading {
    self.emptyView.hidden = NO;
    [self setEmptyViewAutoLayout];
}

- (void)hz_endLoading {
    self.emptyView.hidden = [self itemTotalCount];
    [self setEmptyViewAutoLayout];
}

- (void)setEmptyViewAutoLayout {
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.center.equalTo(self);
    }];
    [self setNeedsLayout];
}

- (NSInteger)itemTotalCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (HZEmptyView *)emptyView {
   return  objc_getAssociatedObject(self, &kHZEmptyView);
}

- (void)setIsFist:(int)isFist {
    objc_setAssociatedObject(self, &kIsFirst, @(isFist), OBJC_ASSOCIATION_RETAIN);
}

- (int)isFist {
    return [objc_getAssociatedObject(self, &kIsFirst) intValue];
}


@end


@implementation UITableView (HZEmptyView)
+ (void)load {
    [self hz_exchangeInstanceMethod:@selector(reloadData) targetMethod:@selector(hz_tableViewReloadData)];
}

- (void)hz_tableViewReloadData {
    [self hz_tableViewReloadData];
    [self getDataCountAndSet];
}

@end


@implementation UICollectionView (HZEmptyView)
+ (void)load {
    [self hz_exchangeInstanceMethod:@selector(reloadData) targetMethod:@selector(hz_collectionViewReloadData)];
}

- (void)hz_collectionViewReloadData {
    [self hz_collectionViewReloadData];
    [self getDataCountAndSet];
}

@end
