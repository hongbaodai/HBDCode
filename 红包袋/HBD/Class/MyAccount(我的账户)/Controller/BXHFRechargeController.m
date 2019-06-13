//
//  BXHFRechargeController.m
//  Created by echo on 16/3/29.
//
//  充值  第一步

#import "BXHFRechargeController.h"
#import "BXJumpThirdPartyController.h"
#import "BXPayObject.h"
#import "BXUIWebRequsetManager.h"
#import "MYAlertView.h"
#import "NSString+Other.h"
#import "HXBankCardManagerVC.h"
#import "HXRechargeBankCardVC.h"
#import <YYText/YYText.h>
#import <YYText/YYLabel.h>
#import "HXWebVC.h"

@interface BXHFRechargeController ()<PayThirdPartyProtocol, UITextFieldDelegate, UIAlertViewDelegate>
{
    NSDictionary *cardDict;
}
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (weak, nonatomic) IBOutlet UIView *labelBackView;
/** 可用金额数字 */
@property (weak, nonatomic) IBOutlet UILabel *rechargeMoneyLab;
/** 充值金额输入框 */
@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;
/** 充值按钮 */
@property (nonatomic, weak) IBOutlet HXButton *rechargeButton;

@property (nonatomic, assign) BOOL isBankCard;

@end

@implementation BXHFRechargeController
#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inputTextfield.delegate = self;
    self.title = @"充值";
    [self makeDescripLabelUI];
}
/** 添加描述视图 */
- (void)makeDescripLabelUI
{
    self.topBackView.backgroundColor = kColor_Red_Main;
    
    CGRect frame = self.labelBackView.frame;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * 23;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = width;
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    NSString *str = [NSString stringWithFormat:@"充值说明：\n1.红包袋充值过程免费，不向用户收取任何手续费；\n2.为确保红包袋用户资金安全，用户资金由银行直接存管；\n3.禁止洗钱、信用卡套现、虚假交易等不法行为，一经发现并确认，将终止该账户的使用；\n4.快捷支付限额请参照限额说明；\n5.如果充值过程中遇到问题，请联系客服。"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];

    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:158.0f/255.0f green:164.0f/255.0f blue:174.0f/255.0f alpha:1.0f] range:NSMakeRange(0, attributedString.length)];


    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];

    [paragraphStyle1 setLineSpacing:9];

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    
    WS(weakSelf);
    // 1. 创建一个属性文本
    NSRange rage = [str rangeOfString:@"限额说明"];
    [attributedString yy_setTextHighlightRange:NSMakeRange(rage.location, rage.length)
                             color:kColor_Orange_Dark
                   backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             [weakSelf ebankBtnClick];
    }];
    label.attributedText = attributedString;
    [self.labelBackView addSubview:label];
}

/** 点击快捷限额的支付说明 */
- (void)ebankBtnClick
{
    HXWebVC *webVC = [[HXWebVC alloc]init];
    webVC.title = @"限额说明";
    
    webVC.urlStr = [NSString stringWithFormat:@"%@/exExplain?hidden=1",DDNEWWEBURL];
    [self.navigationController pushViewController:webVC animated:YES];
}

/** 点击联系客服 */
- (IBAction)contentUsBtnClick:(id)sender
{
    [AppUtils contactCustomerService];
}

/** 点击充值 */
- (IBAction)returnClickRecharge:(HXButton *)sender
{
    if (![self checkInputtext]) return;
    
    [self.inputTextfield endEditing:YES];
    [self postQueryFasterCard];
}

#pragma mark - 判断输入金额是否合法
- (BOOL)checkInputtext
{
    if (self.isBankCard == NO) {
        WS(weakSelf);
        [AppUtils alertWithVC:self title:@"您没有绑定银行卡，去绑卡?" messageStr:nil enSureBlock:^{
            [weakSelf makeCard];
        }];
        return NO;
    }
    
    if (self.inputTextfield.text.length == 0 ) {
        [MBProgressHUD showError:@"请输入充值金额"];
        return NO;
    }
    if([self.inputTextfield.text doubleValue] < 1.0) {
        [MBProgressHUD showError:@"充值金额不能小于1元"];
        return NO;
    }
    if([self.inputTextfield.text doubleValue] > 1000000) {
        [MBProgressHUD showError:@"充值金额不能超过100万"];
        return NO;
    }
    
    if (![NSString checkNum:self.inputTextfield.text]) {
        [MBProgressHUD showError:@"充值金额最多输入两位小数"];
        return NO;
    }
    
    if ([self.inputTextfield.text doubleValue] >= 1.0 && [self.inputTextfield.text doubleValue] <= 1000000) {
        return YES;
    }

    return YES;
}

#pragma  mark -post
/**
  获取用户绑卡信息
  HFYHDM = CCB;
 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        cardDict = [NSDictionary dictionaryWithDictionary:responseObject];
        [MBProgressHUD hideHUD];
        if ([cardDict[@"body"][@"resultcode"] integerValue] == 0){
         
            if (cardDict[@"body"][@"bankcardBind"][@"YHKH"]) {
                self.isBankCard = YES;
                
            } else {
                self.isBankCard = NO;
            }
        }
    } faild:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常,请检查网络"];
    }];
}

// 获取用户快捷卡绑定情况：后台如果改了再说🚫这块需要注意，有无绑卡情况去内存中拿数据直接判断
- (void)postQueryFasterCard
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestQueryFasterCard;
    info.dataParam = nil;
    self.rechargeButton.enabled = NO;
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        self.rechargeButton.enabled = YES;
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        //    跳转到确认充值页 --有卡直接充值
        HXRechargeBankCardVC *bankcardVC = [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"HXRechargeBankCardVC"];
        bankcardVC.cardKJDic = dict;
        bankcardVC.cardDic = cardDict;
        bankcardVC.moneystr = self.inputTextfield.text;
        
        [self.navigationController pushViewController:bankcardVC animated:YES];
        
    } faild:^(NSError *error) {
        self.rechargeButton.enabled = YES;

        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常,请检查网络"];
    }];
}

/** 没绑卡去绑卡 */
- (void)makeCard
{
    HXBankCardManagerVC * bcVc = [HXBankCardManagerVC creatVCFromSB];
    [self.navigationController pushViewController:bcVc animated:YES];
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"AvlBal"]) {
        self.rechargeMoneyLab.text = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"AvlBal"]];
    }

//    self.rechargeMoneyLab.text = self.drawlCanshStr;    
    self.inputTextfield.text = @"";
    [self.inputTextfield resignFirstResponder];
    [self postUserBankCardInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

/** 创建BXHFRechargeController */
+ (instancetype)creatVCFromStroyboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    BXHFRechargeController *HFRecharge = [storyboard instantiateViewControllerWithIdentifier:@"BXHFRechargeVC"];
    return HFRecharge;
}

@end
