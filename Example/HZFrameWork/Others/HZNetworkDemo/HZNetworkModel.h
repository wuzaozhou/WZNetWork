//
//  HZNetworkModel.h
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZNetworkModel : NSObject
@property (nonatomic,copy)NSString *wid; //id
@property (nonatomic,copy)NSString *name;//名字
@property (nonatomic,copy)NSString *detail;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
