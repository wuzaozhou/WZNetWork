//
//  HZDetailViewController.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/18.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HZNetworkModel.h"
@interface HZDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation HZDetailViewController


- (void)dealloc{
    // NSLog(@"释放%s",__func__);
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    /**
     防止网络不好 请求未完成用户就退出页面 ,而请求还在继续 浪费用户流量 ,所以页面退出 要取消对应的请求。
     */
    [HZRequestManager cancelRequest:_urlString completion:^(BOOL results, NSString *urlString) {
        //如果请求成功 或 读缓存 会返回null 无法取消。请求未完成的会取消并返回对应url results 为yes
        if (results==YES) {
            NSLog(@"取消对应url:%@ ",urlString);
        }else{
            //   NSLog(@"请求完毕 无法取消");
        }
    }];
    
    [[SDWebImageManager sharedManager] cancelAll];//取消图片下载
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    
    /**
     *  如果页面不想使用缓存 要添加 apiType 类型 ZBRequestTypeRefresh  每次就会重新请求url
     */
    // NSLog(@"_urlString:%@",_urlString);
    [HZRequestManager requestWithConfig:^(HZURLRequest *request){
        request.URLString=_urlString;
        request.apiType = HZRequestTypeDetailCache;
        // request.requestSerializer=ZBHTTPRequestSerializer;//默认ZBHTTPRequestSerializer 上传参数默认为二进制 格式
        // request.responseSerializer=ZBJSONResponseSerializer;//默认ZBJSONResponseSerializer  返回的数据默认为json格式
    }  success:^(id responseObject,apiType type,BOOL isCache){
        // NSLog(@"type:%zd",type);
        if (isCache==YES) {
            NSLog(@"使用了缓存");self.title=@"使用了缓存";
        }else{
            NSLog(@"重新请求");self.title=@"重新请求";
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            NSArray *array=[dataDict objectForKey:@"videos"];
            for (NSDictionary *dict in array) {
                DetailsModel *model=[[DetailsModel alloc]initWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden=@"iden";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    DetailsModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.title;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"发布时间:%@",model.date];
    //NSLog(@"model.thumb:%@",model.thumb);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"h1.jpg"]];
    return cell;
}


//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight = 100;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
