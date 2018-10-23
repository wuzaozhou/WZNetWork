//
//  HZPageTitleView.m
//  FlowerTown
//
//  Created by lee on 2018/9/29.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import "HZPageTitleView.h"
#import "HZPageTitleItemView.h"
#import <Masonry/Masonry.h>

#define HZPageTitleViewWidth self.frame.size.width
#define HZPageTitleViewHeight self.frame.size.height
#define HZSize CGSizeMake(HZPageTitleViewWidth, HZPageTitleViewHeight)

#define weak_Self __weak typeof(self) weakSelf = self
#define strong_Self __strong typeof((weakSelf)) strongSelf = (weakSelf)


@interface HZPageTitleView()

@property (nonatomic, strong) UIScrollView *contenView;

@property (nonatomic, strong) NSMutableArray<UIView *> *indicatorArray;
// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
// 指示器
@property (nonatomic, strong) UIView *indicatorView;
// 底部分割线
@property (nonatomic, strong) UIView *bottomSeparator;
// 当前选中按钮
//@property (nonatomic, strong) UIButton *currentSelectButton;
@property (nonatomic, strong) HZPageTitleItemView *currentSelectItem;
// 当前选中按钮的下标
@property (nonatomic, assign) CGFloat currentSelectButtonIndex;
// 记录所有按钮文字宽度
@property (nonatomic, assign) CGFloat allBtnTextWidth;
// 记录所有子控件的宽度
@property (nonatomic, assign) CGFloat allBtnWidth;
// 角标，消息提示
@property (nonatomic, strong) UIView *badgeView;
// 角标label
@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation HZPageTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//         [self setSubView];
    }
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)array frame:(CGRect)frame configuration:(HZPageTitleViewModel *)config{
    self.titleArray = array;
    self.viewModel = config;
    return [self initWithFrame:frame];
}

- (void)setPageTileViewWithTargetIndex:(NSInteger)targetIndex{
    targetIndex = targetIndex < self.buttonArray.count? targetIndex: self.buttonArray.count;
    
    HZPageTitleItemView *targetItem = self.buttonArray[targetIndex];
    self.currentSelectButtonIndex = targetItem.button.tag;
    [self changeButtonSelectedWithButton:targetItem];
    [self changeIndicatorViewWithButton:targetItem];
    [self selectedCenterWithButton:targetItem];
}

- (void)setBadgeWithNumber:(NSUInteger )number index:(NSInteger)targetIndex{
    if (self.titleArray.count > targetIndex) {
        HZPageTitleItemView *item = self.buttonArray[targetIndex];
        [item setBadgeWithNumber:number];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSubView];
}

- (void)setSubView {
    [self addSubview:self.scrollView];
    [self addSubview:self.bottomSeparator];
    [self setLayout];
    [self setTitleButtons];
    [self.scrollView insertSubview:self.indicatorView atIndex:0];
}

- (void)setLayout{
    
    [self.bottomSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.bottomSeparator.mas_top);
    }];
}

- (void)setTitleButtons{
    NSInteger titleCount = self.titleArray.count;
    weak_Self;
    [self.titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        strong_Self;
        CGSize tempSize = [self sizeWithString:obj font:strongSelf.viewModel.titleFontSelected];
        CGFloat tempWidth = tempSize.width;
        self.allBtnTextWidth += tempWidth;
    }];
    
    self.allBtnWidth = self.allBtnTextWidth + self.viewModel.titleAdditionalWidth * titleCount;
    self.allBtnWidth = ceilf(self.allBtnWidth);
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnH = HZPageTitleViewHeight - self.viewModel.bottomSparatorHeight;
    CGFloat btnW;
     // 1、添加按钮
    for (NSInteger index = 0; index < titleCount; index++) {
        CGSize tempSize = [self sizeWithString:self.titleArray[index] font:self.viewModel.titleFontSelected];
        
        //自定义的宽度
        if (self.viewModel.customTitleItemViewWidth) {
            btnW = self.viewModel.titleItemViewWidth;
            if (index == 0) {
                CGRect frame = self.indicatorView.frame;
                frame.origin.x = (self.viewModel.titleItemViewWidth - tempSize.width) /2;
                self.indicatorView.frame = frame;
                self.scrollView.bounces = NO;
            }
        } else {
            btnW = tempSize.width + self.viewModel.titleAdditionalWidth;
        }
        
        HZPageTitleItemView *itemView = [[HZPageTitleItemView alloc] initWithViewModel:self.viewModel frame:CGRectMake(btnX, btnY, btnW, btnH) tilte:self.titleArray[index] tag:index];
        [itemView.button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
   
        btnX = btnX + btnW;
        [self.buttonArray addObject:itemView];
        [self.scrollView addSubview:itemView];
    }
    
    CGFloat scrollViewWidth = CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth, HZPageTitleViewHeight);
    //保存第一个按钮，默认选中第一个
    self.currentSelectItem = self.buttonArray.firstObject;
    [self changeButtonSelectedWithButton:self.currentSelectItem];
    [self changeIndicatorViewWithButton:self.currentSelectItem];
}

