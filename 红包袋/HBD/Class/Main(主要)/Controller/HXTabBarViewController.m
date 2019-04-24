//
//  HXTabBarViewController.m
//  HBD
//
//  Created by hongbaodai on 2017/10/30.
//

#import "HXTabBarViewController.h"
#import "BXNavigationController.h"
#import "DDHomeVC.h"
#import "HXPopUpViewController.h"
#import "AlertImgViewController.h"

@interface HXTabBarViewController ()<UITabBarControllerDelegate>
{
   // 导航栏
    BXNavigationController *_accountNav;
}

@end

@implementation HXTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"tabbarBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//此种方法改变背景变短
    UIImageView *ima = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbarBack"]];
    ima.frame = CGRectMake(0,0,self.view.frame.size.width, 49);
    //ima.userInteractionEnabled = YES;
    self.tabBar.opaque = YES;
    //[self.tabBar insertSubview:ima atIndex:0];
    //去黑线去不掉
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [UITabBar appearance].layer.borderWidth = 0.0f;
    [UITabBar appearance].clipsToBounds = YES;

    self.delegate = self;
    [self setChildControllers];
    self.selectedIndex = 0;
    //登录状态
    self.bussinessKind = 0;
}

/** 修改登录密码回来重新修改ui */
- (void)reloadHomeVC
{
    NSInteger num = 0;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self childViewControllers]];
    [arr removeObjectAtIndex:num];
    
    //我的账户
    BXNavigationController *nav = [self setChildControllerWithSBName:@"DDHomeVC" title:@"" itemTitle:@"首页" imageName:@"tabbar_three" selectedImageName:@"tabbar_threeSelect" add:NO];
    [arr insertObject:nav atIndex:num];
    NSArray *arrEnd = [NSArray arrayWithArray:arr];
    self.viewControllers = arrEnd;
    
    
}

/** 修改登录密码回来重新修改ui */
- (void)reloadSelecThres
{
    NSInteger num = 2;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self childViewControllers]];
    [arr removeObjectAtIndex:num];
    
    //我的账户
    BXNavigationController *nav = [self setChildControllerWithSBName:@"BXMyAccount" title:@"" itemTitle:@"我的账户" imageName:@"tabbar_two" selectedImageName:@"tabbar_twoSelect" add:NO];
    [arr insertObject:nav atIndex:num];
    NSArray *arrEnd = [NSArray arrayWithArray:arr];
    self.viewControllers = arrEnd;

}

/** 修改登录密码回来重新修改ui还有出借详情页纯文字弹框 */
- (void)reloadSelecAndAlert
{
   
    NSInteger num = 2;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self childViewControllers]];
    [arr removeObjectAtIndex:num];
    
    //我的账户
    BXNavigationController *nav = [self setChildControllerWithSBName:@"BXMyAccount" title:@"" itemTitle:@"我的账户" imageName:@"tabbar_three" selectedImageName:@"tabbar_threeSelect" add:NO];
    [arr insertObject:nav atIndex:num];
    NSArray *arrEnd = [NSArray arrayWithArray:arr];
    self.viewControllers = arrEnd;
    
    NSInteger num1 = 1;
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[self childViewControllers]];
    [arr1 removeObjectAtIndex:num1];
    
    //我的账户
    BXNavigationController *nav1 = [self setChildControllerWithSBName:@"DDInvestListVC" title:@"供应链金融" itemTitle:@"我要出借" imageName:@"tabbar_two" selectedImageName:@"tabbar_twoSelect" add:YES];
    
    [arr1 insertObject:nav1 atIndex:num1];
    NSArray *arrEnd1 = [NSArray arrayWithArray:arr1];
    self.viewControllers = arrEnd1;
    
     [self dismissVC];
    
}

- (void)dismissVC
{
    if ([self.presentedViewController isKindOfClass:[HXPopUpViewController class]] ||[self.presentedViewController isKindOfClass:[AlertImgViewController class]]) {
        UIViewController *vc = self.presentedViewController;
        vc.view.alpha = 0;
        [vc dismissViewControllerAnimated:YES completion:nil];
        [vc dismissViewControllerAnimated:YES completion:nil];

    }
}

