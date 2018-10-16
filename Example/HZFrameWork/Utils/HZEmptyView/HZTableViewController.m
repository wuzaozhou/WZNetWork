//
//  HZEmptyTableViewController.m
//  HZEmptyView
//
//  Created by 兔兔 on 2018/9/29.
//  Copyright © 2018年 tutu. All rights reserved.
//

#import "HZTableViewController.h"
#import "HZEmptyView.h"
#import "UIView+HZKit.h"
#import "Masonry.h"
@interface HZTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HZTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"121",@"121",@"121",nil];
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
    //一、一句话添加展位图
    self.tableView.emptyView = [HZEmptyView createEmptyViewWithType:HZEmptyTypeNotContent];
    self.tableView.emptyView.autoShowAndHideEmptyView = YES;
    
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    //模拟无内容
    self.dataArray = [NSMutableArray array];
    [self.tableView reloadData];
    //模拟网络请求
    [self network];
}

- (void)network {
    //测试自动显隐
    [self.tableView hz_startLoading];
    //模拟网络请求 -- begin
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataArray = [NSMutableArray arrayWithObjects:@"121",@"121",@"121",nil];
        [self.tableView reloadData];
        //模拟网络请求 -- end
        [self.tableView hz_endLoading];
        
    });
}

/*
#pragma mark - Navigation

// In a stohzboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStohzboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
