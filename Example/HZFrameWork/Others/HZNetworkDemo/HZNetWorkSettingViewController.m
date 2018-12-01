//
//  HZNetWorkSettingViewController.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/18.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZNetWorkSettingViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>
#import "HZoffLineDownLoadViewController.h"
#import "HZNetworkModel.h"
#import "HZCacheManager.h"
#import "HZURLRequest.h"
#import "HZRequestManager.h"

static const NSInteger cacheTime = 30;

@interface HZNetWorkSettingViewController ()<UITableViewDelegate,UITableViewDataSource,offlineDelegate>

@property (nonatomic,copy)NSString *imagePath;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)HZBatchRequest *batchRequest;
@end

@implementation HZNetWorkSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //得到沙盒cache文件夹下的系统缓存文件路径
    NSString *cachePath= [[HZCacheManager sharedInstance] cachesPath];
    
    //得到沙盒cache文件夹下的 SDWebImage 存储路径
    NSString *sdImage=@"default/com.hackemist.SDWebImageCache.default";
    self.imagePath=[NSString stringWithFormat:@"%@/%@",cachePath,sdImage];
    
    [self.view addSubview:self.tableView];
    [self addNavigationItemWithTitles:@[@"取消离线下载"] isLeft:NO target:self action:@selector(cancleDownLoad) tags:nil];
    // Do any additional setup after loading the view.
}

