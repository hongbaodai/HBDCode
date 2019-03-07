//
//  DDVipPrivilegeController.m
//  HBD
//
//  Created by hongbaodai on 17/1/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDVipPrivilegeController.h"

@interface DDVipPrivilegeController ()

@end

@implementation DDVipPrivilegeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"VIP会员特权";
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

/** 创建DDVipPrivilegeController */
+ (instancetype)creatVCFromStroyboard
{
    return [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"DDVipPrivilegeController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
