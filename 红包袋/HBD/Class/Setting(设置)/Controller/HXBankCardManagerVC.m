//
//  HXBankCardManagerVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/10.
//

#import "HXBankCardManagerVC.h"
#import "BXJumpThirdPartyController.h"
#import "BXDebentureControllerNew.h"
#import "DDAccount.h"
#import "AppUtils.h"

@interface HXBankCardManagerVC ()<PayThirdPartyProtocol>
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *littleTopView;
// 银行图标
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
// 银行名字
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
// 银行卡号
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;
// 单笔限额
@property (weak, nonatomic) IBOutlet UILabel *singleLimitLabel;
// 每日限额
@property (weak, nonatomic) IBOutlet UILabel *dailyLimitLabel;
@end

@implementation HXBankCardManagerVC
#pragma mark life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
    [self addBackItemWithAction];
    [self postUserBankCardInfo];
}

- (void)setUpUI
{
    self.title = @"银行卡管理";
    _topBackView.layer.masksToBounds = YES;
    _topBackView.layer.borderWidth = 1;
    _topBackView.layer.borderColor = [UIColor colorWithRed:197.0/255.0f green:184.0/255.0f blue:163.0/255.0f alpha:1].CGColor;
    _topBackView.layer.cornerRadius = 4;
}

/** 自定义返回 */
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
}

- (void)goBack
{
    [self popVCWithStr:nil];
}

/** 解绑银行卡 */
- (IBAction)unbindBank:(HXButton *)sender
{
    [self postUbindCark];
}

// 跳转到制定-我的账户页面
- (void)popVCWithStr:(NSString *)str
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isMemberOfClass:[BXDebentureControllerNew class]]) {
            if (str.length > 1) {
                // 赋值为立即绑定
                if (self.cardBlock) {
                    self.cardBlock(@"立即绑定");
                }
            }
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
}

- (void)showAlertWithStr:(NSString *)str
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - 海口银行调用成功后的回调
- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    //    if (type == MPPayTypeBind){
    if (isSuccess) {
        DDAccount *account = [DDAccount sharedDDAccount];
        account.bankPhoneNum = nil;
        
        [self popVCWithStr:@"立即绑定"];
        [self showAlertWithStr:@"银行卡解绑成功!"];
    } else {
        [self popVCWithStr:nil];
        [self showAlertWithStr:@"绑定失败，请稍后再试!"];
    }
}

#pragma mark - post
/** 解绑银行卡 */
- (void)postUbindCark
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestlmUbindCark;
    //    info.dataParam = @{@"cardNo":cardNo,@"rtUrl":@"/m/commons/pages/callback.html",@"from":@"M"};
    info.dataParam = @{@"from":@"M"};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
            return ;
        }
        
        BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
        
        BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc]init];
        JumpThirdParty.title = @"解绑银行卡";
        JumpThirdParty.payDelegate = self;
        JumpThirdParty.payType = MPPayTypeHKBank;
        JumpThirdParty.info = info;
        JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
        [self.navigationController pushViewController:JumpThirdParty animated:YES];
        
    } faild:^(NSError *error) {}];
}

/** 获取用户绑卡信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankCardList;
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;

        NSString *bankfullname = dict[@"body"][@"bankCardList"][@"bankName"];
        NSString *BankCardnum = dict[@"body"][@"bankCardList"][@"YHKH"];
        self.bankNameLabel.text = bankfullname;
        //   银行logo
        self.bankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"银行标志_%@",bankfullname]];
        
        if (BankCardnum.length > 4) {
            self.bankNumLabel.text  = [AppUtils makeCardNumWith:BankCardnum];

        } else {
            self.bankNumLabel.text = @"0000";
        }
        
        self.singleLimitLabel.text = dict[@"body"][@"bankCardList"][@"DBXE"]; // 单笔限额 🚫
        self.dailyLimitLabel.text = dict[@"body"][@"bankCardList"][@"MRXE"];  // 每日限额 🚫
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
///** 处理银行卡号：每四位加空格 */
//- (NSString *)makeCardNumWith:(NSString *)str
//{
//   NSString *strNew = [str substringFromIndex:str.length - 16];
//
//    NSString *doneTitle = @"";
//    int count = 0;
//    for (int i = 0; i < strNew.length; i++) {
//        
//        count++;
//        doneTitle = [doneTitle  stringByAppendingString:[strNew substringWithRange:NSMakeRange(i, 1)]];
//        if (count == 4) {
//            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
//            count = 0;
//        }
//    }
//    return doneTitle;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/** 创建控制器 */
+ (instancetype)creatVCFromSB
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    HXBankCardManagerVC *myData = [sb instantiateViewControllerWithIdentifier:@"HXBankCardManagerVC"];
    return myData;
}

@end
