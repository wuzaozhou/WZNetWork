//
//  HZoffLineDownLoadViewController.h
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/18.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "BaseViewController.h"

@protocol offlineDelegate <NSObject>
- (void)reloadJsonNumber;
- (void)downloadWithArray:(NSMutableArray *)offlineArray;
@end


@interface HZoffLineDownLoadViewController : BaseViewController
@property (nonatomic,weak) id<offlineDelegate>delegate;
@end
