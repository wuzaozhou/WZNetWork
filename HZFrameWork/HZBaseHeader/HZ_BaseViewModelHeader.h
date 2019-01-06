//
//  HZ_BaseViewModelHeader.h
//  FlowerTown
//
//  Created by JTom on 2018/12/3.
//  Copyright © 2018 HuaZhen. All rights reserved.
//viewModel基类头文件，放一些通用block

#ifndef HZ_BaseViewModelHeader_h
#define HZ_BaseViewModelHeader_h

///请求成功的Block
typedef void(^HZ_BaseHttpRequestSuccess)(void);
///请求失败的Block
typedef void(^HZ_BaseHttpRequestFailed)(NSError *error);

///上拉请求成功的Block
typedef void(^HZ_BaseHttpRequestSuccessWithHasMoreData)(BOOL hasMore);

#endif /* HZ_BaseViewModelHeader_h */
