//  BXSquareViewController.m
//  账户设置

#import "BXMyAccountController.h"
#import "BXAccountAssetsController.h"
#import "BXAccountAssetsVC.h"
#import "HXWithDrawCashVC.h"
#import "HXRefresh.h"
#import "DDInviteFriendVc.h"
#import "BXJumpThirdPartyController.h"
#import "BXReminderPageController.h"
#import "BXPaymentCalendarController.h"
#import "BXHFRechargeController.h"
#import "DDAccount.h"
#import "MBProgressHUD.h"
#import "MyRedPacketSwitchVC.h"
#import "InvestmentRecordSwtichVC.h"
#import "DDMyRewardController.h"
#import "HXNewsSwitchVC.h"
#import "DDActivityWebController.h"
#import "APPVersonModel.h"
#import "HXPopUpViewController.h"
#import "BXDebentureControllerNew.h"

typedef NS_ENUM(NSUInteger, DDSetStyle) {
    DDSetStylebindCard,  // 绑定银行卡
    DDSetStyleOther,
};

@interface BXMyAccountController ()<PayThirdPartyProtocol,UIAlertViewDelegate>{
//    BOOL isShow;                     // 弹出框是否弹出
    BOOL isBankCard;                 // 是否绑定了银行卡
    NSString *isbankStr;             // 银行卡管理
    NSDictionary *diction;           // 个人账户钱的情况
    NSDictionary  *userCardInfo;     // 用户绑卡信息
}

// 弹出框是否弹出
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) DDSetStyle styleBank;
/** 时间tip：上午好 下午好 */
@property(nonatomic,strong) UILabel *userNameLabel;
/** 可用金额 */
@property (weak, nonatomic) IBOutlet UILabel *cashMoney;
/** 已收收益 */
@property (weak, nonatomic) IBOutlet UILabel *totalIncomeLab;
/** 待收资金 */
@property (nonatomic, weak) IBOutlet UILabel *collectInterestLab;
/** 充值 */
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
/** 提现 */
@property (weak, nonatomic) IBOutlet UIButton *takeoutBtn;


// 为了设置统一颜色
@property (weak, nonatomic) IBOutlet UIView *topBackview;

@end

@implementation BXMyAccountController
// 账户设置页面
- (void)awakeFromNib
{
    [super awakeFromNib];
      [self initView];
}

- (void)setUpState
{
    //防止多次点击连跳bug
    self.chargeBtn.enabled = YES;
    self.takeoutBtn.enabled = YES;
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isShow = NO;
    [self loadNewStatus];
    [self postUserBankCardInfo];
    [self setUserNameLabelText];
    [self setUpState];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefresh];
    [self loadData];
}

- (void)setupRefresh
{
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerAction:@selector(loadNewStatus)];
    [self.tableView.mj_header beginRefreshing];
}

// 下拉刷新
- (void)loadNewStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"userId"]) {
        [self loadData];
    }
}

- (void)initView
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 19, 19)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"insideLetter"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 200, 30)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:12];
    self.userNameLabel = leftLabel;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.userNameLabel];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self setUserNameLabelText];
    self.tableView.backgroundColor = DDRGB(240.0f, 240.0f, 240.0f);
    self.topBackview.backgroundColor = COLOUR_BTN_BLUE_NEW;
}

#pragma mark - 点击设置
- (void)rightBtnClick
{
    HXNewsSwitchVC *newsVC = [[HXNewsSwitchVC alloc] init];
    [self.navigationController pushViewController:newsVC animated:YES];
}

//设置账户名称
- (void)setUserNameLabelText
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber;
    if ([defaults objectForKey:@"username"])
    {
        phoneNumber = [defaults objectForKey:@"username"];
    } else if([defaults objectForKey:@"phoneNumber"]){
        phoneNumber = [defaults objectForKey:@"phoneNumber"];
        
    }
    if (phoneNumber == nil) return;
    if (phoneNumber.length <= 7) {
        self.userNameLabel.text = @"";
    } 
    NSString *str1 = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
    NSString *str2 = [phoneNumber substringWithRange:NSMakeRange(phoneNumber.length - 4, 4)];
    
    phoneNumber = [NSString stringWithFormat:@"%@****%@",str1,str2];
    if ([self timeIsmorning]) {
        self.userNameLabel.text = [NSString stringWithFormat:@"上午好，%@",phoneNumber];
    } else {
        self.userNameLabel.text = [NSString stringWithFormat:@"下午好，%@",phoneNumber];
    }
}

- (BOOL)timeIsmorning
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH";
    NSString *hour = [formatter stringFromDate:now];
    if ([hour integerValue] >= 0 && [hour integerValue] < 12) {
        return YES;
    } else {
        return NO;
    }
}

