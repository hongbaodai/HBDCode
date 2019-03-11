
//
//  HXWithDrawCashVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/13.
//

#import "HXWithDrawCashVC.h"
#import "BXJumpThirdPartyController.h"
#import "BXWithdrawSuccessController.h"
#import "BXWithdrawLoadingController.h"
#import "BXWithdrawFailureController.h"
#import <YYText/YYLabel.h>
#import "NSString+Other.h"
#import "HXButton.h"

@interface HXWithDrawCashVC ()<UITextFieldDelegate,PayThirdPartyProtocol>
{
    // 提现金额
    NSString *drawCashStr;
}

@property (weak, nonatomic) IBOutlet UIView *topBackview;

/** 提现总金额 */
@property (weak, nonatomic) IBOutlet UILabel *withDrawTotalAmountLabel;
/** 提示 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
/** 输入提现金额框 */
@property (weak, nonatomic) IBOutlet UITextField *withDrawCashTextFiel;
/** 底部view */
@property (weak, nonatomic) IBOutlet UIView *backView;
/** 提示金额Label */
@property (weak, nonatomic) IBOutlet UILabel *tipMoneyLAbel;
/** 底部背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
/** 银行名字 */
@property (weak, nonatomic) IBOutlet UILabel *bankTitleLabel;
/** 银行卡号 */
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;
/** 提现按钮 */
@property (weak, nonatomic) IBOutlet HXButton *withDrawalButton;
/** 据上的适配 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTopConstraint;
/** 全部提现按钮 */
@property (weak, nonatomic) IBOutlet UIButton *allWithDrawalBut;


@end

@implementation HXWithDrawCashVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提现";
    [self makeUI];
    
    [self.withDrawCashTextFiel addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self hidenAllRechargeBut];
}

- (void)makeUI
{
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor colorWithRed:255.0/255.0f green:161.0/255.0f blue:0/255.0f alpha:1].CGColor;
    self.withDrawTotalAmountLabel.text = self.drawlCanshStr;
    self.topBackview.backgroundColor = COLOUR_BTN_BLUE_NEW;

    //银行名称
    NSString *banknameshort= self.bankCardDict[@"body"][@"bankcardBind"][@"YHBM"];
    NSString *bankfullname = [[AppUtils creatBankForShortDic] objectForKey:banknameshort];
    self.bankTitleLabel.text = bankfullname;
    //银行logo
    self.bankImageView.image = [UIImage imageNamed:[ NSString stringWithFormat:@"银行标志_%@",bankfullname]];
    
    //        银行卡尾号
    NSString *BankCardnum = self.bankCardDict[@"body"][@"bankcardBind"][@"YHKH"];
    
    if (BankCardnum.length > 4) {
        self.bankNumLabel.text = [NSString stringWithFormat:@"(尾号 %@)",[BankCardnum substringFromIndex:BankCardnum.length - 4]];
    } else {
        self.bankNumLabel.text = @"(尾号 0000)";
    }
    
    if ([self isVipMenber]) {//是vip
        self.tipMoneyLAbel.hidden = YES;
        self.layoutTopConstraint.constant = 12.0f;
        return;
    }
    double mon = [self.withDrawTotalAmountLabel.text doubleValue] - 2.0;
    if (mon < 1.0) {
        mon = 0.00;
    }
    self.tipMoneyLAbel.text = [NSString stringWithFormat:@"您本次最多可提现金额为%.2f元\n其中2.00元作为提现手续费",mon];
}

- (void)hidenAllRechargeBut
{
    if ([self isVipMenber]) { // 是vip
        if ([self.drawlCanshStr doubleValue] < 1.00) {
            self.allWithDrawalBut.hidden = YES;
        }
    } else {
        if ([self.drawlCanshStr doubleValue] < 3.00) {
            self.allWithDrawalBut.hidden = YES;
        }
    }
}

- (void)textFieldDidChanged:(UITextField *)text
{
    drawCashStr = text.text;
}

