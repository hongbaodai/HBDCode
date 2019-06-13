//
//  HXRechargeBankCardVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/13.

#import "HXRechargeBankCardVC.h"
#import "BXJumpThirdPartyController.h"
#import "BXRechargeSuccessController.h"
#import "BXRechargeFailureController.h"

@interface HXRechargeBankCardVC ()<PayThirdPartyProtocol>
{
    //    充值类型简称字典
    NSDictionary   *_rechargetypeDic;
}


@property (weak, nonatomic) IBOutlet UIView *topBackView;

/** 充值总金额 */
@property (weak, nonatomic) IBOutlet UILabel *topUpAmountLabel;
/** 中间底部view */
@property (weak, nonatomic) IBOutlet UIView *backView;
/** 银行图片 */
@property (weak, nonatomic) IBOutlet UIImageView *banckImageView;
/** 银行名字 */
@property (weak, nonatomic) IBOutlet UILabel *banckNameLabel;
/** 银行卡号 */
@property (weak, nonatomic) IBOutlet UILabel *banckNumLabel;
/** 单笔限额 */
@property (weak, nonatomic) IBOutlet UILabel *singleLimitLabel;
/** 单日限额 */
@property (weak, nonatomic) IBOutlet UILabel *theDailyLimitLabel;
/** 下一步 */
@property (weak, nonatomic) IBOutlet HXButton *nestButton;



@end

@implementation HXRechargeBankCardVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"充值";
    
    [self makeUI];
    [self makeDataUI];
    [self postBankLimitAmountWithYhdm:_cardKJDic[@"body"][@"BankId"]];
}

- (void)makeUI
{
    self.topBackView.backgroundColor = kColor_Red_Main;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = [UIColor colorWithRed:197.0/255.0f green:184.0/255.0f blue:163.0/255.0f alpha:1].CGColor;
    _backView.layer.cornerRadius = 4;
}

- (void)makeDataUI
{
    _rechargetypeDic = [NSDictionary dictionaryWithObjectsAndKeys:@"QP",@"快捷充值",@"B2C",@"个人网银充值",@"B2B",@"企业网银充值", nil];
    
    self.banckNameLabel.text = _cardKJDic[@"body"][@"BankId"];
    if ([_cardKJDic[@"body"][@"Card"] length] > 0) {
        self.banckNumLabel.text = [AppUtils makeCardNumWith:_cardKJDic[@"body"][@"Card"]];
        
    } else {
        self.banckNumLabel.text = @"0000";
    }
    
    NSString *bankfullname = _cardDic[@"body"][@"bankcardBind"][@"bankName"];
    self.banckImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"银行标志_%@",bankfullname]];
    self.topUpAmountLabel.text = [NSString stringWithFormat:@"%.2lf",[self.moneystr doubleValue]];
    
    NSDictionary *dic = [AppUtils creatBankForShortDic];
    self.banckNameLabel.text = [dic objectForKey:_cardKJDic[@"body"][@"BankId"]];
}

/** post获取银行限额详情**/
- (void)postBankLimitAmountWithYhdm:(NSString *)Yhdm
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestBankLimit;
    info.dataParam = @{@"YHDM":Yhdm, @"from":@"M"};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSArray *arr = [NSArray arrayWithArray:dict[@"body"][@"limitInfos"]];
        NSDictionary *endDic = arr[0];
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            if (endDic[@"DBXE"]) {
                self.singleLimitLabel.text = [NSString stringWithFormat:@"%@",endDic[@"DBXE"]]; //🚫 单笔限额
            }
            if (endDic[@"MRXE"]) {
                self.theDailyLimitLabel.text = [NSString stringWithFormat:@"%@",endDic[@"MRXE"]]; //🚫
            }
        }
        
    } faild:^(NSError *error) {}];
}

/** 下一步 */
- (IBAction)nestAction:(HXButton *)sender
{
    if ([self.moneystr integerValue] < 1) {
        [MBProgressHUD showError:@"充值金额应大于1元"];
        return;
    }
    [self postRechargeWithTransAmt:self.moneystr GateBusiId:[_rechargetypeDic objectForKey:@"快捷充值"] OpenBankId:self.banckNameLabel.text];
}

/** 联系客服 */
- (IBAction)connectcustomerService:(UIButton *)sender
{
    [AppUtils contactCustomerService];
}

/** post充值**/
- (void)postRechargeWithTransAmt:(NSString *)transAmt GateBusiId:(NSString *)gateBusiId OpenBankId:(NSString *)openBankId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"transAmt":transAmt, @"GateBusiId":gateBusiId, @"OpenBankId":openBankId, @"rtUrl":@"/m/commons/pages/callback.html", @"payWay":@"SWIFT", @"from":@"M"};
    info.serviceString = DDRequestlmRecharge;
    self.nestButton.enabled = NO;
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        _nestButton.enabled = YES;
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
            return ;
        }
        BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
        
        BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
        JumpThirdParty.payDelegate = self;
        JumpThirdParty.title = @"充值";
        JumpThirdParty.info = info;
        JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
        JumpThirdParty.payType = MPPayTypeHKBank;
        [self.navigationController pushViewController:JumpThirdParty animated:YES];
        
    } faild:^(NSError *error) {
        _nestButton.enabled = YES;

        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - Delegate
- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    if (isSuccess) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *balance = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
        NSString *string = [NSString stringWithFormat:@"%.2lf",[balance doubleValue] + [self.topUpAmountLabel.text doubleValue]];
        [defaults setObject:string forKey:@"AvlBal"];
        [defaults synchronize];
        
        NSDictionary *dict = @{@"rechargeSuccess" : @"YES"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeSuccess" object:nil userInfo:dict];
        
        BXRechargeSuccessController *next = [[BXRechargeSuccessController alloc]init];
        [self.navigationController pushViewController:next animated:YES];
        
    } else {
        
        BXRechargeFailureController *next = [[BXRechargeFailureController alloc]init];
        next.responseMsg = message;
        [self.navigationController pushViewController:next animated:YES];
    }
}

#pragma mark - view视图
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _nestButton.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
