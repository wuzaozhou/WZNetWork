//
//  HZoffLineDownLoadViewController.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/18.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZoffLineDownLoadViewController.h"
#import "HZNetworkModel.h"
#import "HZURLRequest.h"
#import "HZRequestManager.h"

@interface HZoffLineDownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)HZBatchRequest *batchRequest;
@end


@implementation HZoffLineDownLoadViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"离开页面时 清空容器");
    [self.batchRequest removeBatchArray];
    
    [self.delegate reloadJsonNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray=[[NSMutableArray alloc]init];
    
    self.batchRequest=[[HZBatchRequest alloc]init];
    
    [self.view addSubview:self.tableView];
    
     [self addNavigationItemWithTitles:@[@"离线下载"] isLeft:NO target:self action:@selector(offlineDownLoad) tags:nil];
    
    [HZRequestManager requestWithConfig:^(HZURLRequest *request) {
        request.URLString = list_URL;
        request.apiType = HZRequestTypeRefresh;
    } success:^(id responseObject, apiType type, BOOL isCache) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *array=[dict objectForKey:@"authors"];
            for (NSDictionary *dic in array) {
                HZNetworkModel *model=[[HZNetworkModel alloc]init];
                model.name=[dic objectForKey:@"name"];
                model.wid=[dic objectForKey:@"id"];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut) {
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
    
    
    // Do any additional setup after loading the view.
}


//离线下载
- (void)offlineDownLoad {
    if (self.batchRequest.batchUrlArray.count==0) {
        [self alertTitle:@"请添加栏目" andMessage:@""];
    }else{
        NSLog(@"离线请求的栏目/url个数:%lu",self.batchRequest.batchUrlArray.count);
        for (NSString *name in self.batchRequest.batchKeyArray) {
            NSLog(@"离线请求的name:%@",name);
        }
        [self.delegate downloadWithArray:self.batchRequest.batchUrlArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    UISwitch *sw = [[UISwitch alloc] init];
    sw.center = CGPointMake(160, 90);
    sw.tag = indexPath.row;
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    HZNetworkModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)switchValueChanged:(UISwitch *)sw{
    HZNetworkModel *model = [self.dataArray objectAtIndex:sw.tag];
    NSString *url= [NSString stringWithFormat:details_URL,model.wid];
    if (sw.isOn == YES) {
        //添加请求列队
        [self.batchRequest addObjectWithUrl:url];
        [self.batchRequest addObjectWithKey:model.name];
        NSLog(@"离线请求的url:%@",self.batchRequest.batchUrlArray);
    }else{
        //删除请求列队
        [self.batchRequest removeObjectWithUrl:url];
        [self.batchRequest removeObjectWithKey:model.name];
        NSLog(@"离线请求的url:%@",self.batchRequest.batchUrlArray);
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
