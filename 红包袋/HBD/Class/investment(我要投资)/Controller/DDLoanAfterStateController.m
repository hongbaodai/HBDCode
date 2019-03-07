//
//  DDLoanAfterStateController.m
//  HBD
//
//  Created by hongbaodai on 17/1/19.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDLoanAfterStateController.h"

@interface DDLoanAfterStateController ()

@end

@implementation DDLoanAfterStateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 判断登录状况
    HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
    if (tabbar.bussinessKind) {
        if (self.stateStyle == DDStateTypeFaild) {
            self.iconImg.image = IMG(@"出借失败图标");
            self.stateLab.text = @"很遗憾，出借失败！";
            self.detailLab.text = @"该产品只针对新手首次出借，去出借其他产品吧！";
            [self.stateBtn setTitle:@"重新出借" forState:UIControlStateNormal];
            [self.stateBtn addTarget:self action:@selector(stateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        } else {
            //预留其他活动
        }
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
        BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.isPresentedWithMyAccount = 0;
        BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

- (void)stateBtnClick
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:3];
    tabBarVC.selectedIndex = 1;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
