//
//  MyRedPacketListVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//

#import "MyRedPacketListVC.h"
#import "HXRefresh.h"
#import "BXCouponModel.h"
#import "HXBankCardManagerVC.h"
#import "HXTabBarViewController.h"
#import "HXPopUpViewController.h"

#define kNumOfPage 20

@interface MyRedPacketListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    // 上下拉分页
    NSInteger num;
}
/** 券号 */
@property (nonatomic, copy) NSString *redpacketNum;

@property (nonatomic, strong) UITableView  *tableView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 普通红包状态 */
@property (nonatomic, assign) RedType redTypes;

@end

@implementation MyRedPacketListVC

/** 创建MyRedPacketListVC */
- (instancetype)myRedPacketListVC:(RedType)redType
{
    if (self == [super init]) {
        self.redTypes = redType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的奖券";
    [self addTableview];
 
    [self setupRefresh];
}

- (void)addTableview
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 44)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    /** 获取红包列表  参数：ZT：状态(1：未使用 2：冻结 3：已用 4：已过期)*/
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestGetAllcouponList;

    NSString *ZT = [NSString stringWithFormat:@"%ld",self.redTypes];
   
    if (isHeader) {
        num = 1;
        [self.dataArray removeAllObjects];
    } else {
        num ++;
    }
    NSString *str = [NSString stringWithFormat:@"%d",kNumOfPage];
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)num];
    info.dataParam = @{@"pageNum":pageNum,@"pageSize":str ,@"ZT":ZT};
    
    return info;
}

#pragma mark - 加载数据
- (void)loadDataWithParamInfo:(BXHTTPParamInfo *)info
{
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        [self endRefresh];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        // 没有数据
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        // 尾部处理
        [self makeFooterWithDic:dict];
        // 数据处理
        NSArray *dataArray = [BXCouponModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
        
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
    if ([dic[@"body"][@"pageData"][@"totalCount"] intValue] >= 20) {
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
    return 133;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *fooView = [[UIView alloc]initWithFrame:CGRectZero];
    fooView.backgroundColor = [UIColor clearColor];
    return fooView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRedPacketUnuseCell *cell = [MyRedPacketUnuseCell myRedPacketUnuseCell:tableView];
    if (self.dataArray.count > 0) {
        BXCouponModel *model = self.dataArray[indexPath.row];
        [cell makeCellWithType:self.redTypes model:model];
        
        WS(weakSelf);
        cell.cashUseBlock = ^(RedPackeType redPackeType, BXCouponModel *model) {
            [weakSelf cashButWithType:redPackeType model:model];
        };
    }
    return cell;
}

- (void)cashButWithType:(RedPackeType)redPacketType model:(BXCouponModel *)models
{
    if (redPacketType == RedPackeTypeNormal) {
     
        [self normalRedPacket];
    } else {
        // 现金红包
        [self cashPacketActionWithModel:models];
    }
}

/** 普通红包--点击使用 */
- (void)normalRedPacket
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 1;
}

/** 现金红包 */
- (void)cashPacketActionWithModel:(BXCouponModel *)model;
{
    if (self.cardDict[@"body"][@"currUser"] == nil) {
        [MBProgressHUD showError:self.cardDict[@"body"][@"resultinfo"]];
        return;
    }
    // 加载指定的页面去
    if ([self.cardDict[@"body"][@"currUser"][@"HFZH"] isEqualToString:@""]) {
        // 注意这里调试下
        WS(weakSelf);
        
        HXPopUpViewController *vc = [HXPopUpViewController popUpVCInitWithTitle:@"开通实名认证，才能出借哦" sureButton:@"立即开通" imageStr:@"Group 2" isHidden:YES sureBlock:^{
            BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc] init];
            [self.navigationController pushViewController:openLDAccountVC animated:YES];
        } deletBlock:nil];
        vc.littlButBlock = ^{

            [APPVersonModel pushBankDepositoryWithVC:weakSelf urlStr:HXBankCiguan];
        };

        
        return;
    }
    self.redpacketNum = model.QH;
    
    WS(weakSelf);
    [AppUtils alertWithVC:self title:@"转为现金" messageStr:@"" enSureBlock:^{
        [weakSelf postCouponTurnAmountWithCouponNum:self.redpacketNum];
    }];
}

/** 红包转余额 */
- (void)postCouponTurnAmountWithCouponNum:(NSString *)couponNum
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestRedpacketTurnAmount;
    info.dataParam = @{@"couponQh":couponNum};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        [MBProgressHUD hideHUD];
       
        [self doWithDic:dict];
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
/** 红包转余额：数据处理 */
- (void)doWithDic:(NSDictionary *)dic
{
    if ([dic[@"body"][@"resultcode"] integerValue] == 0) {
        [self cashTurnRight];
        
    } else if ([dic[@"body"][@"resultinfo"] isEqualToString:@"[您尚未绑卡，请去绑卡]"]) {
        
        [self unBlindCard];
    } else {
        [MBProgressHUD showError:dic[@"body"][@"resultinfo"]];
    }
}

- (void)cashTurnRight
{
    [MBProgressHUD showSuccess:@"转入余额成功"];
    
    [self loadNewStatus];
}
/** 未绑卡 */
- (void)unBlindCard
{
    WS(weakSelf);
    [AppUtils alertWithVC:self title:nil messageStr:@"您还未绑定银行卡，是否绑定？" enSureStr:@"去绑卡" cancelStr:@"取消" enSureBlock:^{
        HXBankCardManagerVC *vc = [HXBankCardManagerVC creatVCFromSB];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } cancelBlock:^{}];
}

- (void)loadDate
{
    if (!(self.dataArray.count > 0)) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - view视图
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
