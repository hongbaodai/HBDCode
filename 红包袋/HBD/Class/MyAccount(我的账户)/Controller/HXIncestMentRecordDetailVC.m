//
//  HXIncestMentRecordDetailVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/29.
//

#import "HXIncestMentRecordDetailVC.h"
#import "HXRefresh.h"
#import "HXIncestMentRecordDetailModel.h"

@interface HXIncestMentRecordDetailVC ()

/** 约定年化利率 */
@property (weak, nonatomic) IBOutlet UILabel *anAnnualInterestRateLabel;
/** 净收益 */
@property (weak, nonatomic) IBOutlet UILabel *netIncomeLabel;
/** 出借金额 */
@property (weak, nonatomic) IBOutlet UILabel *investmentAmountLabel;
/** 出借时间 */
@property (weak, nonatomic) IBOutlet UILabel *investmentOfTimeLabel;
/** 回款总额 */
@property (weak, nonatomic) IBOutlet UILabel *theTotalAmountOfTheReceivableLabel;
/** 到期时间 */
@property (weak, nonatomic) IBOutlet UILabel *dueToTheTimeLabel;
/** 已使用出借红包 */
@property (weak, nonatomic) IBOutlet UILabel *redEnvelopesHaveBeenUsedLabel;
/** 已还期数/借款期数 */
@property (weak, nonatomic) IBOutlet UILabel *termLabel;
/** 累计获得利息 */
@property (weak, nonatomic) IBOutlet UILabel *accumulatedEarningsLabel;
/** 下期代收资金 */
@property (weak, nonatomic) IBOutlet UILabel *theNextCollectionOfFundsLabel;
/** 下期还款时间 */
@property (weak, nonatomic) IBOutlet UILabel *theNextPaymentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *alreadyReceiveMoney;

@end

@implementation HXIncestMentRecordDetailVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupRefresh];
}

/** 添加刷新控件 */
- (void)setupRefresh
{
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerAction:@selector(loadNewStatus)];
    [self.tableView.mj_header beginRefreshing];
}

/** 下拉刷新 */
- (void)loadNewStatus
{
    [self loadDataWithParamInfo:[self creatInfor]];
}

/** BXHTTPParamInfo */
- (BXHTTPParamInfo *)creatInfor
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestInvestRecordDetail;
        
    info.dataParam = @{@"investRecordId":_idStr};
    return info;
}

#pragma mark - 加载数据
- (void)loadDataWithParamInfo:(BXHTTPParamInfo *)info
{
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        [self.tableView.mj_header endRefreshing];
        
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        
        HXIncestMentRecordDetailModel *model = [HXIncestMentRecordDetailModel mj_objectWithKeyValues:dict[@"body"]];
        [self reloadUIWithMoel:model];// 这个现在没有数据，后台说无法给出格式，暂时这么写🚫
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)reloadUIWithMoel:(HXIncestMentRecordDetailModel *)model
{
    _anAnnualInterestRateLabel.text = [NSString stringWithFormat:@"%g%%",[model.annualRate floatValue]];
    _netIncomeLabel.text = [NSString stringWithFormat:@"%.2lf元",[model.netEarning doubleValue]];
    _investmentAmountLabel.text = [NSString stringWithFormat:@"%.2lf元",[model.investAmount doubleValue]];
    _investmentOfTimeLabel.text = [NSString stringWithFormat:@"%@",model.investDate];
    _theTotalAmountOfTheReceivableLabel.text = [NSString stringWithFormat:@"%.2lf元",[model.totalAmount doubleValue]];
    _dueToTheTimeLabel.text = [NSString stringWithFormat:@"%@",model.endDate];
    _redEnvelopesHaveBeenUsedLabel.text = [NSString stringWithFormat:@"%g元返现券",[model.investCoupon doubleValue]];
    _termLabel.text = [NSString stringWithFormat:@"%@",model.repaymentProcess];
    _accumulatedEarningsLabel.text = [NSString stringWithFormat:@"%.2lf元",[model.curEarning  doubleValue]];
    _theNextCollectionOfFundsLabel.text = [NSString stringWithFormat:@"%.2lf元",[model.nextTotalAmount doubleValue]];
    _theNextPaymentTimeLabel.text = [NSString stringWithFormat:@"%@",model.nextRepayDate];
    _alreadyReceiveMoney.text = [NSString stringWithFormat:@"%.2lf元",[model.receivedAmount doubleValue]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/** 创建HXIncestMentRecordDetailVC */
+ (instancetype)creatVCFromSB
{
    HXIncestMentRecordDetailVC *detailVC = [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"HXIncestMentRecordDetailVC"];
    return detailVC;
}

@end
