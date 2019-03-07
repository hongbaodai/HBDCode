//
//  BXAboutusController.m
//  ump_xxx1.0
//
//  Created by echo on 15/9/9.
//  Copyright (c) 2015年 李先生. All rights reserved.
//

#import "BXAboutusController.h"

@interface BXAboutusController ()

@end

@implementation BXAboutusController

-(void)awakeFromNib{
    [super awakeFromNib];
    //获取屏幕宽高
//    CGFloat bounds_W = self.view.bounds.size.width;
//    CGFloat bounds_H = self.view.bounds.size.height;
    
    //版权所有
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 100)];
    bottomView.backgroundColor = [UIColor clearColor];
    ;
    UILabel *sinvoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 20)];
    sinvoLabel.textAlignment = NSTextAlignmentCenter;
    sinvoLabel.text = @"版权所有© 北京红包袋网络科技有限公司";
    sinvoLabel.font = [UIFont boldSystemFontOfSize:12];
    sinvoLabel.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.86);
   
    sinvoLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:sinvoLabel];
    
    //sinvo图标
    UIImageView *sinvoLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    sinvoLogo.frame = CGRectMake(0, 0, 123, 50);
    sinvoLogo.center = CGPointMake(SCREEN_WIDTH * 0.5, 40);
    [self.view addSubview:sinvoLogo];
    
//    //版本信息
////    UIButton *versionInfo = [UIButton buttonWithType:UIButtonTypeSystem];
//    versionInfo.frame = CGRectMake(0, 0, 60, 16);
//    versionInfo.center = CGPointMake(bounds_W * 0.5, 150);
//    versionInfo.enabled = NO;
//    versionInfo.backgroundColor = DDRGB(228, 228, 228);
//    [versionInfo setTitleColor:DDRGB(182, 182, 182) forState:UIControlStateNormal];
//    NSString *key =  @"CFBundleShortVersionString";
//    // 3.2获取软件当前版本号
//    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
//    NSString *currentVerson = [NSString stringWithFormat:@"V %@",infoDict[key]];
//    
//    
//    [versionInfo setTitle:currentVerson forState:UIControlStateNormal];
//    versionInfo.titleLabel.font = [UIFont boldSystemFontOfSize:10];
//    [self.view addSubview:versionInfo];
//    [self makeRoundButton:versionInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于我们";
}

#pragma mark -tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)makeRoundButton:(UIButton *)btn
{
    [btn.layer setCornerRadius:8];
    [btn.layer setMasksToBounds:YES];
}

#pragma mark - view视图方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"关于我们"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"关于我们"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