- (UIButton *)creteButtonWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    button.titleLabel.font = self.viewModel.titleFontNormal;
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:self.viewModel.titleColorNormal forState:(UIControlStateNormal)];
    [button setTitleColor:self.viewModel.titleColorSelected forState:(UIControlStateSelected)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}

#pragma mark--自定义方法
/**
 按钮点击事件

 @param button 点击的按钮
 */
- (void)buttonAction:(UIButton *)button {
    //1
    [self changeButtonSelectedWithButton:self.buttonArray[button.tag]];
    //2
    [self selectedCenterWithButton:self.buttonArray[button.tag]];
    //3
    [self changeIndicatorViewWithButton:self.buttonArray[button.tag]];
    //4
    if (_delegate && [_delegate respondsToSelector:@selector(pageTitleViewDidSelectIndex:)]) {
        [_delegate pageTitleViewDidSelectIndex:button.tag];
    }
    //5
    self.currentSelectButtonIndex = button.tag;
}

/**
 改变按钮选中效果
 */
- (void)changeButtonSelectedWithButton:(HZPageTitleItemView *)item {
    if (!self.currentSelectItem) {//第一次点击
        item.button.selected = YES;
        self.currentSelectItem = item;
        self.currentSelectItem.button.titleLabel.font = self.viewModel.titleFontSelected;
    } else {
        if (self.currentSelectItem == item){//重复点击
            item.button.selected = YES;
            item.button.titleLabel.font = self.viewModel.titleFontSelected;
        } else if (self.currentSelectItem != item ){
            self.currentSelectItem.button.selected = NO;
            self.currentSelectItem.button.titleLabel.font = self.viewModel.titleFontNormal;
            
            item.button.selected = YES;
            self.currentSelectItem = item;
            self.currentSelectItem.button.titleLabel.font = self.viewModel.titleFontSelected;
        }
    }
}

/**
 改变指示器
 */
- (void)changeIndicatorViewWithButton:(HZPageTitleItemView *) item{
    //获取当前button文字宽度,默认使用titleFontNormal字体
    CGSize titleSize = [self sizeWithString:item.button.titleLabel.text font:self.viewModel.titleFontNormal];

    [UIView animateWithDuration:0.1 animations:^{
        //设置指示器frame
        CGRect frame = self.indicatorView.frame;
        frame.size.width = self.viewModel.indicatorViewWidth?self.viewModel.indicatorViewWidth: titleSize.width;
        
        self.indicatorView.frame = frame;
        
        self.indicatorView.center = CGPointMake(item.center.x, self.indicatorView.center.y);
    }];
}

/**
 选中的按钮居中
 */
- (void)selectedCenterWithButton:(HZPageTitleItemView *)item {
    //内容没有超出一屏时不做居中处理
    if (self.allBtnWidth <= self.frame.size.width) {
        return ;
    }
    //计算偏移量
    CGFloat offsetX = item.center.x - HZPageTitleViewWidth / 2;
    offsetX = offsetX <= 0? 0 : offsetX;
    //计算最大的偏移量
    CGFloat maxOffsetX = self.scrollView.contentSize.width - HZPageTitleViewWidth;
    offsetX = offsetX > maxOffsetX? maxOffsetX: offsetX;
    //居中
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - 计算字符串尺寸
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName: font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (NSMutableArray<HZPageTitleItemView *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray<UIView *> *)indicatorArray {
    if (!_indicatorArray) {
        _indicatorArray = [NSMutableArray array];
    }
    return _indicatorArray;
}

- (UIScrollView *)contenView {
    if(!_contenView){
        _contenView = [[UIScrollView alloc] init];
    }
    return _contenView;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc] init];
        _bottomSeparator.backgroundColor = self.viewModel.bottomSparatorColor;
        _bottomSeparator.layer.cornerRadius = self.viewModel.bottomSparatorCornerRadius;
    }
    return _bottomSeparator;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = self.viewModel.indicatorViewColor;
        CGSize tempSize = [self sizeWithString:self.titleArray.firstObject font:self.viewModel.titleFontNormal];
        CGRect frame = CGRectMake(self.viewModel.titleAdditionalWidth / 2, self.frame.size.height - self.viewModel.indicatorViewHeight, self.viewModel.indicatorViewWidth?self.viewModel.indicatorViewWidth: tempSize.width, self.viewModel.indicatorViewHeight);
        _indicatorView.frame = frame;
    }
    return _indicatorView;
}

- (HZPageTitleViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HZPageTitleViewModel alloc] init];
    }
    return _viewModel;
}

- (UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.font = [UIFont systemFontOfSize:self.viewModel.badgeFontSize];
        _badgeLabel.textColor = self.viewModel.badgeTitleColor;
    }
    return _badgeLabel;
}

- (UIView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[UIView alloc] init];
        _badgeView.backgroundColor = self.viewModel.badgeBackgroundColor;
    }
    return _badgeView;
}

@end
