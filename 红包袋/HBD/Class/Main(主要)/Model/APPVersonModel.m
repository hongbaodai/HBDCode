//
//  APPVersonModel.m
//  HBD
//
//  Created by hongbaodai on 2017/8/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "APPVersonModel.h"
#import "DDCoverView.h"
#import "DDActivityWebController.h"
#import "DDWebViewVC.h"
#import "HXAlertAccount.h"
#import "NSDate+Setting.h"
#import "AlertImgViewController.h"
#import "AlertThreeViewController.h"

@interface APPVersonModel()<DDCoverViewDelegate,UIAlertViewDelegate>
{
    NSString *versonStr;
    NSString *isImportVerson;
    dispatch_group_t group;
}

@property (nonatomic, strong) DDCoverView *ddcoverView;

@end

@implementation APPVersonModel

/**
 app版本进行更新
 */

- (void)APPVersionInfor
{
    [self asyncGroup];
}

- (void)asyncGroup
{
    dispatch_queue_t gloabalQueue = dispatch_get_global_queue(0, 0);
    group = dispatch_group_create();
   
    dispatch_group_enter(group);
    dispatch_group_async(group, gloabalQueue, ^{
        [self getAppStoreInfomation];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, gloabalQueue, ^{
        [self postAppIsAvailable];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self showVersionMegWithVersion:versonStr WithISImpottent:isImportVerson];
    });
}

// 获取AppStore信息
- (void)getAppStoreInfomation
{
    [[BXNetworkRequest defaultManager] postAppStoreInfosucceccResultWithDictionaty:^(id responseObject) {
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
        NSString *verStr = [NSString stringWithFormat:@"%@",dict[@"version"]];
        versonStr = verStr;
        
        dispatch_group_leave(group);
    } faild:^(NSError *error) {
    }];
}

// 获取程序是否可用
- (void)postAppIsAvailable
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXAppIsAvailable;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            isImportVerson = dict[@"body"][@"upgrade"];

            NSString *upstr = dict[@"body"][@"bizUpgrade"];
            
            if ([upstr isEqualToString:@"1"]) { // 升级账号类型 1：停服公告 2：升级公告
                [defaults setObject:@"1" forKey:@"BIZUPGRADE"];
                [defaults setObject:@"" forKey:@"ISLOCKVC"];
                
            } else if ([upstr isEqualToString:@"2"]) {
                [defaults setObject:@"2" forKey:@"BIZUPGRADE"];
            } else {
                [defaults setObject:@"" forKey:@"BIZUPGRADE"];
            }
            [defaults synchronize];
            
            
            //停服公告
            if ([upstr isEqualToString:@"1"]) {
                
                NSString *loginStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:DDKeyLoginState]];
                if ([loginStr isEqualToString:@"1"]) {  //已登录的退出账号
                    [self clickLogout];
                }
                
                
                self.ddcoverView = [[DDCoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                self.ddcoverView.viewStyle = DDViewStyleUpgradeStopView;
                self.ddcoverView.delegate = self;
                
            }
        }
        
        dispatch_group_leave(group);
    } faild:^(NSError *error) {
        
    }];
}

/**
 点击停服公告确定按钮
 */
-(void)didClickTfsjBtn {
    
    [self.ddcoverView removeUpgradeView];
    
}

- (void)clickLogout
{
    // 清除缓存
    [AppUtils clearLoginDefaultCachesAndCookieImgCaches:YES];
    
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:0];
    tabBarVC.selectedIndex = 0;
}

// 弹出版本提示
- (void)showVersionMegWithVersion:(NSString *)version WithISImpottent:(NSString *)isImprot
{
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVerson = infoDict[kShortVersion];

    if ([currentVerson compare:version] == NSOrderedAscending) {
        [self upgradeAPPWithisImport:isImprot];
    }
}

// 判断是否是重大版本更新
- (void)upgradeAPPWithisImport:(NSString *)isImport
{
    // 1-强制更新 0-正常更新
    if ([isImport intValue] == 1) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"系统升级，快去AppStore更新吧。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"现在升级", nil];
        [alter show];
        return;
    }
    
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"下载新版红包袋，更多精彩" delegate:self cancelButtonTitle:@"现在升级" otherButtonTitles:@"稍后再说", nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
    }
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

/** 退出程序 */
- (void)exitApplication {
    
    /*
     警告：不要使用exit函数，调用exit会让用户感觉程序崩溃了，不会有按Home键返回时的平滑过渡和动画效果；另外，使用exit可能会丢失数据，因为调用exit并不会调用-applicationWillTerminate:方法和UIApplicationDelegate方法；
     如果在开发或者测试中确实需要强行终止程序时，推荐使用abort 函数和assert宏；
     */
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        //        exit(0); // 退出程序，还在后台中 c语言 黑屏时间短一些
        //        abort(); // 退出程序，黑屏，也不现实原平 模拟器的话 只会崩溃在这里 正常的话会退出 黑屏时间长一些
        //        assert(0);
//        [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)]; // 私有api 后台中有
        
    }];
    
}

