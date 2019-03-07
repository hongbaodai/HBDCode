
//
//  CustomerServiceVC.m
//  test
//
//  Created by hongbaodai on 2017/9/22.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "CustomerServiceVC.h"
#import "AppUtils.h"
#import <YYText/YYText.h>
#import "HelpCentersVC.h"

@interface CustomerServiceVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CustomerServiceVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadUdesk];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self pushCustomServiceVC];
    } else if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [AppUtils contactCustomerService];
    } else if (indexPath.row == 2) {
        [self pushHelpCentersVC];
    }
}

- (void)pushHelpCentersVC
{
    HelpCentersVC *vc = [[HelpCentersVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadUdesk
{
    /**
     //注意sdktoken 是客户的唯一标识，用来识别身份,是你们生成传入给我们的。
     //sdk_token: 传入的字符请使用 字母 / 数字 等常见字符集 。就如同身份证一样，不允许出现一个身份证号对应多个人，或者一个人有多个身份证号;其次如果给顾客设置了邮箱和手机号码，也要保证不同顾客对应的手机号和邮箱不一样，如出现相同的，则不会创建新顾客。
     //    customer.nickName = @"我是udesk测试(可以随时把我关闭)";
     //    customer.email = @"test@udesk.cn";
     */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [defaults objectForKey:@"phoneNumber"];
    if (phoneNumber.length <= 0) {
        phoneNumber = @"未登录";
    }
//
    //初始化公司（appKey、appID、domain都是必传字段）
    UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:@"hongbaodai.udesk.cn" appKey:@"4b03a91a5a3ba9220b791b7c2e4ceae8" appId:@"1a81ad417da619a9"];
    
    UdeskCustomer *customer = [UdeskCustomer new];
    customer.sdkToken = phoneNumber; // 这里我们可以用用户的电话传进去🐷
    customer.nickName = phoneNumber;
    customer.cellphone = phoneNumber;
    customer.customerDescription = @"app端";
    //初始化sdk
    [UdeskManager initWithOrganization:organization customer:customer];
}

- (void)pushCustomServiceVC
{
    /**
     
     //自定义留言回调
     [chat leaveMessageButtonAction:^(UIViewController *viewController){
     CuViewController *mevieVC = [[CuViewController alloc] init];
     [viewController presentViewController:mevieVC animated:YES completion:nil];
     
     }];
      UdeskChatViewController
     
     // 自定义cell
     NSDictionary *dict = @{
     @"productImageUrl":@"https://img.club.pchome.net/kdsarticle/2013/11small/21/fd548da909d64a988da20fa0ec124ef3_1000x750.jpg",
     @"productTitle":@"测试测试测试测你测试测试测你测试测试测你测试测试测你测试测试测你测试测试测你！",
     @"productDetail":@"¥88888.088888.088888.0",
     @"productURL":@"http://www.baidu.com"
     };
     [chat setProductMessage:dict];
     // 设置用户头像：通过URL设置头像
     // [chat setCustomerAvatarWithURL:@"头像URL"];
     */
    
    UdeskSDKStyle *sty = [UdeskSDKStyle defaultStyle];
    sty.navBackButtonImage = [UIImage imageNamed:@"fanhuianniu"];
    sty.navBackButtonColor = [UIColor whiteColor];
    sty.navigationColor = [UIColor lightGrayColor];
    sty.titleColor = [UIColor whiteColor];
    
    UdeskSDKManager *chat = [[UdeskSDKManager alloc] initWithSDKStyle:sty];
    //如果用户处于排队状态，当用户离开聊天界面，会强制把该用户移除排队
    [chat setQuitQueueType:UdeskForceQuit];
    
    // 设置客户在线
    [UdeskManager setupCustomerOnline];
    [chat pushUdeskInViewController:self completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

}
- (void)dealloc
{
    [UdeskManager setupCustomerOffline];
    [UdeskManager logoutUdesk];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
