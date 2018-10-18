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


@interface DetailsModel : NSObject
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *wid;
@property (nonatomic,copy)NSString *weburl;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