#pragma mark - 跳转到银行存管
+ (void)pushBankDepositoryWithVC:(UIViewController *)vc urlStr:(NSString *)urlStr
{
    [APPVersonModel pushBankDepositoryWithVC:vc urlStr:HXBankCiguan titleStr:@"银行存管"];
}

#pragma mark - 跳转到银行存管
+ (void)pushBankDepositoryWithVC:(UIViewController *)vc urlStr:(NSString *)urlStr titleStr:(NSString *)str
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
    DDActivityWebController *weVc = [sb instantiateInitialViewController];
    
    NSString *bannerUrl;
    
    HXTabBarViewController *tabbar = (HXTabBarViewController *)vc.tabBarController;
    
    if (tabbar.bussinessKind){
        bannerUrl = [self urlWithPersonalInfo:urlStr WithState:@"1"];
    } else {
        bannerUrl = [self urlWithPersonalInfo:urlStr WithState:@"0"];
    }
    
    weVc.webUrlStr = bannerUrl;
    weVc.webTitleStr = str;
    
    [vc.navigationController pushViewController:weVc animated:YES];
}

#pragma mark - 跳转到银行存管
+ (void)pushFivePageWithVC:(UIViewController *)vc urlStr:(NSString *)urlStr
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
    DDActivityWebController *weVc = [sb instantiateInitialViewController];
    
    NSString *bannerUrl;
    
    HXTabBarViewController *tabbar = (HXTabBarViewController *)vc.tabBarController;
    
    if (tabbar.bussinessKind){
        bannerUrl = [self urlWithPersonalInfo:urlStr WithState:@"1"];
    } else {
        bannerUrl = [self urlWithPersonalInfo:urlStr WithState:@"0"];
    }
    
    weVc.webUrlStr = bannerUrl;
//    weVc.webTitleStr = @"银行存管上线";
    
    [vc.navigationController pushViewController:weVc animated:YES];
}

