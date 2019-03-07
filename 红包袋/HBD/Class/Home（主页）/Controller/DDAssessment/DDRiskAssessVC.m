//
//  DDRiskAssessVC.m
//  HBD
//
//  Created by hongbaodai on 17/5/5.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
// ////此页面暂时没用

#import "DDRiskAssessVC.h"
#import "DDAssessmentVC.h"
#import "DDUserModel.h"

@interface DDRiskAssessVC ()

@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, copy) NSString *webUrlStr;

@end

@implementation DDRiskAssessVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"风险评估";
    [self initWebview];
}

#pragma mark - webview
- (void)initWebview
{
    //http://web.hongbaodai.com/m/about/riskEvaluationM.html
    self.webUrlStr = @"http://192.168.1.110/m/about/riskEvaluationM.html";
//    self.webUrlStr = @"http://v2.hongbaodai.com/m/about/riskEvaluationM.html";
    
    _webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.webUrlStr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:_webUrl];
    [self.webVIew loadRequest:request];
    self.webVIew.delegate = self;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    self.context = [self.webVIew valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 以 JSExport 协议关联 native 的方法
    self.context[@"native"] = self; 
}

- (void)sendParams
{
    
    NSString * PhoneId = @"iOS";
    
    // 判断登录状况
    HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
    //去缓存拿
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DDUserModel *usermodel = [[DDUserModel alloc] init];
    usermodel.DRM =[defaults objectForKey:@"username"];
    usermodel._PW = [defaults objectForKey:@"password"];
    NSDictionary *statusDict = usermodel.mj_keyValues;
    
    JSValue *function = [self.context objectForKeyedSubscript:@"iosparams"];
    
    
    if (tabbar.bussinessKind) {
        
        [function callWithArguments:@[PhoneId, @1, statusDict]];
        
    } else {
        
        [function callWithArguments:@[PhoneId, @0, statusDict]];
    }
    
}

#pragma mark - JSExport Methods
- (void)pushTextVc
{

}

/** 跳转评估结果 */
- (void)pushRiskAssessVc:(NSString *)scorestr
{
    //此方法需要在主线程，不然登录后点出借崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        // 判断登录状况
        HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;

        if (tabbar.bussinessKind) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDAssessmentVC" bundle:nil];
            DDAssessmentVC *assVc = [sb instantiateInitialViewController];
            [self.navigationController pushViewController:assVc animated:YES];
            
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
            BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            loginVC.isPresentedWithMyAccount = 0;
            BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
            
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
        }
    });
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
    // Dispose of any resources that can be recreated.
}

@end
