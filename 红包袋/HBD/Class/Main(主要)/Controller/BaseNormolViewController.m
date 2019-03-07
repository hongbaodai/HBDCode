//
//  BaseNormolViewController.m
//  HBD
//
//  Created by hongbaodai on 2017/10/9.
//

#import "BaseNormolViewController.h"
#import "UIColor+HexColor.h"
@interface BaseNormolViewController ()

@end

@implementation BaseNormolViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
