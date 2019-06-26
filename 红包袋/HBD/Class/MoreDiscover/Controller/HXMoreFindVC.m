//
//  HXMoreFindVC.m
//  test
//
//  Created by hongbaodai on 2017/11/22.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXMoreFindVC.h"
#import "CustomerServiceVC.h"
#import "AnnouncementVC.h"
#import "ConntctUSVC.h"
#import "AboutRedPacketVC.h"
#import "DDWebViewVC.h"
#import "APPVersonModel.h"
#import "NSDate+Setting.h"
#import "HXWebVC.h"
#import "DDActivityWebController.h"

@interface HXMoreFindVC ()

@end

@implementation HXMoreFindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多发现";
    [self setupGroups];
}

- (void)setupGroups
{
    // 0组
    [self setUpGroup0];
    
    [self addSome];
}

- (void)setUpGroup0
{
    HXProuductGroup *group0 = [[HXProuductGroup alloc] init];
    group0.cellHeight = 51.0f;
    group0.headerHeight = 3.0f;
    group0.footerHeight = 0;
    
    HXArrowItem *customerService = [[HXArrowItem alloc] initWithImg:@"customerService" title:@"客户服务"];
    WS(weakSelf);
    customerService.option = ^(NSIndexPath *index) {
        CustomerServiceVC *servi = [[UIStoryboard storyboardWithName:@"MoreSB" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerServiceVC"];
        [weakSelf.navigationController pushViewController:servi animated:YES];
    };
        
    HXArrowItem *announcement = [[HXArrowItem alloc] initWithImg:@"announcement" title:@"平台公告"];
    announcement.destVC = [AnnouncementVC class];
    
    HXArrowItem *connectUS = [[HXArrowItem alloc] initWithImg:@"contactUs" title:@"联系我们"];
    connectUS.destVC = [ConntctUSVC class];

    HXArrowItem *aboutRed = [[HXArrowItem alloc] initWithImg:@"aboutUs" title:@"信息披露"];
    aboutRed.destVC = [AboutRedPacketVC class];
    aboutRed.option = ^(NSIndexPath *index) {
        [weakSelf goRedPacket];
    };
    
    HXLabelItem *theCurrentVersion = [[HXLabelItem alloc] initWithImg:@"theCurrentVersion" title:@"当前版本"];
    theCurrentVersion.text = @"当前版本为V2.5.0";
    
    group0.items = [NSMutableArray arrayWithObjects:customerService, announcement, connectUS, aboutRed, theCurrentVersion, nil];
    [self.datas addObject:group0];
}

- (void)goRedPacket
{
//    HXWebVC *vc = [[HXWebVC alloc] init];
//    NSString *aboutU1 = [NSString stringWithFormat:@"%@/abouthbd?hidden=1",DDNEWWEBURL];
//    vc.title = @"信息披露";
//    vc.urlStr = aboutU1;
//    [self.navigationController pushViewController:vc animated:YES];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
    DDActivityWebController *weVc = [sb instantiateInitialViewController];
    weVc.webTitleStr = @"信息披露";
    weVc.webUrlStr = [NSString stringWithFormat:@"%@/abouthbd?hidden=1",DDNEWWEBURL];;
    [self.navigationController pushViewController:weVc animated:YES];
}

- (void)addSome
{
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVerson = infoDict[kShortVersion];
    
    HXProuductGroup *group = self.datas[0];
    HXLabelItem *ite = group.items[4];
    
    ite.text = [NSString stringWithFormat:@"当前版本为v%@      ",currentVerson];
    [self.datas insertObject:ite atIndex:4];
}


@end
