//
//  BXWithdrawSuccessController.m
//  HBD
//
//  Created by echo on 15/10/14.
//  提现成功

#import "BXWithdrawSuccessController.h"
#import "DDAccount.h"
#import "HXTabBarViewController.h"

@interface BXWithdrawSuccessController ()
// 我的账户button
@property (weak, nonatomic) IBOutlet UIButton *myAccoutBut;

@end

@implementation BXWithdrawSuccessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提现";

    self.myAccoutBut.layer.masksToBounds = YES;
    self.myAccoutBut.layer.cornerRadius = 22;

    [self addBackItemWithAction];
    [self postUserBankCardInfo];

}

/** 自定义返回 */
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
}

- (void)doBack
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 2; //tabbar为3个账户设置角标2
}

/** 点击回到首页 */
- (IBAction)backToHomeBtnClick:(HXButton *)sender
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 0;
}

/** 点击我的账户 */
- (IBAction)myAccountBtnClick:(id)sender
{
    [self doBack];
}

/** 获取用户绑卡信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        //缓存用户信息
        [DDAccount mj_objectWithKeyValues:dict[@"body"]];
    } faild:^(NSError *error) {}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
