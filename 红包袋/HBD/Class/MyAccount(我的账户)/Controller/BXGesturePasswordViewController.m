//
//  BXGesturePasswordViewController.m
//  sinvo
//
//  Created by echo on 15/4/7.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXGesturePasswordViewController.h"
#import "HXTabBarViewController.h"
#import "BXMyAccountController.h"

@interface BXGesturePasswordViewController ()<LLLockGesTureDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic,weak) IBOutlet HXButton *nextBtn;


@end

@implementation BXGesturePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.nextBtn setBackgroundColor:[UIColor colorWithHex:COLOUR_YELLOW]];
}

//下一步 设置手势密码
- (IBAction)NextBtnClick:(HXButton *)sender
{
    LLLockViewController *lockViewVC  = [[LLLockViewController alloc] init];
    lockViewVC.GestureDelegate = self;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *pswd = [ud objectForKey:@"lock"];
    
    if (pswd == nil
        || [pswd isEqualToString:@""]
        || [pswd isEqualToString:@"(null)"]) {
        
        lockViewVC.nLockViewType = LLLockViewTypeCreate;
        lockViewVC.isHidenButton = YES;
    } else {
        
        lockViewVC.nLockViewType = LLLockViewTypeModify;
    }
    lockViewVC.isFromChangePwd = YES;
    lockViewVC.transitioningDelegate = self;
    lockViewVC.modalPresentationStyle = UIModalPresentationCustom;
    lockViewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationController presentViewController:lockViewVC animated:NO completion:nil];
}

- (void)gestureVCPopVCWithType:(NSString *)type
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = (HXTabBarViewController *)dele.window.rootViewController;
    [tabBarVC loginStatusWithNumber:4];
    
    if([type isEqualToString:@"修改密码成功"]){
        //        tabBarVC.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if ([type isEqualToString:@"取消登录状态"]){
        
        tabBarVC.selectedIndex = 0;
    }
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置手势密码页"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置手势密码页"];
}

/**
 创建BXGesturePasswordViewController
 
 @return BXGesturePasswordViewController
 */
+ (instancetype)creatVCFromSB
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    BXGesturePasswordViewController *myData = [storyboard instantiateViewControllerWithIdentifier:@"gesturePassword"];
    return myData;
}


@end
