//
//  HZPageTitleItemView.m
//  HZFramework
//
//  Created by lee on 2018/10/22.
//  Copyright © 2018年 leejtom. All rights reserved.
//

#import "HZPageTitleItemView.h"
#import "HZPageTitleViewModel.h"

@interface HZPageTitleItemView()

@property (nonatomic, strong) HZPageTitleViewModel *viewModel;
@property (nonatomic, copy) NSString *buttonTtitle;
@property (nonatomic, assign) NSInteger buttonTag;
@property (nonatomic, assign) CGSize badgeSize;

@end

@implementation HZPageTitleItemView

- (instancetype)initWithViewModel:(HZPageTitleViewModel *)viewModel frame:(CGRect)frame  tilte:(NSString *)title tag:(NSInteger)tag{
    if (self = [super initWithFrame:frame]) {
        self.viewModel = viewModel;
        self.buttonTtitle = title;
        self.buttonTag = tag;
        [self setupSubViews];
    }
    return self;
}

- (void)setBadgeWithNumber:(NSUInteger )number{
    self.badgeLabel.hidden = !number; //show or hidden
    if (self.badgeLabel.hidden) {
        return;
    }
 
    NSString *numberString = [NSString stringWithFormat:@"%tu", number];
    CGFloat stringWidth = self.viewModel.badgeFontSize;

    CGFloat margin;
    if(number == 1){//等于1，只显示小红点
        self.badgeSize = CGSizeMake(stringWidth, stringWidth);
        numberString = @"";
        margin = 10;
    }else if(number >= 2 && number <= 9){//1-9
        self.badgeSize = CGSizeMake(stringWidth+5, stringWidth+5);
        numberString = [NSString stringWithFormat:@"%tu", number];
        margin = 10;
        
    }else if(number >= 10 && number <= 99){//10-99
        margin = 13;
        self.badgeSize = CGSizeMake(stringWidth+margin, stringWidth+8);
        numberString = [NSString stringWithFormat:@"%tu", number];
    } else{//>99
        margin = 15;
        self.badgeSize = CGSizeMake(stringWidth+margin, stringWidth+8);
        numberString = @"99+";
    }
    
    self.badgeLabel.text = numberString;
    [self.badgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.button.mas_right).offset(-margin);
        make.bottom.mas_equalTo(self.button.mas_top).offset(5);
        make.size.mas_equalTo(self.badgeSize);
    }];
    self.badgeLabel.layer.cornerRadius = self.badgeSize.height / 2;
    
}

- (void)setupSubViews{
    [self addSubview:self.button];
    [self addSubview:self.badgeLabel];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.titleLabel.font = self.viewModel.titleFontNormal;
        [_button setTitle:self.buttonTtitle forState:UIControlStateNormal];
        _button.titleLabel.font = self.viewModel.titleFontNormal;
        [_button setTitle:self.buttonTtitle forState:(UIControlStateNormal)];
        [_button setTitleColor:self.viewModel.titleColorNormal forState:(UIControlStateNormal)];
        [_button setTitleColor:self.viewModel.titleColorSelected forState:(UIControlStateSelected)];
        _button.tag = self.buttonTag;
    }
    return _button;
}

- (UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = self.viewModel.badgeBackgroundColor;
        _badgeLabel.font = [UIFont systemFontOfSize:11];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.layer.masksToBounds = YES;
    }
    return _badgeLabel;
}

@end
