//
//  BXLoginViewController.m
//  sinvo
//
//  Created by 李先生 on 15/3/27.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXLoginViewController.h"
#import "DDForgotPwdVC.h"
#import "NSString+Other.h"
#import "DDAccount.h"
#import "DDCoverView.h"
#import "BXJumpThirdPartyController.h"
#import "DDRegisterVC.h"
#import "HXTabBarViewController.h"
#import "HXAlertAccount.h"

@interface BXLoginViewController ()<UITextFieldDelegate, DDCoverViewDelegate, PayThirdPartyProtocol>
//登陆容器
@property (weak, nonatomic) IBOutlet UIView *loginView;

// 登陆按钮
@property (weak, nonatomic) IBOutlet HXButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (nonatomic, strong) LLLockViewController *lockViewController;
@property (nonatomic, strong) DDCoverView *ddcoverView;

@end

@implementation BXLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.pwdTextfield.delegate = self;
    [self initViewUI];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self popUpgradeView];
}

- (void)initViewUI {

    if (self.loginStyle == DDLoginStyleChangePwd) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.accountTextfield.text = [defaults objectForKey:@"phoneNumber"];
        [self addBackItemWithAction];
    }
    
    [self.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - DDUpgradeDelegate
- (void)popUpgradeView {
    /*
     1、停服公告：点击确定退出账户，可以浏览，点击登录注册弹出
     2、升级公告：点击升级跳转升级页面升级，必须登录且为老账号
     */
    
    //处理升级公告
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *bizStr = [defaults objectForKey:@"BIZUPGRADE"];
    NSString *actStr = [defaults objectForKey:@"ACTIVATED"];
    NSString *lockStr = [defaults objectForKey:@"ISLOCKVC"];
    
    if ([bizStr isEqualToString:@"1"]) {
        
        self.ddcoverView = [[DDCoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.ddcoverView.viewStyle = DDViewStyleUpgradeStopView;
        self.ddcoverView.delegate = self;
    } else if ([bizStr isEqualToString:@"2"]) {
        // 登录状态 且 老账户
        HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
        if (tabbar.bussinessKind && [actStr isEqualToString:@"0"] && [lockStr isEqualToString:@"NO"]) {
            
            self.ddcoverView = [[DDCoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            self.ddcoverView.viewStyle = DDViewStyleUpgradeView;
            self.ddcoverView.delegate = self;
        }
    }
}



#pragma mark - DDCoverviewDelegate
/**
 点击升级资金账户
 */
- (void)didClickZhsjBtn {
    
    [self.ddcoverView removeUpgradeView];
    [self postUserActivatedUpgrade];
}

/**
 点击停服公告确定按钮
 */
-(void)didClickTfsjBtn {

    [self.ddcoverView removeUpgradeView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerBtnClick
{
    [self.accountTextfield endEditing:YES];
    [self.pwdTextfield endEditing:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDRegisterVC" bundle:nil];
    DDRegisterVC *vc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetPwdBtnClick
{
    [self.accountTextfield endEditing:YES];
    [self.pwdTextfield endEditing:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDForgotPwdVC" bundle:nil];
    DDForgotPwdVC *vc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 自定义返回
- (void)addBackItemWithAction
{
    //添加此功能是因为在修改密码界面直接跳转不弹出登录界面bug
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:btn];
}

- (void)doBack
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:0];
    tabBarVC.selectedIndex = 0;
}

#pragma mark -- login
- (IBAction)loginBtnClick:(HXButton *)sender
{
    if ([self canSubmitGo]) {
        // 登陆
        [self postLoginWithUserName:self.accountTextfield.text password:self.pwdTextfield.text];
    }
}

- (BOOL)canSubmitGo {
    
    if (!self.accountTextfield.text.length || !self.pwdTextfield.text.length) {
        //不能为空
        [MBProgressHUD showError:@"用户名和密码不能为空"];
        return NO;
    }
    if (self.accountTextfield.text.length < 2){
        [MBProgressHUD showError:@"用户名过短"];
        return NO;
    }
    if (self.accountTextfield.text.length > 32){
        [MBProgressHUD showError:@"用户名过长"];
        return NO;
    }
    if (self.pwdTextfield.text.length < 6){
        [MBProgressHUD showError:@"用户名或密码错误，请重新输入 ！"];
        self.pwdTextfield.text = nil;
        return NO;
    }
    if (self.pwdTextfield.text.length > 16){
        [MBProgressHUD showError:@"用户名或密码错误，请重新输入 ！"];
        self.pwdTextfield.text = nil;
        return NO;
    }
    if ([self.pwdTextfield.text containsString:@" "]){
        [MBProgressHUD showError:@"用户名或密码错误，请重新输入 ！"];
        self.pwdTextfield.text = nil;
        return NO;
    }
    return YES;

}

/** 升级银行存管 */
- (void)postUserActivatedUpgrade
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    
    info.serviceString = DDRequestlmUserActivated;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            //
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"账户升级";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            
            [self.navigationController pushViewController:JumpThirdParty animated:YES];
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}


#pragma mark - POST
/* post登录 */
- (void)postLoginWithUserName:(NSString *)userName password:(NSString *)password
{
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"userName":userName,@"password":password};
    info.serviceString = BXRequestLogin;
     
    
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:
     ^(id responseObject) {
         [MBProgressHUD hideHUD];
         
         NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
         
         if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
             [DDAccount mj_objectWithKeyValues:dict[@"body"]];
             //                 self.haveBackBar = 0;
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             //                 if (![userName isEqualToString:[defaults objectForKey:@"username"]] ) {
             [defaults setObject:@(1) forKey:DDKeyLoginState];
             if (dict[@"body"][@"vipFlag"] == nil) {    //是不是vip
                 [defaults setObject:@"0" forKey:DDUserVipState];
             } else {
                 [defaults setObject:dict[@"body"][@"vipFlag"] forKey:DDUserVipState];
             }
             [LLLockPassword saveLockPassword:@""];
             [defaults setObject:userName forKey:@"LoginUsername"];
             [defaults setObject:[NSString encodeByMd5AndSalt:password] forKey:@"LoginPassword"];
             [defaults setObject:userName forKey:@"username"];
             [defaults setObject:[NSString encodeByMd5AndSalt:password] forKey:@"password"];
             [defaults setObject:dict[@"body"][@"_U"] forKey:@"userId"];
             [defaults setObject:dict[@"body"][@"_T"] forKey:@"_T"];
             [defaults setObject:dict[@"body"][@"roles"] forKey:@"roles"];
             [defaults setObject:dict[@"body"][@"usergroup"] forKey:@"usergroup"];
             [defaults setObject:dict[@"body"][@"mobile"] forKey:@"phoneNumber"];
             [defaults setObject:dict[@"body"][@"khfs"] forKey:@"khfs"];
             [defaults setObject:dict[@"body"][@"TS"] forKey:@"TS"];
             [defaults setObject:dict[@"body"][@"QP"] forKey:@"QP"];
             
             if (dict[@"body"][@"sessionId"]) {
                 [defaults setObject:dict[@"body"][@"sessionId"] forKey:@"sessionId"];
             }
             
             [defaults synchronize];
             
             // 换账号了,清空之前的所有存储信息////进入时重新设置密码
             [self dismissViewControllerAnimated:NO completion:nil];
             AppDelegate* deleget = (AppDelegate*)[UIApplication sharedApplication].delegate;
             HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
             tabbar.bussinessKind = 1;
             
             if (self.isPresentedWithLockVC == 1) {
                 if ([self.LoginDelegate respondsToSelector:@selector(refreshVCType:)]) {
                     [self.LoginDelegate refreshVCType:YES];
                 }
                 [self  dismissViewControllerAnimated:YES completion:nil];
             } else {
                 if ([self.LoginDelegate respondsToSelector:@selector(refreshVCType:)]) {
                     [self.LoginDelegate refreshVCType:NO];
                 }
                 NSString* pswd = [LLLockPassword loadLockPassword];
                 if (pswd) {
                     [deleget showLLLockViewController:LLLockViewTypeCheck isPresentedWithMyAccount:self.isPresentedWithMyAccount];
                 } else {
                     [deleget showLLLockViewController:LLLockViewTypeCreate isPresentedWithMyAccount:self.isPresentedWithMyAccount];
                 }
             }
             
             
         } else {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
             
             self.pwdTextfield.text = nil;
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:@(0) forKey:DDKeyLoginState];
             [defaults synchronize];
         }
         
     }faild:^(NSError *error) {
         [MBProgressHUD hideHUD];
     }];
}

- (void)makeRoundView:(UIView *)view
{
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = BXCustomColor(217, 217, 217, 255);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountTextfield resignFirstResponder];
    [self.pwdTextfield resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTextfield resignFirstResponder];
    [self.pwdTextfield resignFirstResponder];
    [self resignFirstResponder];
    return YES;
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
