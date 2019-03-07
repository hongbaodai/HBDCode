//
//  BXAccountRecordsController.m
//  HBD
//
//  Created by echo on 15/9/10.
//  资金流水

#import "BXAccountRecordsController.h"
#import "BXAccountRecords.h"
#import "HXRefresh.h"
#import "DDMyRewardCell.h"
#import "NSDate+Setting.h"

@interface BXAccountRecordsController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation BXAccountRecordsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"流水明细";
    self.dataArray = [NSMutableArray array];
    [self addHeaderRefresh];
}
// 添加头部刷新控件
- (void)addHeaderRefresh
{
    WS(weakSelf);
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerBlock:^{
        [weakSelf postCashFlowRecordListWithRefresh:YES];
    }];
    [self.tableView.mj_header beginRefreshing];
}

// 添加尾部刷新控件
- (void)addFooterRefresh
{
    WS(weakSelf);
    [HXRefresh setFooterRefreshWithVC:self tableView:self.tableView footerBlock:^{
        [weakSelf postCashFlowRecordListWithRefresh:NO];
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count != 0 ? self.dataArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMyRewardCell *cell = [DDMyRewardCell myAccountRecordsWithTableView:tableView];
    if (self.dataArray.count)
    {
        BXAccountRecords *investmentModel = self.dataArray[indexPath.row];
        [cell accountRecordsModel:investmentModel];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fooView = [[UIView alloc]initWithFrame:CGRectZero];
    fooView.backgroundColor = [UIColor clearColor];
    return fooView;
}

#pragma mark - POST
/** 资金流水 **/
- (void)postCashFlowRecordListWithRefresh:(BOOL)header
{
    if (header) {
        self.pageIndex = 1; // 下拉刷新请求第一页数据
        [self.dataArray removeAllObjects];

    }

    WS(weakSelf);
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestCashFlowRecordList;
    
    NSString *endTime = [NSDate formmatDate];
    NSString *strPage = [NSString stringWithFormat:@"%zd",self.pageIndex];
    
    info.dataParam = @{@"type":@"0",@"startTime":@"2015-01-01",@"endTime":endTime,@"pageNum":strPage,@"pageSize":@"20",@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {

        [self endRefresh];
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [self makeTableViewFooterWithDic:dict];
     
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        
        NSArray *dataArray = [BXAccountRecords mj_objectArrayWithKeyValuesArray:dict[@"body"][@"data"]];
        
        if (dataArray.count) {
            [weakSelf.dataArray addObjectsFromArray:dataArray];
        }
        [weakSelf.tableView reloadData];
        self.pageIndex += 1;

      
    } faild:^(NSError *error) {
        [self endRefresh];
    }];
}

/** 结束刷新 */
- (void)endRefresh
{
    if (self.pageIndex != 1) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
}

/** 对尾部处理 */
- (void)makeTableViewFooterWithDic:(NSDictionary *)dic
{
    if ([dic[@"body"][@"pageCount"] intValue] > 1) {
        [self addFooterRefresh];
    }
    if (self.pageIndex == [dic[@"body"][@"pageCount"] intValue]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
/** 创建控制器 **/
+ (instancetype)creatVCFromSB
{
    BXAccountRecordsController *accountRecordsVC = [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"BXAccountRecordsVC"];
    return accountRecordsVC;
}

@end
