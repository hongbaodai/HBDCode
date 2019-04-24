//
//  AppDelegate.m
//
//  Created by 李先生 on 14/12/29.
//  Copyright (c) 2014年 caomaoxiaozi All rights reserved.
//

#import "AppDelegate.h"
#import "HXTabBarViewController.h"
#import "LLLockViewController.h"
#import "BXNewFeatureController.h"
#import "UIImageView+WebCache.h"
#import "APPVersonModel.h"
#import "DDAccount.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "CDInfo.h"

#import "DDInviteFriendVc.h"
#define kPushToLogin @"pushToLogin"

@interface AppDelegate () <UIAlertViewDelegate, UIViewControllerTransitioningDelegate, LLLockGesTureDelegate, DDCoverViewDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSDate *oldDate;
@property (nonatomic, weak) HXTabBarViewController * tabBarNewVC;

@end

@implementation AppDelegate{
    APPVersonModel *versionModel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#ifdef DEBUG

#else
    //收集崩溃异常
    [Bugly startWithAppId:BUGLYID];
    //启动防止崩溃功能
    [AvoidCrash becomeEffective];

#endif
    [self umLoadFunction:(NSDictionary *)launchOptions];
    [self uMengShare];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self addNewFeature];
    [self setAppVersion];

    return YES;
}

- (void)setAppVersion
{
    versionModel = [[APPVersonModel alloc] init];
    [versionModel APPVersionInfor];
}

- (void)addNewFeature
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //判断是否显示新特性
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *localVersion = [defaults objectForKey:@"CFBundleShortVersionString"];
    
    //获取并存储sessionId
    [defaults setObject:[self ret32bitString] forKey:@"sessionId"];

    //比较版本号
    if ([currentVersion compare:localVersion] == NSOrderedDescending) {
        // 显示新特性界面
        BXNewFeatureController *newfeatureVc = [[BXNewFeatureController alloc] init];
        self.window.rootViewController = newfeatureVc;
        [defaults setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [defaults synchronize];
        
    }else{
        HXTabBarViewController * tabBarVC = [[HXTabBarViewController alloc] init];
        self.tabBarNewVC = tabBarVC;
        self.window.rootViewController = tabBarVC;
        NSString *password = [defaults objectForKey:@"password"];
        NSString *username = [defaults objectForKey:@"username"];
        NSString *pswd = [LLLockPassword loadLockPassword];
        if (username && password.length > 0) {
            [tabBarVC loginStatusWithNumber:1];
            if (pswd) {
                [self showLLLockViewController:LLLockViewTypeCheck isPresentedWithMyAccount:0];
            } else {
                [self showLLLockViewController:LLLockViewTypeCreate isPresentedWithMyAccount:0];
            }
        }
    }

}

// MARK:友盟
- (void)umLoadFunction:(NSDictionary *)launchOptions{
#ifdef DEBUG
    //开发者需要显式的调用此函数，日志系统才能工作
    //[UMCommonLogManager setUpUMCommonLogManager];
    //[UMConfigure setLogEnabled:YES];//设置打开日志
    //插屏消息要打开
    [UMessage openDebugMode:YES];
#endif
    /** 初始化友盟所有组件产品
     @param appKey 开发者在友盟官网申请的AppKey.
     @param channel 渠道标识，可设置nil表示"App Store".
     */
    [UMConfigure initWithAppkey:UM_APPKEY_NEW channel:@"App Store"];

// MARK:Analytics
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景

// MARK:Push组件基本功能配置
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    if ([CDInfo isIOS10]) {//如果要在iOS10显示交互式的通知，必须注意实现以下代码
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
        entity.categories=categories;
    }else {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        entity.categories=categories;
    }
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }else{
        }
    }];
    
    
}

// 友盟分享
- (void)uMengShare{
    [self configUSharePlatforms];
    [self confitUShareSettings];
}

- (void)confitUShareSettings{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
}

- (void)configUSharePlatforms{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPID appSecret:WXAPPSECRET redirectURL:@"https://www.hongbaodai.com"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WXAPPID appSecret:WXAPPSECRET redirectURL:@"https://www.hongbaodai.com"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    //手势锁相关
    self.oldDate = [NSDate date];
    //推送相关
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self udeskDidBackGroudApplication:application];
}

