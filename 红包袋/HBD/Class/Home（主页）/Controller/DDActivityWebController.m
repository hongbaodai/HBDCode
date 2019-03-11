//
//  DDActivityWebController.m
//  HBD
//
//  Created by hongbaodai on 16/12/30.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

#import "DDActivityWebController.h"
#import "DDUserModel.h"
#import "DDInviteFriendVc.h"
#import "DDRegisterVC.h"
#import "WXApi.h"
#import "BXSharePageView.h"
#import "SDImageCache.h"
#import "BXDebentureControllerNew.h"

@interface DDActivityWebController () <UIActionSheetDelegate, SharePageViewProtocol>

@property (nonatomic, assign) BOOL customOrWebShareTap;

@end

@implementation DDActivityWebController
{
    BXSharePageView *_shareView;
    UIView *_bottomgraryView;
    NSString *_textStr;
}

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.webTitleStr != nil && ![self.webTitleStr isEqualToString:@""]) {
        self.title = self.webTitleStr;
    } else {
        self.title = @"详情";
    }
    if (![self.webTitleStr isEqualToString:@"新手指引"]) {
        [self addRightBarItem];
    }
    
    [self initWebview];
    [self settingFrame];
    _textStr = _webTitleStr;

    if (self.imgUrlStr) {
        
        NSString *urlstr = [self.imgUrlStr stringByReplacingOccurrencesOfString:@" " withString:@""];//去空格处理
        NSString *url_str = [NSString stringWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_str]];
        
        self.webImg = [UIImage imageWithData:data];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    
    [self setNavgationColorNormalr];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick endLogPageView:self.title];
    
    [self setNavgationColorNormalr];
}

- (void)setNavgationColorNormalr {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 导航栏变蓝
    [self.navigationController.navigationBar setBackgroundImage:[AppUtils imageWithColor:COLOUR_BTN_BLUE] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)addRightBarItem
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:IMG(@"share_dian") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addShare)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

#pragma mark- 分享
- (void)addShare{
    [self shareToWeixinWithCopyLink:self.webUrlStr];
}

- (void)addWebShare{
    self.customOrWebShareTap = YES;
    [self shareToWeixinWithCopyLink:self.webUrlStr];
}

- (void)webViewClickMark {
    self.customOrWebShareTap = YES;
}

//自定义分享图标位置
- (void)settingFrame{
    _shareView = [BXSharePageView sharePageView];
    
    if (SCREEN_SIZE.width == 320) {
        _shareView.frame = CGRectMake(0, 667, SCREEN_SIZE.width, 250);
    } else if (SCREEN_SIZE.width == 375){
        _shareView.frame = CGRectMake(0, 667, SCREEN_SIZE.width, 186);
    } else if (SCREEN_SIZE.width == 414){
        _shareView.frame = CGRectMake(0, 736, SCREEN_SIZE.width, 190.5);
    }
    _shareView.SharePageDelegate = self;
    _shareView.backgroundColor = [UIColor whiteColor];
    
    _bottomgraryView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    _bottomgraryView.backgroundColor = [UIColor grayColor];
    _bottomgraryView.alpha=0.5;
    
    [self.view addSubview:_bottomgraryView];
    [self.view addSubview:_shareView];
}

// 弹出分享页面
- (void)popupSharePage
{
    if (_shareView && _bottomgraryView) {
        _bottomgraryView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        [UIView animateWithDuration:0.5 animations:^{
            
            _shareView.frame = CGRectMake(0, SCREEN_SIZE.height - 250, self.view.bounds.size.width, 250);
        }];
    }
}

- (void)shareToWeixinWithCopyLink:(NSString *)copyLink
{
    //友盟分享
    if (![WXApi isWXAppInstalled]) {
        //没有安装微信
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webUrlStr;
        [MBProgressHUD showSuccess:@"链接复制成功，粘贴分享给好友吧"];
    }else{
        [self popupSharePage];
    }
}

#define 分享页面的代理方法
// 点击微信好友
- (void)didClickWXHYBtn
{
    self.customOrWebShareTap = YES;
    if (_textStr) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
}

// 点击朋友圈hbd_icon
- (void)didClickWXPYQBtn
{
    self.customOrWebShareTap = YES;
    if (_textStr) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
}

// 点击取消分享
- (void)didClickCancelShareBtn
{
    _bottomgraryView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat height = CGRectGetHeight(_shareView.frame);
        _shareView.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, height);
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{

    if (self.customOrWebShareTap == YES) {
        JSValue *function = [self.context objectForKeyedSubscript:@"getLuckDrawNum"];
        [function callWithArguments:nil];
    }

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    // 这里后台还不知道需求是否要加
    NSString *detail = _webDetailStr;
    if (self.webDetailStr.length <= 0) {
        detail = _textStr;
    }

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_textStr descr:detail thumImage:self.webImg];
    //设置网页地址
    shareObject.webpageUrl = self.webUrlStr;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);

        }else{
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
//                UMSocialShareResponse *resp = data;
                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                [self didSuccese];
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //            [self alertWithError:error];
    }];
}

- (void)didSuccese
{
    _bottomgraryView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat height = CGRectGetHeight(_shareView.frame);
        _shareView.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, height);
    }];
    WS(weakSelf);
    [AppUtils alertWithVC:self title:@"分享成功" messageStr:nil enSureBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

#pragma mark - webview

- (void)initWebview {
//    self.webUrlStr = @"http://test.hongbaodai.com:23081/#/septemberActives2018?hidden=1";

    _webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.webUrlStr]];

    NSURLRequest *request = [NSURLRequest requestWithURL:_webUrl];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

- (NSString *)encodeToPercentEscapeString:(NSString *) input
{
    NSString *outputStr = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)input,NULL,(CFStringRef)@"!*'();:@&=+ $,/?%#[]",kCFStringEncodingUTF8));

    return outputStr;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 以 JSExport 协议关联 native 的方法
    self.context[@"native"] = self;
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        context.exception = exception;
    };
    [self sendParams];
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
/** 弹出登录界面 */
- (void)pushLoginVc
{
    //此方法需要在主线程，不然登录后点出借崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
        BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.isPresentedWithMyAccount = 0;
        BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    });
}

/** 弹出注册界面 */
- (void)pushRegistrationVc
{
    //此方法需要在主线程，不然登录后点出借崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDRegisterVC" bundle:nil];
        DDRegisterVC *regVc = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:regVc animated:YES];
        
    });
}


/** 跳转出借页面 */
- (void)pushInvestVc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
        HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
        dele.window.rootViewController = tabBarVC;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [defaults objectForKey:DDKeyLoginState];
        int numint = [num intValue];
        
        if (numint == 1) {
            [tabBarVC loginStatusWithNumber:3];
        } else {
            [tabBarVC loginStatusWithNumber:0];
        }
        
        tabBarVC.selectedIndex = 1;
    });
}

/** 跳转邀请好友页面 */
- (void)pushFriendVc
{
    dispatch_async(dispatch_get_main_queue(), ^{

        HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
        if (!tabbar.bussinessKind) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
            BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            loginVC.loginStyle = DDLoginStyleDec;
            BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:Nav animated:YES completion:nil];
            
        } else {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
            DDInviteFriendVc *vc = [sb instantiateViewControllerWithIdentifier:@"DDInviteFriendVc"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    });
}
/** 跳转设置页面 */
- (void)pushAccountSettingVc {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
        if (!tabbar.bussinessKind) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
            BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            loginVC.loginStyle = DDLoginStyleDec;
            BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:Nav animated:YES completion:nil];
            
        } else {
            BXDebentureControllerNew *vc = [[BXDebentureControllerNew alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
