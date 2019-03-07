
//
//  AnnouncementVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/25.
//

#import "AnnouncementVC.h"
#import "AnnouncementVCCell.h"
#import "HXRefresh.h"
#import "BXNetworkRequest.h"
#import "BXMessagedetailController.h"
#import "BXIndustryModel.h"

@interface AnnouncementVC ()<UITableViewDelegate, UITableViewDataSource>
{
    // 分页
    NSInteger num;
}
@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation AnnouncementVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"平台公告";
    [self addHeaderRefresh];
}
/** 添加头部刷新 */
- (void)addHeaderRefresh
{
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerAction:@selector(loadHeader)];
    [self.tableView.mj_header beginRefreshing];
}
/** 头部刷新 */
- (void)loadHeader
{
    num = 1;
    self.dataArr = nil;
    NSString *numStr = [NSString stringWithFormat:@"%ld",num];
    [self loadDataWithNum:numStr pageSize:@"20"];
}
/** 尾部刷新 */
- (void)loadFooter
{
    num ++;
    NSString *numStr = [NSString stringWithFormat:@"%ld",num];
    [self loadDataWithNum:numStr pageSize:@"20"];
}
/** 添加尾部刷新 */
- (void)addFooterRefresh
{
    [HXRefresh setFooterRefreshWithVC:self tableView:self.tableView footerAction:@selector(loadMoreStatus)];
}

- (void)loadMoreStatus
{
    if (![self.tableView.mj_header isRefreshing]) {
        [self loadFooter];
    }
}

/** 加载公告数据 */
- (void)loadDataWithNum:(NSString *)numa pageSize:(NSString *)pageSize
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestIndustry;
    info.dataParam = @{@"pageNum":numa,@"pageSize":pageSize,@"belong_type":@"notice"};
    
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        [self endRefresh];
        
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        
        [self makeDataWithdic:dict pageSize:pageSize];
        self.tableView.scrollEnabled =YES;
        [self.tableView reloadData];
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self endRefresh];
    }];
}
/** 处理数据 */
- (void)makeDataWithdic:(NSDictionary *)dic pageSize:(NSString *)pageSizes
{
    if (num > ([dic[@"body"][@"pageData"][@"totalCount"] intValue] / [pageSizes intValue]) + 1 && num != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    if ([dic[@"body"][@"pageData"][@"totalCount"] integerValue] >= 20) {
        [self addFooterRefresh];
    }
    
    NSArray *dataArray = [BXIndustryModel mj_objectArrayWithKeyValuesArray:dic[@"body"][@"pageData"][@"data"]];
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObjectsFromArray:self.dataArr];
    [temp addObjectsFromArray:dataArray];
    self.dataArr = temp;
}
/** 结束刷新 */
- (void)endRefresh
{
    if (num != 1) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
}

#pragma mark- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count > 0 ? self.dataArr.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementVCCell *cell = [AnnouncementVCCell annoucementVCCellWithTableView:tableView];
    if (self.dataArr.count > 0) {
        BXIndustryModel *model = self.dataArr[indexPath.row];
        [cell makeUIWithModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataArr.count <= 0) return;
    
    BXIndustryModel *model = self.dataArr[indexPath.row];
    BXMessagedetailController *vc = [[UIStoryboard storyboardWithName:@"BXMessagedetailController" bundle:nil] instantiateInitialViewController];
    vc.type = @"0";
    vc.parameterId = model.WZZX_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 77;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
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
