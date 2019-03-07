//
//  HXInvestmentRecordListVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/29.
//

#import "HXInvestmentRecordListVC.h"
#import "HXRefresh.h"
#import "HXIncestMentRecordDetailVC.h"
#import "BXMyaccountInvestThreeModel.h"
#import "BXMyAccountInvestmentModel.h"
#import "BXInvestFinishModel.h"

@interface HXInvestmentRecordListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    // 分页加载
    NSInteger num;
}

@property (nonatomic, strong) UITableView  *tableView;
// 数据
@property (nonatomic, strong) NSMutableArray *dataArray;
// 回款状态
@property (nonatomic, assign) AssetType assetTypes;

@end

@implementation HXInvestmentRecordListVC

/** 创建HXInvestmentRecordListVC */
- (instancetype)hxInvestmentRecordListVC:(AssetType)assetType
{
    if (self == [super init]) {
        self.assetTypes = assetType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"出借记录";
  
    [self addTableView];
    [self setupRefresh];
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 44)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}

/** 添加刷新控件 */
- (void)setupRefresh
{
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerAction:@selector(loadNewStatus)];
}

/** 下拉刷新 */
- (void)loadNewStatus
{
    [self loadDataWithParamInfo:[self creatInforIsHeader:YES]];
}

/** 添加上拉加载 */
- (void)setupLoadMore
{
    [HXRefresh setFooterRefreshWithVC:self tableView:self.tableView footerAction:@selector(loadMoreStatus)];
}

- (void)loadMoreStatus
{
    if (![self.tableView.mj_header isRefreshing]) {
        [self RefreshWithServer];
    }
}

/** 开始刷新服务 */
- (void)RefreshWithServer
{
    [self loadDataWithParamInfo:[self creatInforIsHeader:NO]];
}

/** 创建BXHTTPParamInfo */
- (BXHTTPParamInfo *)creatInforIsHeader:(BOOL)isHeader
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestInvestRecord;
    
    NSString *record = [NSString stringWithFormat:@"%ld",self.assetTypes + 1];

    if (isHeader) {
        num = 1;
        self.dataArray = nil;
    } else {
        num ++;
    }
    
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)num];
    info.dataParam = @{@"recordType":record,@"pageNum":pageNum,@"pageSize":@"20" ,@"vobankIdTemp":@""};
    
    return info;
}

#pragma mark - 加载数据
- (void)loadDataWithParamInfo:(BXHTTPParamInfo *)info
{
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [self endRefresh];

        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        
        [self makeFooterWithDic:dict];
        
        NSMutableArray *dataArray;
        if (self.assetTypes == AssetTypeRecovery) {
            dataArray = [BXMyaccountInvestThreeModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
        } else if (self.assetTypes == AssetTypeRaiseMoney) {
            
            dataArray = [BXMyAccountInvestmentModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
            
        } else if (self.assetTypes == AssetTypeDone) {
            dataArray = [BXInvestFinishModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
            
        }
        
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:self.dataArray];
        [temp addObjectsFromArray:dataArray];
        self.dataArray = temp;
        [self.tableView reloadData];

    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self endRefresh];
    }];
}

/** 处理尾部刷新 */
- (void)makeFooterWithDic:(NSDictionary *)dic
{
    if ([dic[@"body"][@"pageData"][@"totalCount"] intValue] > 20) {
        [self setupLoadMore];
    }
    
    if (num == [dic[@"body"][@"pageData"][@"pageCount"] intValue] && num != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

/** 结束刷新 */
- (void)endRefresh
{
    if (num != 1) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fooView = [[UIView alloc]initWithFrame:CGRectZero];
    fooView.backgroundColor = [UIColor clearColor];
    return fooView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXInvestMentRecordTVCell *cell = [HXInvestMentRecordTVCell hxInvestMentRecordTVCell:tableView type:self.assetTypes];
    if (self.assetTypes == AssetTypeRecovery) {
        BXMyaccountInvestThreeModel *investmentModel = self.dataArray[indexPath.row];
        [cell makeModel:investmentModel];

    } else if (self.assetTypes == AssetTypeRaiseMoney) {

        BXMyAccountInvestmentModel *investmentModel = self.dataArray[indexPath.row];
        [cell myAccountInvestRecordWithModel:investmentModel];

    } else if (self.assetTypes == AssetTypeDone) {
        BXInvestFinishModel *investmentModel = self.dataArray[indexPath.row];
        [cell accountInvestRecordThreeModel:investmentModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.assetTypes == AssetTypeRecovery) {
        HXIncestMentRecordDetailVC *detailVC = [HXIncestMentRecordDetailVC creatVCFromSB];
        BXMyaccountInvestThreeModel *investmentModel = self.dataArray[indexPath.row];
        detailVC.title = investmentModel.JKBT;
        detailVC.idStr = investmentModel.TZJL_ID;
        [self.navigationController pushViewController:detailVC animated:YES];        
    }
}

#pragma mark - view视图
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDate];
}

- (void)loadDate
{
    if (!(self.dataArray.count > 0)) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