// 用户绑定情况postQueryFasterCardClickBtn
- (void)isBankCardClickBtn:(BOOL)isRecharge
{
    if (isRecharge == YES) { // 充值
        BXHFRechargeController *HFRecharge = [BXHFRechargeController creatVCFromStroyboard];
        HFRecharge.drawlCanshStr = self.cashMoney.text;
        [self.navigationController pushViewController:HFRecharge animated:YES];

        self.chargeBtn.enabled = NO;//防止多次点击连跳bug
        self.takeoutBtn.enabled = NO;
    } else { //提现

        HXWithDrawCashVC *drawalVC = [HXWithDrawCashVC creatVCFromStroyboard];
        drawalVC.drawlCanshStr = self.cashMoney.text;
        drawalVC.bankCardDict = userCardInfo;
        [self.navigationController pushViewController:drawalVC animated:YES];

        self.chargeBtn.enabled = NO;//防止多次点击连跳bug
        self.takeoutBtn.enabled = NO;
    }
}

- (void)doAertView
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"khfs"] isEqual:@"2"]) {
        
        WS(weakSelf);
        [AppUtils alertWithVC:self title:@"提示" messageStr:@"企业用户请前往官网进行开户" enSureBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        weakSelf.isShow = NO;
    } else {
        BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc] init];
        [self.navigationController pushViewController:openLDAccountVC animated:YES];
    }
}

- (void)addPopViewWithStr:(NSString *)str
{
    WS(weakSelf);
    
    HXPopUpViewController *vc = [HXPopUpViewController popUpVCInitWithTitle:str sureButton:@"立即开通" imageStr:@"Group 2" isHidden:YES sureBlock:^{
        [weakSelf doAertView];
    } deletBlock:^{
        weakSelf.isShow = NO;
    }];
    vc.littlButBlock = ^{
        
        [APPVersonModel pushBankDepositoryWithVC:weakSelf urlStr:HXBankCiguan];
    };
}

// 充值提现条件
- (void)didClickRecharge:(BOOL)reCharge
{
    // 弹框是否弹出
    if (_isShow) return;
    // 是否有数据
    if (userCardInfo[@"body"][@"currUser"] == nil) {
        [MBProgressHUD showError:userCardInfo[@"body"][@"resultinfo"]];
        return;
    }
    // 开通实名认证
    if ([userCardInfo[@"body"][@"currUser"][@"HFZH"] isEqualToString:@""]) {
        if (reCharge == YES) {
            [self addPopViewWithStr:@"开通银行资金账户，才能充值哦"];
        } else {
            [self addPopViewWithStr:@"开通银行资金账户，才能提现哦"];
        }
        return;
    }
    // 绑卡
    if (isBankCard == NO) {
        WS(weakSelf);
        [AppUtils alertWithVC:self title:nil messageStr:@"您还未绑定银行卡，是否绑定？" enSureStr:@"去绑卡" cancelStr:@"取消" enSureBlock:^{
            [weakSelf postBlindCard];
        } cancelBlock:^{}];
        return;
    }
    
    [self isBankCardClickBtn:reCharge];
}

#pragma mark - 充值 提现
- (IBAction)didClickRechargeBtn:(id)sender
{
    [self didClickRecharge:YES];
}

// 提现
- (IBAction)didClickWithdrawBtn:(id)sender
{
    [self didClickRecharge:NO];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self pushVCWith:indexPath];
    }
}

- (void)pushVCWith:(NSIndexPath *)index
{
    switch (index.row) {
        case 0:
            [self pushSettingVC];
            break;
        case 1:
            [self pushMyMoneyVC];
            break;
        case 2:
            [self pushRecordVC];
            break;
        case 3:
            [self pushCanlendarVC];
            break;
        case 4:
            [self pushMyRedPacketVC];
            break;
        case 5:
            [self pushMyPrizes];
            break;
        case 6:
            [self pushInviteFriendVC];
            break;
        default:
            break;
    }
}

- (void)pushSettingVC
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *vipStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:DDUserVipState]];
    BOOL isDel = NO;
    if ([vipStr isEqualToString:@"0"]) {
        isDel = YES;
    }
    
    BXDebentureControllerNew *vcNew = [[BXDebentureControllerNew alloc] init];
    vcNew.currDict = diction;
    vcNew.kSFMRTX = isbankStr;
    vcNew.isDelete = isDel;
    [self.navigationController pushViewController:vcNew animated:YES];
}

- (void)pushMyMoneyVC
{
    BXAccountAssetsController *acVC = [BXAccountAssetsController creatVCFromStroyboard];
    acVC.AccountDetaildict = diction;
    [self.navigationController pushViewController:acVC animated:YES];
}

- (void)pushRecordVC
{
    InvestmentRecordSwtichVC *investmentRecordVC = [[InvestmentRecordSwtichVC alloc] init];
    [self.navigationController pushViewController:investmentRecordVC animated:YES];
}

- (void)pushCanlendarVC
{
    BXPaymentCalendarController *paymentCanlendarVC = [BXPaymentCalendarController creatVCFromStroyboard];
    [self.navigationController pushViewController:paymentCanlendarVC animated:YES];
}

- (void)pushMyRedPacketVC
{
    MyRedPacketSwitchVC *redpacketVC = [[MyRedPacketSwitchVC alloc] init];
    redpacketVC.cardPersonDict = userCardInfo;
    [self.navigationController pushViewController:redpacketVC animated:YES];
}

