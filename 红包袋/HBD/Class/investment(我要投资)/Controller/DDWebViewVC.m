//
//  DDWebViewVC.m
//  HBD
//
//  Created by hongbaodai on 17/3/23.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDWebViewVC.h"
#import <WebKit/WebKit.h>

@interface DDWebViewVC () <UIWebViewDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkwebView;

@end

@implementation DDWebViewVC
{
    NSString *urlString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navTitle != nil) {
        self.title = self.navTitle;
    } else {
        self.title = @"详情";
    }

    [self addWkwebview];
    [self loadWebviewContent];
    
}

- (void)addWkwebview {
    
    self.navigationController.navigationBar.translucent = NO;
    self.wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
//    self.wkwebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.wkwebView.UIDelegate = self;
    [self.view addSubview:self.wkwebView];
}


- (void)loadWebviewContent {
    
    switch (self.webType) {
            
        case DDWebTypeYHXY:// 红包袋用户协议
            urlString = [NSString stringWithFormat:@"%@/serviceContract?hidden=1",DDNEWWEBURL];
            break;
            
        case DDWebTypeWLJDFXTS:// 网络借贷风险提示
            urlString = [NSString stringWithFormat:@"%@/wangluojiedai?hidden=1",DDNEWWEBURL];
            break;
            
        case DDWebTypeWLJDJZXXW:// 网络借贷禁止性行为
            urlString = [NSString stringWithFormat:@"%@/jinzhixing?hidden=1",DDNEWWEBURL];
            break;
            
        case DDWebTypeFXGZS:// 风险告知书
            urlString = [NSString stringWithFormat:@"%@/riskStatement?hidden=1",DDNEWWEBURL];
            break;
            
        case DDWebTypePTFWXY:// 平台服务协议
            // 计息方式
            urlString = [NSString stringWithFormat:@"%@/fuwuxieyi?hidden=1",DDNEWWEBURL];
            break;
            
        case DDWebTypeJKHT:// 借款合同
            urlString = [NSString stringWithFormat:@"%@/loanContract?hidden=1",DDNEWWEBURL];
            break;
            
        case DDWebTypeXSZY:// 新手指引
            urlString = [NSString stringWithFormat:@"%@/newerGuide?hidden=1",DDNEWWEBURL];
            break;

        case DDWebTypeYangQi:// 央企背景  /#/newSafety?hidden=1#anchor2
            urlString = [NSString stringWithFormat:@"%@/newSafety?anchor=anchor1&hidden=1",DDNEWWEBURL];
            break;

        case DDWebTypeGongYingLian:// 供应链金融
            urlString = [NSString stringWithFormat:@"%@/newSafety?anchor=anchor2&hidden=1",DDNEWWEBURL];
            break;

        case DDWebTypeAQBZ:// 安全保障
            urlString = [NSString stringWithFormat:@"%@/newSafety?anchor=anchor3&hidden=1",DDNEWWEBURL];
            break;


        case DDWebTypeHOMEAQBZ:

            urlString = [NSString stringWithFormat:@"%@/NewSafety?hidden=1",DDNEWWEBURL];

            break;
            
        case DDWebTypeXSZX:// 新手专享
//            urlString = [NSString stringWithFormat:@"%@",DDWEBURL];
            break;
            
        case DDWebTypeYQHYGZXQ:// 邀请好友规则详情
            urlString = [NSString stringWithFormat:@"%@/m/mPage/wapXiongbb2/wapXiongbb2.html",DDWEBURL];
            break;

        case HHYinSiZC:
            urlString = [NSString stringWithFormat:@"%@/iosSecuity?hidden=1",DDNEWWEBURL];
        default:
            break;
    }
   
    
    //        NSString *path = [[NSBundle mainBundle] pathForResource:protolStr ofType:@"html"];
    //        NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.wkwebView loadRequest:request];
    
}

//自定义返回
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
    
}
- (void)doBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
