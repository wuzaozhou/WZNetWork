//
//  HZNetWorkDownLoadViewController.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZNetWorkDownLoadViewController.h"
#import "HZoffLineDownLoadViewController.h"
/** 视频链接 */
//NSString *const mp4url =@"http://yun.it7090.com/video/XHLaunchAd/video_test01.mp4";
NSString *const mp4url =@"http://down.sandai.net/mac/thunder_3.2.7.3764.dmg";
@interface HZNetWorkDownLoadViewController ()
@property (nonatomic,strong)HZBatchRequest *batchRequest;
@end

@implementation HZNetWorkDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"使用例子";
    NSArray *titleArray=[NSArray arrayWithObjects:@"POST/PUT/PATCH/DELETE/Request",@"UploadRequest",@"downLoadRequest",@"downLoadBatchRequest",@"取消请求",@"url过滤动态参数",@"parameters过滤动态参数", nil];
    for (int i=0; i<titleArray.count; i++) {
        
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        //  [btn setTitle:array[i]  forState:UIControlStateNormal];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = 1000+i;
        button.frame=CGRectMake(50, 100+i*60, 200, 30);
        button.backgroundColor=[UIColor blackColor];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    // Do any additional setup after loading the view.
}

- (void)btnClicked:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:
            [self request];
            break;
        case 1001:
            [self UploadRequest];
            break;
        case 1002:
            [self downLoadRequest];
            break;
        case 1003:
            [self downLoadBatchRequest];
            break;
        case 1004:
            [self cancelRequest];
            break;
        case 1005:
            [self URLStringTheTimeStamp];
            break;
        case 1006:
            [self parametersTheTimeStamp];
            break;
        default:
            break;
    }
}

- (void)request{
    /*
     //
     GET/POST/PUT/PATCH/DELETE 请求 都有缓存功能
     POST请求 是给服务器传参的 一般是没有缓存的。也有特例 所有列表数据请求都是post的，所以request.apiType也可以用，如：request.apiType=HZRequestTypeCache
     默认缓存路径/Library/Caches/HZKit/AppCache
     */
    [HZRequestManager requestWithConfig:^(HZURLRequest *request){
        request.URLString=@"";
        request.methodType=HZMethodTypePOST;//HZMethodTypePUT//HZMethodTypePATCH//HZMethodTypeDELETE// 默认为GET
        request.requestSerializer=HZHTTPRequestSerializer;//默认HZHTTPRequestSerializer 上传参数默认为二进制 格式
        request.responseSerializer=HZJSONResponseSerializer;//默认HZJSONResponseSerializer  返回的数据默认为json格式
        request.apiType=HZRequestTypeCache;//默认为HZRequestTypeRefresh
        request.timeoutInterval=10;//默认30
        request.parameters=@{@"1": @"one", @"2": @"two"};
        //   [request setValue:@"1234567890" forHeaderField:@"apitype"];
    }  success:^(id responseObject,apiType type,BOOL isCache){

        if (isCache) {
            NSLog(@"使用了缓存");
        }else{
            NSLog(@"重新请求");
        }
    } failure:^(NSError *error){
        NSLog(@"error: %@", error);
    }];
}