/** 设置子控制器 */
- (void)setChildControllers
{
    [self removeFromParentViewController];
    self.tabBarItem.title = @"更多发现";
    // 图片颜色
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSForegroundColorAttributeName] = DDRGB(136, 136, 137);//颜色属性
//
//    NSMutableDictionary *selectAttri = [NSMutableDictionary dictionary];
//    selectAttri[NSForegroundColorAttributeName] = DDRGB(231, 56, 61);
//
//    [self.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    self.tabBarItem.image = [IMG(@"tabbar_dai_nor") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    [self.tabBarItem setTitleTextAttributes:selectAttri forState:UIControlStateSelected];
//    self.tabBarItem.selectedImage = [IMG(@"tabbar_dai_sel") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //首页
    [self setChildControllerWithSBName:@"DDHomeVC" title:@"" itemTitle:@"首页" imageName:@"tabbar_one" selectedImageName:@"tabbar_oneSelect" add:YES];
    //我要出借
    [self setChildControllerWithSBName:@"DDInvestListVC" title:@"供应链金融" itemTitle:@"我要出借" imageName:@"tabbar_two" selectedImageName:@"tabbar_twoSelect" add:YES];
    //我的账户
    [self setChildControllerWithSBName:@"BXMyAccount" title:@"" itemTitle:@"我的账户" imageName:@"tabbar_three" selectedImageName:@"tabbar_threeSelect" add:YES];
    //更多发现
    BXNavigationController *navRoot = [self setChildControllerWithSBName:@"MoreSB" title:@"更多发现" itemTitle:@"更多发现" imageName:@"tabbar_four" selectedImageName:@"tabbar_fourSelect" add:YES];
    _accountNav = navRoot;
}

///设置每个子控制器Ô
- (BXNavigationController *)setChildControllerWithSBName:(NSString *)SBName title:(NSString *)title itemTitle:(NSString *)itemTitle imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName add:(BOOL)isAdd
{
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

    //创建子控制器
    BXNavigationController *nvc = [UIStoryboard storyboardWithName:SBName bundle:nil].instantiateInitialViewController;
    //设置title
    nvc.topViewController.title = title;
    //设置tabbarTitle
    nvc.tabBarItem.title = itemTitle;

    //E7383d
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0F], NSForegroundColorAttributeName:[UIColor colorWithHex:@"#E7383d"]} forState:UIControlStateSelected];

    // 字体颜色 未选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0F],  NSForegroundColorAttributeName:[UIColor colorWithHex:@"#888889"]} forState:UIControlStateNormal];

    //设置tabar图片
    nvc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置tabar选中图片
    nvc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (isAdd) {
        //加入self中
        [self addChildViewController:nvc];
    }
    return nvc;
}
/** 设置选择位置 */
- (void)loginStatusWithNumber:(int)Number
{
    if (Number == 0) {
        self.bussinessKind = 0;
    }else if(Number == 1){
        self.bussinessKind = 1;
    }else if(Number == 2) {
        self.bussinessKind = 0;
        self.selectedIndex = 0;
    }else if(Number == 3) {
        self.bussinessKind = 1;
        self.selectedIndex = 0;
    } else if(Number == 4) {
        self.bussinessKind = 1;
        self.selectedIndex = 2;
    }
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UITabBarItem *tabBarItem = viewController.tabBarItem;
    if (self.bussinessKind == 0) {
        if ([tabBarItem.title isEqualToString:@"我的账户"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
            BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            loginVC.isPresentedWithMyAccount = 1;
            BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:Nav animated:YES completion:nil];
            return NO;
        }
    }
    if ([tabBarItem.title isEqualToString:@"首页"] || [tabBarItem.title isEqualToString:@"我的账户"] || [tabBarItem.title isEqualToString:@"更多发现"]) {
        // 通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarChangeNotifi" object:nil];
        
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
        self.title = viewController.tabBarItem.title;
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

@end