//登录状态下拼接参数
+ (NSString *)urlWithPersonalInfo:(NSString *)url WithState:(NSString *)state
{
    
    NSString *finalUrl = nil;
    if ([state isEqualToString:@"1"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *username = [defaults objectForKey:@"username"];
        NSString *_U = [defaults objectForKey:@"userId"];
        NSString *_T = [defaults objectForKey:@"_T"];
        NSString *roles = [defaults objectForKey:@"roles"];
        NSString *hidden = @"1";
        
        if ([url rangeOfString:@"?"].location != NSNotFound) {
            finalUrl = [NSString stringWithFormat:@"%@&t=%@&u=%@&nickname=%@&roles=%@&hidden=%@",url,_T,_U,username,roles,hidden];
        } else {
            finalUrl = [NSString stringWithFormat:@"%@?t=%@&u=%@&nickname=%@&roles=%@&hidden=%@",url,_T,_U,username,roles,hidden];
        }
    } else {
        NSString *hidden = @"1";
        if ([url rangeOfString:@"?"].location != NSNotFound) {
            finalUrl = [NSString stringWithFormat:@"%@&t=null&u=null&nickname=null&roles=null&hidden=%@",url,hidden];
        }else{
            finalUrl = [NSString stringWithFormat:@"%@?t=null&u=null&nickname=null&roles=null&hidden=%@",url,hidden];
        }
    }
    
    return finalUrl;
}

#pragma mark - 首页弹框每五天一弹框
+ (void)showHomeAlertEveryDayWithVC:(UIViewController *)vc
{
    HXAlertAccount *alertAccout = [HXAlertAccount sharedHXAlertAccount];
    HXAlertAccount *alertAccoutNew = [alertAccout coderAlertAccout];
    if (alertAccoutNew) { // 第一次没数据
        alertAccout = alertAccoutNew;
    }
    
    NSString *num = alertAccout.numStr;
    NSString *timeStr = alertAccout.showTime;
//    NSString *timeStr = @"2017-12-25";

    TimeState timestate = [NSDate timeStateWithTimeStrWithStr:timeStr];

    if (timestate == TimeStateNow) { // 时间一致
        BOOL showAlert = alertAccout.show; // no:不隐藏  yes:隐藏弹框
        if (showAlert) return;

        [self setHXAlertAccount:alertAccout isFisrt:YES vc:vc];
    }

    // 时间不一致：1：第二天 2：删除app
    if (!num) { // 新下载app情况
        [self setHXAlertAccount:alertAccout isFisrt:NO vc:vc];
    } else { // 第二天：不是当天
        [self setHXAlertAccount:alertAccout isFisrt:YES vc:vc];
    }
}

+ (void)setHXAlertAccount:(HXAlertAccount *)alertAcout isFisrt:(BOOL)isFisrt vc:(UIViewController *)vc
{
    NSString *num = alertAcout.numStr;
    NSString *imgStr = @"";

    if (isFisrt == YES) { // 每天累加https://www.hongbaodai.com
        int numNew = [num intValue];
        
        if (numNew == 5) {
            numNew = 2;
        } else {
            numNew += 1;
        }
        num = [NSString stringWithFormat:@"%d",numNew];
        imgStr = [NSString stringWithFormat:@"show%d",numNew];
        alertAcout.numStr = [NSString stringWithFormat:@"%d",numNew];
    } else { // 或者重新下载app使用
     
        num = @"2";
        imgStr = @"show2";
        alertAcout.numStr = @"2";
    }
    
    NSString *str = [NSDate formmatDateSFM];
    alertAcout.showTime  = str;
    alertAcout.show = YES;
    [alertAcout encodeAlertAccout];
    [self showAlertViewWithStr:imgStr vc:vc numEnd:[num intValue]];
}

+ (void)showAlertViewWithStr:(NSString *)str vc:(UIViewController *)vc numEnd:(int)numEnd
{
    switch (numEnd) {
        case 1:
            [self showOneWithStr:str vc:vc numEnd:numEnd];
            break;
        case 2:
            [self showTwoWithStr:str vc:vc numEnd:numEnd];
            break;
        case 3:
            [self showThreeWithStr:str vc:vc numEnd:numEnd];
            break;
        case 4:
             [self showFourWithStr:str vc:vc numEnd:numEnd];
            break;
        case 5:
            [self showFiveWithStr:str vc:vc numEnd:numEnd];
            break;
        default:
            break;
    }
}

+ (void)showOneWithStr:(NSString *)str vc:(UIViewController *)vc numEnd:(int)numEnd
{
    // show1
    [AlertImgViewController alertImgViewControllerWithImageStr:str butColor:[UIColor colorWithHex:@"#FF3A3B"] moreBlock:^{
        [APPVersonModel pushBankDepositoryWithVC:vc urlStr:HXBankCiguan titleStr:@"银行存管"];
    }];
}

+ (void)showTwoWithStr:(NSString *)str vc:(UIViewController *)vc numEnd:(int)numEnd
{
    // show2
    [AlertImgViewController alertImgViewControllerWithImageStr:str butColor:[UIColor colorWithHex:@"#f6ab00"] moreBlock:^{
        DDWebViewVC *web = [[DDWebViewVC alloc] init];
        web.webType = DDWebTypeHOMEAQBZ;
        web.navTitle = @"安全保障";
        [vc.navigationController pushViewController:web animated:YES];
        
    }];
}

+ (void)showThreeWithStr:(NSString *)str vc:(UIViewController *)vc numEnd:(int)numEnd
{
    // show3
    [AlertImgViewController alertImgViewControllerWithImageStr:str butColor:[UIColor colorWithHex:@"#FFAB15"] moreBlock:^{
        [APPVersonModel pushBankDepositoryWithVC:vc urlStr:HXBankThreePage titleStr:@"等保三级"];
    }];
}

+ (void)showFourWithStr:(NSString *)str vc:(UIViewController *)vc numEnd:(int)numEnd
{
    // show4
    [AlertImgViewController alertImgViewControllerWithImageStr:str butColor:[UIColor colorWithHex:@"#FFAB15"] moreBlock:^{
        [APPVersonModel pushBankDepositoryWithVC:vc urlStr:HXBankSafe titleStr:@"政策合规"];
    }];
}

+ (void)showFiveWithStr:(NSString *)str vc:(UIViewController *)vc numEnd:(int)numEnd
{
    // show5
    [AlertImgViewController alertImgViewControllerWithImageStr:str butColor:[UIColor colorWithHex:@"#FFAB15"] moreBlock:^{
        [APPVersonModel pushBankDepositoryWithVC:vc urlStr:HXBankFivePage titleStr:@"风控措施"];
    }];
}

#pragma mark - 第三类弹框
// 提现、一锤定音、唯我独尊弹框
+ (void)showAlertViewThreeWith:(MoneyPart)moneyPart textStr:(NSString *)texStr left:(void(^)(void))leftBlock right:(void(^)(void))rightBlock
{
    NSString *imgstr = @"";
    NSString *textstr = texStr;

    if (moneyPart == MoneyPartOnlyMe) {
        imgstr = @"onlyOneImage";
    } else if (moneyPart == MoneyPartOneStep) {
        imgstr = @"oneStepImage";
    } else if (moneyPart == MoneyPartMore) {
        imgstr = @"seeMore";
    }
    
    AlertThreeViewController *alertVC = [AlertThreeViewController createAlertThreeViewControllerWithTextStr:textstr imgStr:imgstr];
    alertVC.leftBtnBlock = ^{
        leftBlock();
    };
    alertVC.rightBtnBlock = ^{
        if (rightBlock) {
            rightBlock();
        }
    };
}


@end
