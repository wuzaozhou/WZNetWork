//
//  HZCacheManager.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/16.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

NSString *const PathSpace =@"HZKit";
NSString *const defaultCachePath =@"AppCache";
static const NSInteger defaultCacheMaxCacheAge  = 60*60*24*7;
//static const NSInteger defaultCacheMixCacheAge = 60;
static const CGFloat unit = 1000.0;
@interface HZCacheManager ()
@property (nonatomic ,copy)NSString *diskCachePath;
@property (nonatomic ,strong) dispatch_queue_t operationQueue;
@end



@implementation HZCacheManager

+ (HZCacheManager *)sharedInstance{
    static HZCacheManager *cacheInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheInstance = [[HZCacheManager alloc] init];
    });
    return cacheInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        
        _operationQueue = dispatch_queue_create("com.dispatch.HZCacheManager", DISPATCH_QUEUE_SERIAL);
        
        [self initCachesfileWithName:defaultCachePath];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(automaticCleanCache)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundCleanCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - 获取沙盒目录
- (NSString *)homePath {
    return NSHomeDirectory();
}

- (NSString *)documentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)libraryPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)cachesPath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)tmpPath{
    return NSTemporaryDirectory();
}

- (NSString *)HZKitPath{
    return [[self cachesPath]stringByAppendingPathComponent:PathSpace];
}

- (NSString *)HZAppCachePath{
    return self.diskCachePath;
}


#pragma mark - 创建存储文件夹
- (void)initCachesfileWithName:(NSString *)name{
    self.diskCachePath =[[self HZKitPath] stringByAppendingPathComponent:name];
    [self createDirectoryAtPath:self.diskCachePath];
}

- (void)createDirectoryAtPath:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    } else {
        // NSLog(@"FileDir is exists.%@",path);
    }
}

- (BOOL)diskCacheExistsWithKey:(NSString *)key {
     return [self diskCacheExistsWithKey:key path:self.diskCachePath];
}

- (BOOL)diskCacheExistsWithKey:(NSString *)key path:(NSString *)path {
    NSString *isExists=[[self getDiskCacheWithCodingForKey:key path:path] stringByDeletingPathExtension];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:isExists];
}


#pragma mark -  编码
- (NSString *)getDiskCacheWithCodingForKey:(NSString *)key{
    
    NSString *path=[self getDiskCacheWithCodingForKey:key path:self.diskCachePath];
    return path;
}

- (NSString *)getDiskCacheWithCodingForKey:(NSString *)key path:(NSString *)path {
    NSString *filename = [self MD5StringForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)MD5StringForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    return filename;
}

#pragma  mark - 存储
- (void)storeContent:(NSObject *)content forKey:(NSString *)key isSuccess:(HZCacheIsSuccessBlock)isSuccess{
    [self storeContent:content forKey:key path:self.diskCachePath isSuccess:isSuccess];
}

- (void)storeContent:(NSObject *)content forKey:(NSString *)key path:(NSString *)path isSuccess:(HZCacheIsSuccessBlock)isSuccess{
    dispatch_async(self.operationQueue,^{
        NSString *codingPath =[[self getDiskCacheWithCodingForKey:key path:path]stringByDeletingPathExtension];
        BOOL result=[self setContent:content writeToFile:codingPath];
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                isSuccess(result);
            });
        }
    });
}

- (BOOL)setContent:(NSObject *)content writeToFile:(NSString *)path{
    if (!content||!path){
        return NO;
    }
    if ([content isKindOfClass:[NSMutableArray class]]) {
        return  [(NSMutableArray *)content writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSArray class]]) {
        return [(NSArray *)content writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSMutableData class]]) {
        return [(NSMutableData *)content writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSData class]]) {
        return  [(NSData *)content writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSMutableDictionary class]]) {
        [(NSMutableDictionary *)content writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSDictionary class]]) {
        return  [(NSDictionary *)content writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSJSONSerialization class]]) {
        return [(NSDictionary *)content writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSMutableString class]]) {
        return  [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[NSString class]]) {
        return [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
    }else if ([content isKindOfClass:[UIImage class]]) {
        return [UIImageJPEGRepresentation((UIImage *)content,(CGFloat)0.9) writeToFile:path atomically:YES];
    }else if ([content conformsToProtocol:@protocol(NSCoding)]) {
        return [NSKeyedArchiver archiveRootObject:content toFile:path];
    }else {
        [NSException raise:@"非法的文件内容" format:@"文件类型%@异常。", NSStringFromClass([content class])];
        return NO;
    }
    return NO;
}


#pragma  mark - 获取存储数据
- (void)getCacheDataForKey:(NSString *)key value:(HZCacheValueBlock)value{
    
    [self getCacheDataForKey:key path:self.diskCachePath value:value];
}

- (void)getCacheDataForKey:(NSString *)key path:(NSString *)path value:(HZCacheValueBlock)value{
    if (!key)return;
    dispatch_async(self.operationQueue,^{
        @autoreleasepool {
            NSString *filePath=[[self getDiskCacheWithCodingForKey:key path:path]stringByDeletingPathExtension];
            NSData *diskdata= [NSData dataWithContentsOfFile:filePath];
            if (value) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    value(diskdata,filePath);
                });
            }
        }
    });
}


@end
