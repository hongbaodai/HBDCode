//
//  DDRegisterSuccessVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/16.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDRegisterSuccessVC.h"
#import "HXTabBarViewController.h"
#import "MyRedPacketSwitchVC.h"
#import "HXTextAndButModel.h"
#import "BXOpenLDAccountEqianBaoController.h"

@interface DDRegisterSuccessVC () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nowSeeBtn;
@property (weak, nonatomic) IBOutlet HXButton *openAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *freeSeeBtn;

@property (weak, nonatomic) IBOutlet UIView *textAndButView;


@end

@implementation DDRegisterSuccessVC{
    NSDictionary  *userCardInfo;     // 用户绑卡信息
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    CGRect fra = self.textAndButView.bounds;
    fra.size.width = (SCREEN_WIDTH) - 2 * 24;
    [HXTextAndButModel hxProjectItem:self.textAndButView strImgViewFrame:fra status:TextAndImgStatusRegister];
  
    self.nowSeeBtn.layer.cornerRadius = _nowSeeBtn.height_/2;
    self.nowSeeBtn.layer.masksToBounds = YES;
    [self.nowSeeBtn addTarget:self action:@selector(nowSeeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.openAccountBtn addTarget:self action:@selector(openAccountBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nowSeeBtnClick {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 导航栏变红
    [self.navigationController.navigationBar setBackgroundImage:[AppUtils imageWithColor:kColor_Red_Main] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    MyRedPacketSwitchVC *redpacketVC = [[MyRedPacketSwitchVC alloc] init];
    redpacketVC.cardPersonDict = userCardInfo;
    [self.navigationController pushViewController:redpacketVC animated:YES];

}

- (void)openAccountBtnClick {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 导航栏变红
    [self.navigationController.navigationBar setBackgroundImage:[AppUtils imageWithColor:kColor_Red_Main] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc]init];
    [self.navigationController pushViewController:openLDAccountVC animated:YES];
}


//- (void)freeSeeBtnClick {
//
//    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
//    dele.window.rootViewController = tabBarVC;
//    [tabBarVC loginStatusWithNumber:1];
//    tabBarVC.selectedIndex = 0;
//}


/** 获取用户绑卡信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        [self makeUserBankCardInfoWithDict:dict];
    } faild:^(NSError *error) {}];
}

- (void)makeUserBankCardInfoWithDict:(NSDictionary *)dict
{
    if ([dict[@"body"][@"resultcode"] integerValue] != 0) return ;
    //缓存用户信息
    userCardInfo = dict;
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate-隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
    self.btnCha.hidden = isShowHomePage;
}


@end
