//
//  BXRechargeSuccessController.m
//  HBD
//
//  Created by echo on 15/10/9.
//

#import "BXRechargeSuccessController.h"
#import "HXTabBarViewController.h"

@interface BXRechargeSuccessController ()

@property (weak, nonatomic) IBOutlet UIButton *reRechargeBut;

// 立即出借
- (IBAction)goToInvestBtnClick:(id)sender;
// 继续充值
- (IBAction)reRechargeBtnClick:(id)sender;

@end

@implementation BXRechargeSuccessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"充值";

    self.reRechargeBut.layer.masksToBounds = YES;
    self.reRechargeBut.layer.cornerRadius = 22;

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
    tabBarVC.selectedIndex = 2;
}

/** 立即出借 */
- (IBAction)goToInvestBtnClick:(id)sender
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 1;
}

/** 继续充值 */
- (IBAction)reRechargeBtnClick:(id)sender
{
    int j = 0;
    for (int i=0; i < self.navigationController.viewControllers.count; i ++) {
        
        if ([NSStringFromClass([self.navigationController.viewControllers[i] class]) isEqualToString:@"BXHFRechargeController"]) {
            j = i;
        }
    }
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i < j + 1; i++) {
        [array addObject:self.navigationController.viewControllers[i]];
    }
    self.navigationController.viewControllers = array;
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"充值成功"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"充值成功"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