- (void)pushMyPrizes
{
    DDMyRewardController *mesVC = [[DDMyRewardController alloc] init];
    [self.navigationController pushViewController:mesVC animated:YES];
}

- (void)pushInviteFriendVC
{
    DDInviteFriendVc *inviteFriendsVC = [DDInviteFriendVc creatVCFromStroyboard];
    [self.navigationController pushViewController:inviteFriendsVC animated:YES];
}

#pragma mark - 加载数据
- (void)loadData
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestAccountInfo;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        [self.tableView.mj_header endRefreshing];

        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
        
        diction = dict;
        BXAccountAssetsVC *accountUser = [BXAccountAssetsVC  mj_objectWithKeyValues:dict[@"body"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (dict[@"body"][@"vipFlag"] == nil) {    //是不是vip
            [defaults setObject:@"0" forKey:DDUserVipState];
        } else {
            [defaults setObject:dict[@"body"][@"vipFlag"] forKey:DDUserVipState];
        }
        [defaults setValue:accountUser.cash forKey:@"AvlBal"];
        [defaults synchronize];
        // 可用余额
        if ([accountUser.cash doubleValue] > 0) {
            NSString *str = [NSString stringWithFormat:@"%.2lf",[accountUser.cash doubleValue]];
            self.cashMoney.text = str;
        } else {
            self.cashMoney.text = @"0.00";
        }
        // 代收资金
        if ([accountUser.toCollectPrincipal doubleValue] > 0 || [accountUser.toCollectInterest doubleValue] > 0) {
            NSString *str = [NSString stringWithFormat:@"%.2lf",[accountUser.toCollectPrincipal doubleValue] + [accountUser.toCollectInterest doubleValue]];
            self.collectInterestLab.text = str;
        } else {
            self.collectInterestLab.text = @"0.00";
        }
        // 已收收益
        if (accountUser.totalEarnedInterest) {
            self.totalIncomeLab.text = [NSString stringWithFormat:@"%.2lf",[accountUser.totalEarnedInterest doubleValue]];
        } else {
            self.totalIncomeLab.text = @"0.00";
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } faild:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
    }];
}

/** 获取用户绑卡信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        [self makeUserBankCardInfoWithDict:dict];
    } faild:^(NSError *error) {}];
}

- (void)makeUserBankCardInfoWithDict:(NSDictionary *)dict
{
    if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
    //缓存用户信息
    userCardInfo = dict;
    DDAccount *accout = [DDAccount mj_objectWithKeyValues:dict[@"body"]];
    
    //如果在登陆状态中变成vip
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (dict[@"body"][@"currUser"][@"SF_Vip"] == nil) {    //是不是vip
        [defaults setObject:@"0" forKey:DDUserVipState];
    } else {
        [defaults setObject:dict[@"body"][@"currUser"][@"SF_Vip"] forKey:DDUserVipState];
    }
    
    accout.SXSJ = dict[@"body"][@"currUser"][@"SXSJ"];
    // 银行预留手机号
    accout.bankPhoneNum = dict[@"body"][@"currUser"][@"BANK_RESERVE_MOBILE"];
    
    if (dict[@"body"][@"bankcardBind"][@"YHKH"]) {
        isBankCard = YES;
    } else {
        isBankCard = NO;
    }
    
    if (dict[@"body"][@"bankcardBind"][@"YHBM"]) {
        isbankStr = dict[@"body"][@"bankcardBind"][@"YHBM"];
    } else {
        isbankStr = nil;
    }
}

- (void)showAlertWithStr:(NSString *)str
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)makeBindCardSuccess:(BOOL)isSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
    if (isSuccess) {
        [self showAlertWithStr:@"绑卡成功!"];
    } else {
        [self showAlertWithStr:@"绑卡失败，请稍后再试！"];
    }
}

- (void)makeStatusStyleWithIsSucces:(BOOL)isSuccess
{
    BXReminderPageController *remindPageVC = [BXReminderPageController creatVCFromSB];
    if (isSuccess) {
        
        remindPageVC.remindeType = BXRemindeTypeOpenSuccess;
        [remindPageVC settingFrameWithBXRemindeType:remindPageVC.remindeType];
        [self.navigationController pushViewController:remindPageVC animated:YES];
    } else {
        remindPageVC.remindeType = BXRemindeTypeOpenFailure;
        [remindPageVC settingFrameWithBXRemindeType:remindPageVC.remindeType];
        [self.navigationController pushViewController:remindPageVC animated:YES];
    }
}

- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    if (self.styleBank == DDSetStylebindCard) {
        // 绑定银行卡
        [self makeBindCardSuccess:isSuccess];
    } else {
        [self makeStatusStyleWithIsSucces:isSuccess];
    }
}

/** 绑定银行卡 */
- (void)postBlindCard
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestlmBindPersonCard;
    info.dataParam = @{@"from":@"M"};
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
        
        BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
        JumpThirdParty.title = @"绑定银行卡";
        JumpThirdParty.payDelegate = self;
        JumpThirdParty.info = info;
        JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
        self.styleBank = DDSetStylebindCard;
        [self.navigationController pushViewController:JumpThirdParty animated:YES];
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

@end