- (void)UploadRequest{

    UIImage *image = [UIImage imageNamed:@"testImage"];
    NSData *fileData = UIImageJPEGRepresentation(image, 1.0);

    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/testImage.png"];
    NSURL *fileURL = [NSURL fileURLWithPath:path isDirectory:NO];

    [HZRequestManager requestWithConfig:^(HZURLRequest * request) {
        request.URLString=@"http://192.168.0.254:1010/";
        request.methodType=HZMethodTypeUpload;

        [request addFormDataWithName:@"image[]" fileData:fileData];

        //[request addFormDataWithName:@"image[]" fileURL:fileURL];

    } progress:^(NSProgress * _Nullable progress) {
        NSLog(@"onProgress: %.2f", 100.f * progress.completedUnitCount/progress.totalUnitCount);

    } success:^(id  responseObject, apiType type,BOOL isCache) {
        NSLog(@"responseObject: %@", responseObject);
    } failure:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)downLoadRequest{

    [HZRequestManager requestWithConfig:^(HZURLRequest * request) {
        request.URLString=mp4url;
        request.methodType=HZMethodTypeDownLoad;
        request.downloadSavePath = [[HZCacheManager sharedInstance] tmpPath];
    } progress:^(NSProgress * _Nullable progress) {
        NSLog(@"onProgress: %.2f", 100.f * progress.completedUnitCount/progress.totalUnitCount);

    } success:^(id  responseObject, apiType type,BOOL isCache) {
        NSLog(@"此时会返回存储路径文件: %@", responseObject);

        [self downLoadPathSize:[[HZCacheManager sharedInstance] tmpPath]];//返回下载路径的大小

        sleep(3);
        //删除下载的文件
        [[HZCacheManager sharedInstance]clearDiskWithpath:[[HZCacheManager sharedInstance] tmpPath] completion:^{
            NSLog(@"删除下载的文件");
            [self downLoadPathSize:[[HZCacheManager sharedInstance] tmpPath]];
        }];


    } failure:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)downLoadBatchRequest{

    self.batchRequest = [HZRequestManager sendBatchRequest:^(HZBatchRequest * batchRequest) {

        /*
         for (int i=0; i<=10; i++) {
         HZURLRequest *request=[[HZURLRequest alloc]init];
         request.urlString=url;
         request.methodType=HZMethodTypeDownLoad;
         request.downloadSavePath = [[HZCacheManager sharedInstance] tmpPath];
         [batchRequest.urlArray addObject:request];
         }
         */
        HZURLRequest *request1=[[HZURLRequest alloc]init];
        request1.URLString=mp4url;
        request1.methodType=HZMethodTypeDownLoad;
        request1.downloadSavePath = [[HZCacheManager sharedInstance] tmpPath];
        [batchRequest.urlArray addObject:request1];

        HZURLRequest *request2=[[HZURLRequest alloc]init];
        request2.URLString=mp4url;
        request2.methodType=HZMethodTypeDownLoad;
        request2.downloadSavePath = [[HZCacheManager sharedInstance] documentPath];
        [batchRequest.urlArray addObject:request2];
    } progress:^(NSProgress * _Nullable progress) {
        NSLog(@"onProgress: %.2f", 100.f * progress.completedUnitCount/progress.totalUnitCount);
    } success:^(id  _Nullable responseObject, apiType type,BOOL isCache) {
        NSLog(@"此时会返回存储路径文件: %@", responseObject);
        [self downLoadPathSize:[[HZCacheManager sharedInstance] tmpPath]];//返回下载路径的大小
        [self downLoadPathSize:[[HZCacheManager sharedInstance] documentPath]];//返回下载路径的大小
        sleep(5);
        //删除下载的文件
        [[HZCacheManager sharedInstance]clearDiskWithpath:[[HZCacheManager sharedInstance] tmpPath]completion:^{
            NSLog(@"删除下载的文件");
            [self downLoadPathSize:[[HZCacheManager sharedInstance] tmpPath]];
        }];
        //删除下载的文件
        [[HZCacheManager sharedInstance]clearDiskWithpath:[[HZCacheManager sharedInstance] documentPath]completion:^{
            NSLog(@"删除下载的文件");
            [self downLoadPathSize:[[HZCacheManager sharedInstance] documentPath]];
        }];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];

}

- (void)cancelRequest{

    [HZRequestManager cancelRequest:mp4url completion:^(BOOL results, NSString *urlString) {
        if (results==YES) {
            NSLog(@"取消下载请求:%d URL:%@",results,urlString);
        }else{
            NSLog(@"已经请求完毕无法取消");
        }
    }];
    
    [self.batchRequest cancelbatchRequestWithCompletion:^(BOOL results, NSString *urlString) {
        if (results==YES) {
            NSLog(@"按顺序批量取消下载请求:%d URL:%@",results,urlString);
        }else{
            NSLog(@"已经请求完毕无法取消");
        }
    }];
}

- (void)URLStringTheTimeStamp{

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"&time=%f", timeInterval];
    //遇到到请求 是在get请求后加一个时间戳的参数，因为URLString 是默认为缓存key的 加上时间戳，key 一直变动 无法拿到缓存。所以定义了一个customCacheKey
    [HZRequestManager requestWithConfig:^(HZURLRequest *request){
        request.URLString=[list_URL stringByAppendingString:timeString];
        request.customCacheKey=list_URL;//去掉timeString
        request.methodType=HZMethodTypeGET;
        request.apiType=HZRequestTypeCache;//默认为HZRequestTypeRefresh
    }  success:nil  failure:nil];

}


- (void)parametersTheTimeStamp{
    //POST等 使用了parameters 的请求 缓存key会是URLString+parameters，parameters里有是时间戳或者其他动态参数,key一直变动 无法拿到缓存。所以定义一个parametersfiltrationCacheKey 过滤掉parameters 缓存key里的 变动参数比如 时间戳
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f",timeInterval];

    [HZRequestManager requestWithConfig:^(HZURLRequest *request){
        request.URLString=@"http://URL";
        request.methodType = HZMethodTypePOST;//默认为GET
        request.apiType = HZRequestTypeCache;//默认为HZRequestTypeRefresh
        request.parameters=@{@"1": @"one", @"2": @"two", @"time":timeString};
        request.parametersfiltrationCacheKey = @[@"time"];//过滤掉parameters 缓存key里变动参数比如 时间戳
    }success:nil failure:nil];
}


- (void)downLoadPathSize:(NSString *)path{
    CGFloat downLoadPathSize=[[HZCacheManager sharedInstance] getFileSizeWithpath:path];
    downLoadPathSize=downLoadPathSize/1000.0/1000.0;
    NSLog(@"downLoadPathSize: %.2fM", downLoadPathSize);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
