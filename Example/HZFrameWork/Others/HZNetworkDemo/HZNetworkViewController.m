//
//  HZNetworkViewController.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#define list_URL @"http://api.dotaly.com/lol/api/v1/authors?iap=0"

#import "HZNetworkViewController.h"
#import "HZNetworkModel.h"
#import "HZDetailViewController.h"
@interface HZNetworkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIRefreshControl *refreshControl;
@end

@implementation HZNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  HZRequestTypeCache 为 有缓存使用缓存 无缓存就重新请求
     *  默认缓存路径/Library/Caches/HZKit/AppCache
     */
    [self getDataWithApiType:HZRequestTypeCache];
    
    [self.tableView addSubview:self.refreshControl];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}


#pragma mark - AFNetworking
//apiType 是请求类型 在HZRequestConst 里
- (void)getDataWithApiType:(apiType)requestType{
    [HZRequestManager requestWithConfig:^(HZURLRequest *request){
        request.URLString=list_URL;
        request.methodType=HZMethodTypeGET;//默认为GET
        request.apiType=requestType;//默认为HZRequestTypeRefresh
        // request.requestSerializer=HZHTTPRequestSerializer;//默认HZHTTPRequestSerializer 上传参数默认为二进制 格式
        // request.responseSerializer=HZJSONResponseSerializer;//默认HZJSONResponseSerializer  返回的数据默认为json格式
        // request.timeoutInterval=10;//默认30
    }  success:^(id responseObject,apiType type,BOOL isCache){
        //如果是刷新的数据
        if (type==HZRequestTypeRefresh) {
            [self.dataArray removeAllObjects];
            
        }
        //上拉加载 要添加 apiType 类型 HZRequestTypeCacheMore(读缓存)或HZRequestTypeRefreshMore(重新请求)， 也可以不遵守此枚举
        if (type==HZRequestTypeRefreshMore) {
            //上拉加载
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *array=[dict objectForKey:@"authors"];
            for (NSDictionary *dic in array) {
                HZNetworkModel *model=[[HZNetworkModel alloc]initWithDict:dic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];    //结束刷新
            if (isCache==YES) {
                NSLog(@"使用了缓存");
            }else{
                NSLog(@"重新请求");
            }
        }
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
        [self.refreshControl endRefreshing];  //结束刷新
    }];
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden=@"iden";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    HZNetworkModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"更新时间:%@",model.detail];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HZNetworkModel *model=[self.dataArray objectAtIndex:indexPath.row];
    HZDetailViewController *detailsVC = [[HZDetailViewController alloc]init];
    NSString *url=[NSString stringWithFormat:details_URL,model.wid];
    detailsVC.urlString=url;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新
- (UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        //下拉刷新
        _refreshControl = [[UIRefreshControl alloc] init];
        //标题
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
        //事件
        [_refreshControl addTarget:self action:@selector(refreshDown) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (void)refreshDown{
    //开始刷新
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:NO];
}

- (void)timer{
    /**
     *  下拉刷新是不读缓存的 要添加 apiType 类型 HZRequestTypeRefresh  每次就会重新请求url
     *  请求下来的缓存会覆盖原有的缓存文件
     */
    
    [self getDataWithApiType:HZRequestTypeRefresh];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    
    /**
     * 上拉加载 要添加 apiType 类型 HZRequestTypeLoadMore(读缓存)或HZRequestTypeRefreshMore(重新请求)
     */
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
