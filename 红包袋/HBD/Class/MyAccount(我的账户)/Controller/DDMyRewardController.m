//
//  DDMyRewardController.m
//  HBD
//
//  Created by hongbaodai on 16/11/16.
//  我的奖品

#import "DDMyRewardController.h"
#import "HXRefresh.h"

#import "DDMyRewardModel.h"
#import "DDMyRewardCell.h"


@interface DDMyRewardController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) UILabel *lab;

@end

@implementation DDMyRewardController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"我的奖品";
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray array];
    
    [self.tableView reloadData];
    [self addHeaderRefresh];
}

/** 头部刷新 */
- (void)addHeaderRefresh
{
    WS(weakSelf);
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerBlock:^{
        [weakSelf postMyWinningRequsetWithRefresh:YES];
    }];
    [self.tableView.mj_header beginRefreshing];
}

/** 尾部刷新 */
- (void)addFooterRefresh
{
    WS(weakSelf);
    [HXRefresh setFooterRefreshWithVC:self tableView:self.tableView footerBlock:^{
        [weakSelf postMyWinningRequsetWithRefresh:NO];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMyRewardCell * cell = [DDMyRewardCell myRewordCellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark - POST  获取奖励
- (void)postMyWinningRequsetWithRefresh:(BOOL)header
{
    if (header) { // 下拉刷新请求第一页数据
        self.pageIndex = 1;
        [self.dataArray removeAllObjects];
    }
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDMyWinningRecord;
    NSString *strPage = [NSString stringWithFormat:@"%zd",self.pageIndex];
    info.dataParam = @{@"time":@"4", @"pageNum":strPage, @"pageSize":@"20"};
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
     
        [self endRefresh];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        // 无数据处理
        NSArray *arr = dict[@"body"][@"list"];
        if ([arr count] <= 0) {
            [self showNoddataLab];
            return ;
        }
        // 尾部刷新处理
        [self makeFooterWithDic:dict];
        // 有数据处理
        NSArray *dataArray = [DDMyRewardModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"list"]];        
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:self.dataArray];
        [temp addObjectsFromArray:dataArray];
        self.dataArray = temp;
        
        // 状态处理
        self.lab = nil;
        self.pageIndex ++;
        [self.tableView reloadData];
        
    } faild:^(NSError *error) {
        [self endRefresh];
    }];
}

/** 处理尾部刷新 */
- (void)makeFooterWithDic:(NSDictionary *)dic
{
    if ([dic[@"body"][@"totalCount"] intValue] >= 20) {
        [self addFooterRefresh];
    }
    
    if (self.pageIndex == [dic[@"body"][@"pageCount"] intValue] && self.pageIndex != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefresh
{
    if (self.pageIndex != 1) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
}

//显示无数据
- (void)showNoddataLab
{
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, 35)];
    self.lab.text = @"暂无相关数据";
    self.lab.font = [UIFont systemFontOfSize:14];
    self.lab.textColor = [UIColor lightGrayColor];
    self.lab.textAlignment = NSTextAlignmentCenter;
    [self.tableView  addSubview:self.lab];
}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tablew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
        tablew.delegate = self;
        tablew.dataSource = self;
        tablew.separatorStyle = UITableViewCellSeparatorStyleNone;
        tablew.backgroundColor = [UIColor clearColor];
        tablew.rowHeight = 118;
        _tableView = tablew;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
