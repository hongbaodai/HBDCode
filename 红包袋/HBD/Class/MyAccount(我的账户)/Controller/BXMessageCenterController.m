//
//  BXMessageCenterController.m
//  
//
//  Created by echo on 16/2/23.
//
//  消息中心

#import "BXMessageCenterController.h"
#import "HXRefresh.h"
#import "BXMessagedetailController.h"
#import "BXMessageModel.h"
#import "BXIndustryModel.h"
#import "HXWebVC.h"

@interface BXMessageCenterController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
/** 状态 */
@property (nonatomic, assign) StatusType statusType;
/** 数据 */
@property (nonatomic, strong) NSArray  *messageArray;

@end

@implementation BXMessageCenterController
{
    int _messagePage;
}
/** 初始化BXMessageCenterController */
- (instancetype)initWithMessageCenterController:(StatusType)status
{
    if (self = [super init]) {
        self.statusType = status;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"站内信";
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addTableView];
    [self setupRefresh];
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 32)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollsToTop = YES;
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
    _messagePage = 1;
    self.tableView.scrollEnabled = NO;
    self.messageArray = nil;
    
    [self makeRefreshDo];
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
    _messagePage += 1;
 
    [self makeRefreshDo];
}

- (void)makeRefreshDo
{
    NSString *isRead;
    if (_statusType == StatusTypeUnRead) {      //未读
        isRead = @"0";
    } else if (_statusType == StatusTypeRead){  //已读
        isRead = @"1";
    }
    
    [self postMessageListWithInfo:[self paramesInfoWithIsRead:isRead]];
}

/** 创建BXHTTPParamInfo */
- (BXHTTPParamInfo *)paramesInfoWithIsRead:(NSString *)isRead
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestMessageList;
    NSString *pageStr = [NSString stringWithFormat:@"%d",_messagePage];
    info.dataParam = @{@"pageNum":pageStr,@"pageSize":@"20",@"isRead":isRead};
    return info;
}

/** 获取个人消息:已读 未读 */
- (void)postMessageListWithInfo:(BXHTTPParamInfo *)paramInfo
{
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:paramInfo succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        self.tableView.scrollEnabled =YES;
        [self endRefresh];
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        
        if (_messagePage == [dict[@"body"][@"pageData"][@"pageCount"] intValue] && _messagePage != 1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if ([dict[@"body"][@"pageData"][@"totalCount"] intValue] >= 20) {
            [self setupLoadMore];
        }
        
        NSArray *dataArray = [BXMessageModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:self.messageArray]; // 存储最新的数据
        [temp addObjectsFromArray:dataArray];
        self.messageArray = temp;
        
        [self.tableView reloadData];
        
    } faild:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [self endRefresh];
    }];
}

/** 结束刷新 */
- (void)endRefresh
{
    if (_messagePage != 1) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArray.count == 0 ? 0 : _messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
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
    BXMessageCell * cell = [BXMessageCell bxMessageCellWithTableView:tableView statusType:_statusType];

    if (self.messageArray.count > 0) {
        BXMessageModel *model = self.messageArray[indexPath.row];
        [cell fillWithMessageModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.messageArray.count == 0) return;
    
    BXMessagedetailController *detailVC = [BXMessagedetailController creatVCFromStroyboard];
    BXMessageModel *model = self.messageArray[indexPath.row];

    detailVC.type = @"1";
    detailVC.parameterId = model.ZNX_ID;
    detailVC.ZNZLX = model.title;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

/** view出现刷新 */
- (void)loadDate
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
