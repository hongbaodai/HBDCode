//
//  BXAccountAssetsController.m
//  sinvo
//  我的资产

#import "BXAccountAssetsController.h"
#import "BXAccountAssetsVC.h"
#import "HXRefresh.h"
#import "BXAccountRecordsController.h"
#import "HXPieChartView.h"
#import "HXPieChartModel.h"

@interface BXAccountAssetsController ()

/** 总资产 */
@property (weak, nonatomic) IBOutlet UILabel *totalAssets;

/** 待收本金 */
@property (weak, nonatomic) IBOutlet UILabel *dueInCapital;

/** 待收收益 */
@property (weak, nonatomic) IBOutlet UILabel *toCollectRevenue;

/** 可用余额 */
@property (weak, nonatomic) IBOutlet UILabel *userCash;

/** 累计充值 */
@property (weak, nonatomic) IBOutlet UILabel *accumulatedTopUpLabel;

/** 累计获得利息-已收收益 */
@property (weak, nonatomic) IBOutlet UILabel *totalRevenue;

/**  出借冻结金额 */
@property (weak, nonatomic) IBOutlet UILabel *frozenMoney;

/**  提现冻结金额 */
@property (weak, nonatomic) IBOutlet UILabel *withDrawlFrozenMoney;

@property (weak, nonatomic) IBOutlet UIView *pieView;

@end

@implementation BXAccountAssetsController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的资产";
    
    [self addRightBarItem];

    if (self.AccountDetaildict) {
        
        [self makeDetailDataView];
    } else {
        [self loadNewState];
    }
    
    [self addRefreshMethod];
}
/** 右部按钮 */
- (void)addRightBarItem
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 39, 19)];
    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)rightBtnClick
{
    BXAccountRecordsController *accountRecordsVC = [BXAccountRecordsController creatVCFromSB];
    [self.navigationController pushViewController:accountRecordsVC animated:YES];
}

/** 添加下拉刷新方法 */
- (void)addRefreshMethod
{
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerAction:@selector(loadNewState)];
}

/** 添加饼状图 */
- (void)addpieChartViewWithData:(BXAccountAssetsVC *)model
{
    HXPieChartView *pieView = [[HXPieChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.pieView.frame)) items:[self addModelWithModel:model]];

    [self.pieView addSubview:pieView];
}

- (NSArray *)addModelWithModel:(BXAccountAssetsVC *)model
{
    
    NSMutableArray *muArr = [NSMutableArray array];
    if ([model.toCollectPrincipal doubleValue]) { // 代收本金
        [muArr addObject:[HXPieChartModel dataItemWithValue:[model.toCollectPrincipal doubleValue] color:[UIColor colorWithHexString:@"#9cc93a"]]];
    }

    if ([model.toCollectInterest doubleValue]) { // 代收收益
        [muArr addObject:[HXPieChartModel dataItemWithValue:[model.toCollectInterest doubleValue] color:[UIColor colorWithHexString:@"#64c1df"]]];
    }

    if ([model.cash doubleValue]) {   // 可用余额
         [muArr addObject:[HXPieChartModel dataItemWithValue:[model.cash doubleValue] color:[UIColor colorWithHexString:@"#22add5"]]];
    }

    if ([model.YDJTBZXJ doubleValue]) { // 已冻结投标金额
        [muArr addObject:[HXPieChartModel dataItemWithValue:[model.YDJTBZXJ doubleValue] color:kColor_sRGB(236, 116, 96)]];
    }

    if ([model.YDJTXZXJ doubleValue]) { // 已冻结提现金额
        [muArr addObject:[HXPieChartModel dataItemWithValue:[model.YDJTXZXJ doubleValue] color:kColor_sRGB(135, 150, 169)]];
    }

    return [NSArray arrayWithArray:muArr];
}


/** 刷新数据 */
- (void)loadNewState
{
    [self postAccountInfo];
}

- (void)makeDetailDataView
{
    BXAccountAssetsVC *accountAssets = [BXAccountAssetsVC  mj_objectWithKeyValues:self.AccountDetaildict[@"body"]];
    [self addpieChartViewWithData:accountAssets];
    [self refreshDataWithModel:accountAssets];
}

- (void)refreshDataWithModel:(BXAccountAssetsVC *)accountAssets
{
    //总资产
    NSString *totalAssets = [accountAssets.totalAssets stringByReplacingOccurrencesOfString :@"," withString:@""];
    self.totalAssets.text = [NSString stringWithFormat:@"%.2lf",[totalAssets doubleValue]];
    
    //待收本金
    NSString *tocollect = [accountAssets.toCollectPrincipal stringByReplacingOccurrencesOfString :@"," withString:@""];
    self.dueInCapital.text = [NSString stringWithFormat:@"%.2lf",[tocollect doubleValue]];
    
    //待收收益
    NSString *tocollectInter = [accountAssets.toCollectInterest stringByReplacingOccurrencesOfString :@"," withString:@""];
    self.toCollectRevenue.text = [NSString stringWithFormat:@"%.2lf",[tocollectInter doubleValue]];
    
    //可用余额
    NSString *cash = [accountAssets.cash stringByReplacingOccurrencesOfString :@"," withString:@""];
    
    if ([accountAssets.cash doubleValue] > 0) {
        self.userCash.text = [NSString stringWithFormat:@"%.2lf",[cash doubleValue]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cash forKey:@"AvlBal"];
        [defaults synchronize];
    } else {
        self.userCash.text = @"0.00";
    }
    
    // 累计充值
    self.accumulatedTopUpLabel.text = [NSString stringWithFormat:@"%.2lf",[accountAssets.collectRecharge doubleValue]];
    
    //累计获得利息
    NSString *titalInvest = [accountAssets.totalEarnedInterest stringByReplacingOccurrencesOfString :@"," withString:@""];
    
    self.totalRevenue.text = [NSString stringWithFormat:@"%.2lf",[titalInvest doubleValue]];

    //出借冻结金额
    NSString *balance = [accountAssets.YDJTBZXJ stringByReplacingOccurrencesOfString :@"," withString:@""];
    self.frozenMoney.text = [NSString stringWithFormat:@"%.2lf",[balance doubleValue]];
    
    // 已冻结提现金额
    NSString *balanceT = [accountAssets.YDJTXZXJ stringByReplacingOccurrencesOfString :@"," withString:@""];
    self.withDrawlFrozenMoney.text =  [NSString stringWithFormat:@"%.2lf",[balanceT doubleValue]];
    
    [self.tableView reloadData];
}

/** POST获取用户信息 **/
- (void)postAccountInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestAccountInfo;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
    
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        
        BXAccountAssetsVC *accountUser = [BXAccountAssetsVC  mj_objectWithKeyValues:dict[@"body"]];
        [self addpieChartViewWithData:accountUser];
        [self refreshDataWithModel:accountUser];
        
    } faild:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 创建控制器 **/
+ (instancetype)creatVCFromStroyboard
{
    return [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"BXAccountAssetsController"];
}

@end
