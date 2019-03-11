//
//  BXReminderPageController.m
//  HBD
//
//  Created by echo on 15/9/21.
//  Copyright © 2015年 caomaoxiaozi All rights reserved.
//  中转界面

#import "BXReminderPageController.h"
#import "BXPayObject.h"
#import "NSString+Other.h"
#import "DDActivityWebController.h"

@interface BXReminderPageController ()


@end

@implementation BXReminderPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //根据类型设置界面显示内容
    [self settingFrameWithBXRemindeType:self.remindeType];
    
    if (self.remindeType == BXRemindeTypeRegisteredSuccess) {
        //注册成功，保存登录状态
        [self postLoginWithUserName:self.phoneNum password:self.password SaveState:YES];
    }
    
    if(self.remindeType == BXRemindeTypeOpenSuccess || self.remindeType == BXRemindeTypeOpenFailure){
        [self addBackItemWithAction];
    }
}

- (void)settingFrameWithBXRemindeType:(BXRemindeType)remindeType
{
    
    if (remindeType == BXRemindeTypeRegisteredSuccess) {
        
        self.title = @"注册";
        self.remindImage.image = [UIImage imageNamed:@"zhucechenggong"];
        self.remindTitle.text = @"恭喜您，注册成功";
        self.label1.text = @"";
        self.label2.text = @"开通银行存管，让您的资金更放心";
        [self.yesBtn setTitle:@"下一步" forState:UIControlStateNormal];
        
    } else if (remindeType == BXRemindeTypeOpenSuccess){
        
        self.title = @"首页";
        self.remindImage.image = [UIImage imageNamed:@"kaitongchenggong"];
        self.remindTitle.text = @"恭喜您，开通成功";
        self.label1.text = @"";
        self.label2.text = @"开启您的财富之旅";
        [self.yesBtn setTitle:@"立即出借" forState:UIControlStateNormal];
        
        //处理升级公告
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"ACTIVATED"];
        [defaults synchronize];
        
    } else if (remindeType == BXRemindeTypeOpenFailure){
        
        self.title = @"首页";
        self.remindImage.image = [UIImage imageNamed:@"kaitongshibai"];
        self.remindTitle.text = @"很遗憾，开通失败";
        self.label1.text = @"";
        NSMutableAttributedString *phoneString = [[NSMutableAttributedString alloc]initWithString:@"客服电话：40067-40088"];
        [phoneString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1] range:NSMakeRange(0, 5)];
        [phoneString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:10/255.0 green:150/255.0 blue:230/255.0 alpha:1] range:NSMakeRange(5, 12)];
        [phoneString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, 5)];
        [phoneString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(5, 12)];
        self.label2.attributedText = phoneString;
        [self.yesBtn setTitle:@"重新开通" forState:UIControlStateNormal];
    }
}

- (IBAction)didClickYesBtn:(id)sender
{
    
    if (self.remindeType == BXRemindeTypeRegisteredSuccess) {
        
        [self postLoginWithUserName:self.phoneNum password:self.password SaveState:NO];
        
    } else if (self.remindeType == BXRemindeTypeOpenSuccess){
        
        AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
        HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
        dele.window.rootViewController = tabBarVC;
        [tabBarVC reloadHomeVC];
        [tabBarVC loginStatusWithNumber:1];
        tabBarVC.selectedIndex = 1;
        
    } else if (self.remindeType == BXRemindeTypeOpenFailure){
        
       [self postLoginWithUserName:self.phoneNum password:self.password SaveState:NO];
    }
}

//自定义返回
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
    tabBarVC.selectedIndex = 0;
}



/* post登录 */
- (void)postLoginWithUserName:(NSString *)userName password:(NSString *)password SaveState:(BOOL)saveState
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"userName":userName,@"password":password};
    info.serviceString = BXRequestLogin;
    
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:
     ^(id responseObject) {
         
         NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
         if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

             [LLLockPassword setLogoutState];
             
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
             [self addBackItemWithAction];
             
             if (saveState) {
                 HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
                 [tabbar loginStatusWithNumber:1];
             } else {
                 if ([[defaults objectForKey:@"khfs"] isEqual:@"2"]) {
                     WS(weakSelf);
                     [AppUtils alertWithVC:self title:@"提示" messageStr:@"企业用户请前往官网进行开户" enSureBlock:^{
                         [weakSelf dismissViewControllerAnimated:YES completion:nil];
                     }];
                 } else {

                     BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc] init];
                     [self.navigationController pushViewController:openLDAccountVC animated:YES];
                 }
             }
             NSString *avlBal = dict[@"body"][@"cash"];
             NSString *avlBalData  = [avlBal stringByReplacingOccurrencesOfString:@"," withString:@""];
             [defaults setObject:avlBalData forKey:@"AvlBal"];
             [defaults synchronize];
             
         } else {
             [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
         }
     }faild:^(NSError *error) {
         
     }];
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)creatVCFromSB
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXReminderPageController *remindPageVC = [storyBoard instantiateViewControllerWithIdentifier:@"BXReminderPageVC"];
    return remindPageVC;
}

@end
