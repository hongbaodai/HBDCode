//
//  BXWithdrawFailureController.m
//  HBD
//
//  Created by echo on 15/10/14.
//  提现失败

#import "BXWithdrawFailureController.h"
#import "HXTabBarViewController.h"

@interface BXWithdrawFailureController ()

@end

@implementation BXWithdrawFailureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提现";
    [self addBackItemWithAction];
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
    tabBarVC.selectedIndex = 3;
}

/** 重新提现 */
- (IBAction)reWithdrawBtnClick:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
