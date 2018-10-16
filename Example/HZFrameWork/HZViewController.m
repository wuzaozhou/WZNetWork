//
//  HZViewController.m
//  HZEmptyView
//
//  Created by Runyalsj on 10/02/2018.
//  Copyright (c) 2018 Runyalsj. All rights reserved.
//

#import "HZViewController.h"
#import "HZEmptyView.h"
#import "UIView+HZKit.h"
#import "Masonry.h"
#import "HZTableViewController.h"
#import "HZCollectionViewController.h"
#import "HZNetworking.h"

#define list_URL @"http://api.dotaly.com/lol/api/v1/authors?iap=0"

@interface HZViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HZViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark-- tableview
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //一、一句话添加展位图
    self.tableView.emptyView = [HZEmptyView createEmptyViewWithType:HZEmptyTypeNotNetwork resetBlock:^{
        //三、手动关闭
        [self.tableView hz_hideEmptyView];
        
        self.dataArray = [NSMutableArray arrayWithObjects:@"手动显示",@"自动显示（Tableview）",@"自动显隐（Collection）",nil];
        [self.tableView reloadData];
    }];
    
    
    //二、手动显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView hz_showEmptyView];
    });
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self cellDidAtIndexPath:indexPath];
}

- (void)cellDidAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:{
            //[self.tableView hz_showEmptyView];
            /**
             *  HZRequestTypeCache 为 有缓存使用缓存 无缓存就重新请求
             *  默认缓存路径/Library/Caches/HZKit/AppCache
             */
            [self getDataWithApiType:HZRequestTypeCache];
        }
            break;
        case 1:
            vc = [[HZTableViewController alloc] init];
            break;
        case 2:
            vc = [[HZCollectionViewController alloc] init];
            break;
    }
    if(vc){
        [self.navigationController pushViewController:vc animated:YES];
    }
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
//            for (NSDictionary *dic in array) {
//                RootModel *model=[[RootModel alloc]initWithDict:dic];
//                [self.dataArray addObject:model];
//            }
//            [self.tableView reloadData];
//            [self.refreshControl endRefreshing];    //结束刷新
            if (isCache==YES) {
                NSLog(@"使用了缓存");
            }else{
                NSLog(@"重新请求");
            }
        }
        
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            //[self alertTitle:@"请求超时" andMessage:@""];
        }else{
            //[self alertTitle:@"请求失败" andMessage:@""];
        }
        //[self.refreshControl endRefreshing];  //结束刷新
    }];
}



@end
