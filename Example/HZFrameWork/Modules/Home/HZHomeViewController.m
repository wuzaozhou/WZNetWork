//
//  HZHomeViewController.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZHomeViewController.h"
#import "HZEmptyView.h"
#import "UIView+HZKit.h"
#import "Masonry.h"
#import "HZTableViewController.h"
#import "HZCollectionViewController.h"
#import "HZNetworkViewController.h"
#import "HZNetWorkDownLoadViewController.h"
#import "HZNetWorkSettingViewController.h"
#define list_URL @"http://api.dotaly.com/lol/api/v1/authors?iap=0"

@interface HZHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HZHomeViewController
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
        //self.dataArray = [NSMutableArray arrayWithObjects:@"手动显示",@"自动显示（Tableview）",@"自动显隐（Collection）",nil];
        self.dataArray = [NSMutableArray arrayWithObjects:@"网络请求",@"网络下载例子",@"自动显隐（Collection",@"网络设置",nil];
        [self.tableView reloadData];
    }];
    
    
    //    //二、手动显示
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.tableView hz_showEmptyView];
    //    });
    
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
    BaseViewController *vc = nil;
    switch (indexPath.row) {
        case 0:{
            //[self.tableView hz_showEmptyView];
            HZNetworkViewController *netWorkVC = [[HZNetworkViewController alloc] init];
            [self.navigationController pushViewController:netWorkVC animated:YES];
        }
            break;
        case 1:
            vc = [[HZNetWorkDownLoadViewController alloc] init];
            break;
        case 2:
            vc = [[HZCollectionViewController alloc] init];
            break;
        case 3:
            vc = [[HZNetWorkSettingViewController alloc] init];
            break;
    }
    if(vc){
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
