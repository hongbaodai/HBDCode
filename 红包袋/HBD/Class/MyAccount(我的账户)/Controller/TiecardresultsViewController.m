//
//  TiecardresultsViewController.m
//  ump_xxx1.0
//
//  Created by a on 15/9/30.
//  Copyright (c) 2015年 李先生. All rights reserved.
//

#import "TiecardresultsViewController.h"

@interface TiecardresultsViewController ()

@end

@implementation TiecardresultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.tieTitle;
    self.OKbutton.layer.cornerRadius=3;
    [self addBackItemWithAction];
    if (self.isseccess==YES) {
        self.resultimage.image=[UIImage imageNamed:@"绑卡成功图标"];
        self.fallslable.text=@"";
        self.reasonlab.text=@"";
        self.tellab.text=@"";
        self.bigLab.text=@"恭喜您，绑卡成功！";
    } else {
        self.resultimage.image=[UIImage imageNamed:@"绑卡失败图标"];
        self.fallslable.text=@"失败原因:";
        self.reasonlab.text=self.reasonstr;
        self.bigLab.text=@"很遗憾，绑卡失败！";
    
    }
    [self.OKbutton addTarget:self action:@selector(backlastview) forControlEvents:UIControlEventTouchUpInside];
}

//自定义返回
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
    
}

- (void)doBack
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    BXTabBarController *tabBarVC = [[BXTabBarController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 2;
}

-(void)backlastview
{
    [self doBack];
}

#pragma mark - view视图方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isseccess == YES) {
        [MobClick beginLogPageView:@"绑卡成功"];
    } else {
        [MobClick beginLogPageView:@"绑卡失败"];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isseccess == YES) {
        [MobClick endLogPageView:@"绑卡成功"];
    } else {
        [MobClick endLogPageView:@"绑卡失败"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
