//
//  BXWithdrawLoadingController.m
//  HBD
//
//  Created by echo on 15/10/26.
//  提现 提现处理中

#import "BXWithdrawLoadingController.h"
#import "HXTabBarViewController.h"

@interface BXWithdrawLoadingController ()

@property (weak, nonatomic) IBOutlet UIButton *muAcooutBut;

@end

@implementation BXWithdrawLoadingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提现";
 
    self.muAcooutBut.layer.masksToBounds = YES;
    self.muAcooutBut.layer.cornerRadius = 22;

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

/** 去出借 */
- (IBAction)goToInvest:(id)sender
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 1;
}

- (IBAction)goBackMyAccount:(id)sender
{
    [self doBack];
}

@end
