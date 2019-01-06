//
//  HZ_BaseTableViewCellProtocol.h
//  FlowerTown
//
//  Created by JTom on 2018/12/3.
//  Copyright © 2018 HuaZhen. All rights reserved.
//TableViewCell协议

#import "HZ_BaseViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HZ_BaseTableViewCellProtocol <HZ_BaseViewProtocol>

@optional

/**
 通用的cell模式设置方法，一般不使用
 
 @param cellData model
 */
- (void)hz_setData:(id)cellData;

/**
 注册cell
 
 @param tableView tableview
 */
+ (void)registerCellWithTableView:(UITableView *)tableView;

/**
 返回cellID
 
 @return cellID
 */
+ (NSString *)CellID;

/**
 返回cell高度
 
 @return cell高度
 */
+ (CGFloat)CellHeigt;
@end

NS_ASSUME_NONNULL_END
