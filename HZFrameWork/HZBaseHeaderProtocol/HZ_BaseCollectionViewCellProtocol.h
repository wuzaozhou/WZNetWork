//
//  HZ_BaseCollectionViewCellProtocol.h
//  FlowerTown
//
//  Created by JTom on 2018/12/3.
//  Copyright © 2018 HuaZhen. All rights reserved.
// CollectionViewCell协议

#import "HZ_BaseViewProtocol.h"


@protocol HZ_BaseCollectionViewCellProtocol <HZ_BaseViewProtocol>


@optional

/**
 通用的cell模式设置方法，一般不使用
 
 @param cellData model
 */
- (void)hz_SetData:(id)cellData;

/**
 注册cell
 
 @param collectionView collectionView
 */
+ (void)registerCellWithCollection:(UICollectionView *)collectionView;

/**
 返回cellID
 
 @return cellID
 */
+ (NSString *)CellID;

@end