- (void)udeskDidBackGroudApplication:(UIApplication *)application{
    __block UIBackgroundTaskIdentifier background_task;
    //注册一个后台任务，告诉系统我们需要向系统借一些事件
    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束background_task任务
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //根据需求 开启／关闭 通知
        [UdeskManager startUdeskPush];
    });
}


+ (UIViewController *)getCurrentVC {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    
    UIViewController *vc = (UIViewController *)nextResponder;
    
    UIViewController *sivc = vc.presentedViewController;
    
    if (!sivc || [sivc isKindOfClass:[LLLockViewController class]]) {
        sivc = vc;
    }
    
    return  sivc;
}

#pragma mark -手势锁
- (void)applicationWillEnterForeground:(UIApplication *)application{
  
    // 手势解锁相关
    if(self.window.rootViewController.presentingViewController == nil){
        self.lockVc = [[LLLockViewController alloc] init];
        CGFloat oldTime = [self.oldDate timeIntervalSinceNow];
        CGFloat newTime = [[NSDate date] timeIntervalSinceNow];
        CGFloat result = newTime - oldTime;
        if (result > 30.0) {//进入后台时间启动手势锁
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *password = [defaults objectForKey:@"password"];
            if ([defaults objectForKey:@"username"] && password.length > 0) {
                [self.tabBarNewVC loginStatusWithNumber:1];
                NSString* pswd = [LLLockPassword loadLockPassword];
                self.lockVc.modalPresentationStyle = UIModalPresentationCustom;
                if (pswd == nil) {
                    self.lockVc.nLockViewType = LLLockViewTypeCreate;
                    UIViewController *winvc = [AppDelegate getCurrentVC];
                    [winvc presentViewController:self.lockVc animated:YES completion:nil];
                    
                } else {
                    self.lockVc.nLockViewType = LLLockViewTypeCheck;
                    self.lockVc.isFromForeground = YES;
                    UIViewController *winvc = [AppDelegate getCurrentVC];
                    [winvc presentViewController:self.lockVc animated:YES completion:nil];
                    
                }
            }
        }
    }
    //上线操作，拉取离线消息
    [UdeskManager setupCustomerOnline];
    //推送相关
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [versionModel APPVersionInfor];
}

- (void)windowShowViewWithView:(UIView *)vie
{
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    keywindow.window.windowLevel = UIWindowLevelAlert;
    vie.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [keywindow addSubview:self.lockVc.view];

    [UIView animateWithDuration:0.3 animations:^{
        vie.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

#pragma mark - 分享回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type isPresentedWithMyAccount:(BOOL)isPresentedWithMyAccount{
    
    HXTabBarViewController *tabbarVC = (HXTabBarViewController *)self.window.rootViewController;
    UINavigationController *na = tabbarVC.viewControllers[0];
    NSLog(@"-----------%@", na.viewControllers);
    
    if(self.window.rootViewController.presentingViewController == nil){
        self.lockVc = [[LLLockViewController alloc] init];
        self.lockVc.isPresentedWithMyAccount = isPresentedWithMyAccount;
        self.lockVc.nLockViewType = type;
        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window.rootViewController presentViewController:self.lockVc animated:YES completion:^{
            
        }];
        
        if (isPresentedWithMyAccount == 1){
            HXTabBarViewController *tabbarVC = (HXTabBarViewController *)self.window.rootViewController;
            [tabbarVC reloadSelecThres];
            tabbarVC.selectedIndex = 3;
        }
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 1.停止SDWebImage所有的操作
    [[SDWebImageManager sharedManager] cancelAll];
    // 2.清空内存缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

//获取32位 UUID
-(NSString *)ret32bitString
{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    uniqueId = [uniqueId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uniqueId;
}

//时间戳+系统+随机数标识符
-(NSString *)retCookieIdString
{
    NSDate *date = [NSDate date];
    CGFloat time = [date timeIntervalSince1970] * 1000;
    double val = ((double)arc4random() / 0x100000000) * 10000;
    NSString *cookieId = [NSString stringWithFormat:@"iosapp%.0f%.0f",time,val];
    return cookieId;
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [UdeskManager registerDeviceToken:deviceToken];
//    NSLog(@"device_Token==========%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                  stringByReplacingOccurrencesOfString: @">" withString: @""]
//                 stringByReplacingOccurrencesOfString: @" " withString: @""]);

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
//app 在前台时候回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}



// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}  

@end
