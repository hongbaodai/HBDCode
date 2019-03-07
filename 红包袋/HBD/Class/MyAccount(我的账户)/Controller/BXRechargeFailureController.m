//
//  BXRechargeFailureController.m
//  HBD
//
//  Created by echo on 15/10/9.
//

#import "BXRechargeFailureController.h"
#import "BXHFRechargeController.h"
#import "HXTabBarViewController.h"

@interface BXRechargeFailureController ()

// 失败原因
@property (nonatomic, weak) IBOutlet UILabel *responseMsgLab;
// 重新充值
- (IBAction)reRechargeBtnClick:(id)sender;

@end

@implementation BXRechargeFailureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"充值";
    [self addBackItemWithAction];
    self.responseMsgLab.text = self.responseMsg;
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
    tabBarVC.selectedIndex = 2;
}

/** 重新充值 */
- (IBAction)reRechargeBtnClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    BXHFRechargeController *HFRecharge = [storyboard instantiateViewControllerWithIdentifier:@"BXHFRechargeVC"];
    [self.navigationController pushViewController:HFRecharge animated:YES];
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"充值失败"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"充值失败"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
