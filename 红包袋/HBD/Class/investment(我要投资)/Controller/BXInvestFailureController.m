//
//  BXInvestFailureController.m
//  HBD
//
//  Created by echo on 15/10/8.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXInvestFailureController.h"

@interface BXInvestFailureController ()

@property (nonatomic, weak) IBOutlet UILabel *failureState;
@property (nonatomic, weak) IBOutlet UILabel *failureMessage;

// 重新出借
- (IBAction)reinvestBtnClick:(HXButton *)sender;

@end

@implementation BXInvestFailureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我要出借";
    [self addBackItemWithAction];
    
    if (self.respDesc.length) {
        self.failureState.text = @"失败原因：";
        self.failureMessage.text = self.respDesc;
    } else {
        self.failureState.text = @"";
        self.failureMessage.text = @"";
    }
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

// 重新出借
- (IBAction)reinvestBtnClick:(HXButton *)sender
{
    [self doBack];
}

#pragma mark - view视图方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"出借失败"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"出借失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
