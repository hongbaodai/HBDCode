//
//  BXInvestSuccessController.m
//  HBD
//
//  Created by echo on 15/10/8.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  出借成功    

#import "BXInvestSuccessController.h"
#import "InvestmentRecordSwtichVC.h"

@interface BXInvestSuccessController ()

@property (weak, nonatomic) IBOutlet HXButton *continueBtn;

@property (weak, nonatomic) IBOutlet UIButton *seeInvestBtn;


@end

@implementation BXInvestSuccessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"出借成功";
    [self addBackItemWithAction];
    
    [self.continueBtn addTarget:self action:@selector(continueBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.seeInvestBtn addTarget:self action:@selector(seeInvestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.seeInvestBtn.layer.cornerRadius = 22;
    self.seeInvestBtn.layer.masksToBounds = YES;
}

//自定义返回
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
}

- (void)doBack
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

// 继续出借
- (void)continueBtnClick
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 1;
}

// 查看我的出借
- (void)seeInvestBtnClick
{
    InvestmentRecordSwtichVC *vc = [[InvestmentRecordSwtichVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"出借成功"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"出借成功"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
