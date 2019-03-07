//
//  DDDecActivityController.m
//  ump_xxx1.0
//
//  Created by hongbaodai on 16/11/30.
//  Copyright © 2016年 李先生. All rights reserved.
//

#import "DDDecActivityController.h"
#import "DDInviteFriendVc.h"


@interface DDDecActivityController ()
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;
// 手势解锁相关
@property (strong, nonatomic) LLLockViewController* lockVc;

@end

@implementation DDDecActivityController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"活动详情";
    [_inviteBtn addTarget:self action:@selector(inviteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _viewOne.backgroundColor = [UIColor colorWithHex:@"#E46356"];
    _viewTwo.backgroundColor = [UIColor colorWithHex:@"#E46356"];
    _viewThree.backgroundColor = [UIColor colorWithHex:@"#EE7F71"];
    _viewFour.backgroundColor = [UIColor colorWithHex:@"#EE7F71"];
}

- (void)inviteBtnClick
{
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    if (!tabbar.bussinessKind) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
        BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.loginStyle = DDLoginStyleDec;
        BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:Nav animated:YES completion:nil];
        
    } else {

        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDInviteFriendVc" bundle:nil];
        DDInviteFriendVc *infVc = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:infVc animated:YES];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