- (void)cancleDownLoad {
    [self.batchRequest cancelbatchRequestWithCompletion:^(BOOL results, NSString *urlString) {
        if (results==YES) {
            NSLog(@"取消下载请求:%d URL:%@",results,urlString);
        }else{
            NSLog(@"已经请求完毕无法取消");
        }
    }];
    [[SDWebImageManager sharedManager] cancelAll];//取消图片下载
    [self.imageArray removeAllObjects];
    NSLog(@"取消下载");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIde];
        
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"清除全部缓存";
        CGFloat cacheSize=[[HZCacheManager sharedInstance] getCacheSize];//json缓存文件大小
        CGFloat imageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
        CGFloat AppCacheSize=cacheSize+imageSize;
        AppCacheSize=AppCacheSize/1000.0/1000.0;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",AppCacheSize];
        
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"全部缓存数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat cacheCount=[[HZCacheManager sharedInstance]getCacheCount];//json缓存文件个数
        CGFloat imageCount=[[SDImageCache sharedImageCache] getDiskCount];//图片缓存个数
        CGFloat AppCacheCount=cacheCount+imageCount;
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",AppCacheCount];
        
    }
    
    if (indexPath.row==2) {
        cell.textLabel.text=@"清除json缓存";
        
        CGFloat cacheSize=[[HZCacheManager sharedInstance]getCacheSize];//json缓存文件大小
        
        cacheSize=cacheSize/1000.0/1000.0;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",cacheSize];
        
    }
    
    if (indexPath.row==3) {
        cell.textLabel.text=@"json缓存数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat cacheCount=[[HZCacheManager sharedInstance]getCacheCount];//json缓存文件个数
        
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",cacheCount];
        
    }
    
    if (indexPath.row==4) {
        cell.textLabel.text=@"清除图片缓存方法";
        CGFloat imageSize = [[SDImageCache sharedImageCache]getSize];//图片缓存大小
        
        imageSize=imageSize/1000.0/1000.0;
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",imageSize];
    }
    
    if (indexPath.row==5) {
        cell.textLabel.text=@"图片缓存数量方法";
        cell.userInteractionEnabled = NO;
        
        CGFloat imageCount=[[SDImageCache sharedImageCache]getDiskCount];//图片缓存个数
        
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",imageCount];
    }
    
    if (indexPath.row==6) {
        cell.textLabel.text=@"清除自定义路径缓存";
        
        CGFloat cacheSize=[[HZCacheManager sharedInstance]getFileSizeWithpath:self.imagePath];
        
        cacheSize=cacheSize/1000.0/1000.0;
        
        CGFloat size=[[HZCacheManager sharedInstance]getFileSizeWithpath:self.imagePath];
        
        //fileUnitWithSize 转换单位方法
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM(%@)",cacheSize,[[HZCacheManager sharedInstance] fileUnitWithSize:size]];
        
    }
    
    if (indexPath.row==7) {
        cell.textLabel.text=@"自定义路径缓存数量";
        cell.userInteractionEnabled = NO;
        
        CGFloat count=[[HZCacheManager sharedInstance]getFileCountWithpath:self.imagePath];
        
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%.f",count];
        
    }
    if (indexPath.row==8) {
        cell.textLabel.text=@"清除单个json缓存文件(例:删除首页)";
        
    }
    if (indexPath.row==9) {
        cell.textLabel.text=@"清除单个图片缓存文件(手动添加url)";
    }
    
    if (indexPath.row==10) {
        cell.textLabel.text=@"按时间清除“单个”json缓存(例:menu,超30秒)";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
    }
    
    if (indexPath.row==11) {
        cell.textLabel.text=@"按时间清除“单个”图片缓存(手动添加url,超30秒)";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
    }
    
    if (indexPath.row==12) {
        cell.textLabel.text=@"按时间清除全部过期json缓存(例:超过30秒)";
    }
    
    if (indexPath.row==13) {
        cell.textLabel.text=@"按时间清除全部过期图片缓存(例:超过30秒)";
    }
    
    if (indexPath.row==14) {
        cell.textLabel.text=@"离线下载";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {
        
        //清除json缓存后的操作
        [[HZCacheManager sharedInstance]clearCacheOnCompletion:^{
            //清除图片缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [[SDImageCache sharedImageCache] clearMemory];
            [self.tableView reloadData];
            
        }];
    }
    if (indexPath.row==2) {
        //清除json缓存
        //[[HZCacheManager sharedInstance]clearCache];
        [[HZCacheManager sharedInstance]clearCacheOnCompletion:^{
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==4) {
        //清除图片缓存
        //  [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [[SDImageCache sharedImageCache] clearMemory];
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==6) {
        
        //用HZCacheManager 方法代替sdwebimage方法
        // [[HZCacheManager sharedInstance]clearDiskWithpath:self.imagePath];
        [[HZCacheManager sharedInstance]clearDiskWithpath:self.imagePath completion:^{
            
            [self.tableView reloadData];
            
        }];
    }
    if (indexPath.row==8) {
        
        //清除单个缓存文件
        // [[HZCacheManager sharedInstance]clearCacheForkey:list_URL];
        [[HZCacheManager sharedInstance]clearCacheForkey:list_URL completion:^{
            
            [self.tableView reloadData];
            
        }];
    }
    
    if (indexPath.row==9) {
        
        //清除单个图片缓存文件
        //url 过期 去log里找新的
        [[HZCacheManager sharedInstance]clearCacheForkey:@"https://r1.ykimg.com/054101015918B62E8B3255666622E929" path:self.imagePath  completion:^{
            
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==10) {
        
        //[[HZCacheManager sharedInstance]clearCacheForkey:menu_URL time:cacheTime]
        [[HZCacheManager sharedInstance]clearCacheForkey:list_URL time:cacheTime completion:^{
            [self.tableView reloadData];
        }];
    }
    if (indexPath.row==11) {
        
        //图片url 过期 去log里找新的
        [[HZCacheManager sharedInstance] clearCacheForkey:@"https://r1.ykimg.com/054101015918B62E8B3255666622E929" time:cacheTime path:self.imagePath completion:^{
            [self.tableView reloadData];
        }];
    }
    if (indexPath.row==12) {
        
        [[HZCacheManager sharedInstance]clearCacheWithTime:cacheTime completion:^{
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row==13) {
        // 路径要准确
        [[HZCacheManager sharedInstance]clearCacheWithTime:cacheTime path:self.imagePath completion:^{
            [self.tableView reloadData];
        }];
    }
    if (indexPath.row==14) {
        
        HZoffLineDownLoadViewController *offlineVC=[[HZoffLineDownLoadViewController alloc]init];
        offlineVC.delegate=self;
        [self.navigationController pushViewController:offlineVC animated:YES];
    }
}


//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    
    return _tableView;
}



#pragma mark offlineDelegate
- (void)downloadWithArray:(NSMutableArray *)offlineArray{
    [self requestOffline:offlineArray];
}

- (void)reloadJsonNumber{
    //离线页面的频道列表也会缓存的 如果之前清除了缓存，就刷新显示出来+1个缓存数量
    [self.tableView reloadData];
}


- (void)requestOffline:(NSMutableArray *)offlineArray{
    //批量请求
    self.batchRequest = [HZRequestManager sendBatchRequest:^(HZBatchRequest *batchRequest){
        for (NSString *urlString in offlineArray) {
            HZURLRequest *request=[[HZURLRequest alloc]init];
            request.URLString=urlString;
            [batchRequest.urlArray addObject:request];
        }
    }  success:^(id responseObject,apiType type,BOOL isCache){
        NSLog(@"添加了几个url请求  就会走几遍");
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *array=[dict objectForKey:@"videos"];
            for (NSDictionary *dic in array) {
                DetailsModel *model = [[DetailsModel alloc]init];
                model.thumb=[dic objectForKey:@"thumb"]; //找到图片的key
                [self.imageArray addObject:model];
                
                //使用SDWebImage 下载图片
                [[SDImageCache sharedImageCache] diskImageExistsWithKey:model.thumb completion:^(BOOL isInCache) {
                    if (isInCache) {
                        NSLog(@"已经下载了");
                    }else {
                        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:model.thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            NSLog(@"%@",[self progressStrWithSize:(CGFloat)receivedSize/expectedSize]);
                        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                            NSLog(@"单个图片完成");
                            [self.tableView reloadData];//耗性能  正式开发建议刷新单行
                            //让 下载的url与模型的最后一个比较，如果相同证明下载完毕。
                            NSString *imageURLStr = [imageURL absoluteString];
                            NSString *lastImage=[NSString stringWithFormat:@"%@",((DetailsModel *)[self.imageArray lastObject]).thumb];
                            if ([imageURLStr isEqualToString:lastImage]) {
                                NSLog(@"url相同下载完成");
                            }
                            if (error) {
                                NSLog(@"图片下载失败");
                            }
                        }];
                    }
                }];
            }
        }
        
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            NSLog(@"请求超时");
        }else{
            NSLog(@"请求失败");
        }
    }];
    
}

- (NSString *)progressStrWithSize:(CGFloat)size{
    NSString *progressStr = [NSString stringWithFormat:@"下载进度:%.1f",size* 100];
    return  progressStr = [progressStr stringByAppendingString:@"%"];
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
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
