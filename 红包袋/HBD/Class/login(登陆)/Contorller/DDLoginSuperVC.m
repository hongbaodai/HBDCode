//
//  DDLoginSuperVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/25.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDLoginSuperVC.h"

@interface DDLoginSuperVC () 


@end

@implementation DDLoginSuperVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    
    [self setNavigationColorClear];

    [self setNavStyle];
}

- (void)setNavigationColorClear{
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [_btnCha removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.title];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [_btnCha removeFromSuperview];
}


//自定义导航按钮
- (void)setNavStyle {
    _btnCha = [[UIButton alloc] initWithFrame:CGRectMake(25, 25, 25, 25)];
    if (IS_iPhoneX) {
        _btnCha.frame = CGRectMake(25, 40, 25, 25);
    }
    [_btnCha setImage:IMG(@"btn_cha") forState:UIControlStateNormal];
    [self.navigationController.view addSubview:_btnCha];
    
    [_btnCha addTarget:self action:@selector(popToViewController) forControlEvents:UIControlEventTouchUpInside];

    [UIView animateWithDuration:1 animations:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

- (void)popToViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