/** 隐藏提示语 */
- (BOOL)hiddenTips
{
    self.tipLabel.hidden = NO;

    // 判空
    if (drawCashStr.length <= 0) {
        self.tipLabel.text = @"请输入提现金额";
        return NO;
    }
    
    /**以小数点开头或结尾
     多于1个小数点*/
    if ([drawCashStr hasPrefix: @"."] || [drawCashStr hasSuffix: @"."] || [drawCashStr coutOfStrContainWith:@"."] >= 2) {
        self.tipLabel.text = @"金额格式不正确";
        return NO;
    }
    
    // 小数点后多于2位
    if (![NSString checkNum:drawCashStr]) {
        self.tipLabel.text = @"提现金额最多输入两位小数";
        return NO;
    }
    
    // 判断vip和非vip账户余额
    if ([self isVipMenber]) { // 是vip
        
        if ([drawCashStr doubleValue] > [self.withDrawTotalAmountLabel.text doubleValue]) {
            self.tipLabel.text = @"账户余额不足";
            return NO;
        }
    } else {
        
        if ([drawCashStr doubleValue] + 2.00 > [self.withDrawTotalAmountLabel.text doubleValue]) {
            self.tipLabel.text = @"账户余额不足";
            return NO;
        }
    }
    // 提现金额小于1元
    if ([drawCashStr doubleValue] < 1.00 ) {
        self.tipLabel.text = @"提现金额最少为1元";
        return NO;
    }
    self.tipLabel.hidden = YES;
    return YES;
}

/** 全部提现 */
- (IBAction)allWithDrawal:(UIButton *)sender
{
   
    double money = [self.withDrawTotalAmountLabel.text doubleValue];
    double cashNum = 0.00;
    if ([self isVipMenber]) {//是vip
        cashNum = money;
    } else {
        cashNum = money - 2.00;
    }
    
    NSString *cashStr = [NSString stringWithFormat:@"%.2lf",cashNum];
    
    self.withDrawCashTextFiel.text = cashStr;
    drawCashStr = cashStr;
}

/** 提现 */
- (IBAction)withDrawalAction:(HXButton *)sender
{
    
    if (![self hiddenTips]) {
        return;
    }
    WS(weakSelf);
    [APPVersonModel showAlertViewThreeWith:MoneyPartMore textStr:@"示例：出借10000元，年预期利息最高1200元。" left:^{
         [weakSelf postStartCashWithTransAmt:drawCashStr];
    } right:^{
        [weakSelf continueBtnClick];
    }];
}

// 继续出借
- (void)continueBtnClick
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 1;
}

#pragma mark - POST
- (void)postStartCashWithTransAmt:(NSString *)transAmt
{
    self.withDrawalButton.enabled = NO;
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestlmCash;
    info.dataParam = @{@"transAmt":transAmt,@"rtUrl":@"/p2p/mycenter/usercenter/drawTrust.html",@"from":@"M"};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        self.withDrawalButton.enabled = YES;
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] != 0){
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
            return ;
        }
        BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
        
        BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
        JumpThirdParty.title = @"提现";
        JumpThirdParty.payDelegate = self;
        JumpThirdParty.info = info;
        JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
        JumpThirdParty.payType = MPPayTypeHKBank;
        [self.navigationController pushViewController:JumpThirdParty animated:YES];
    } faild:^(NSError *error) {
        self.withDrawalButton.enabled = YES;
        [MBProgressHUD hideHUD];
    }];
}

- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number{
    if (isSuccess) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *balance = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
        double cashMoney =  ([balance doubleValue] - [drawCashStr doubleValue]);
        NSString *string = [NSString stringWithFormat:@"%.2lf",cashMoney];
        [defaults setObject:string forKey:@"AvlBal"];
        [defaults synchronize];
        
        BXWithdrawSuccessController *withdrawSuccessVC = [[BXWithdrawSuccessController alloc]init];
        [self.navigationController pushViewController:withdrawSuccessVC animated:YES];
        
    } else {
        
        if ([message isEqualToString:@"请求正在处理中"]) {
            BXWithdrawLoadingController *withdrawLoadingVC = [[BXWithdrawLoadingController alloc]init];
            [self.navigationController pushViewController:withdrawLoadingVC animated:YES];
        } else {
            BXWithdrawFailureController *withdrawFailureVC = [[BXWithdrawFailureController alloc]init];
            [self.navigationController pushViewController:withdrawFailureVC animated:YES];
        }
    }
}

- (BOOL)isVipMenber
{
    NSUserDefaults *defaul = [NSUserDefaults standardUserDefaults];
    NSString *vipStr = [NSString stringWithFormat:@"%@",[defaul objectForKey:DDUserVipState]];
    if ([vipStr isEqualToString:@"1"]) { // 是vip
        return YES;
    } else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - view视图方法
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

/** 创建HXWithDrawCashVC */
+ (instancetype)creatVCFromStroyboard
{
    return [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"HXWithDrawCashVC"];
}

@end
