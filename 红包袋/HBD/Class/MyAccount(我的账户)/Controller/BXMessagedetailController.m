//
//  BXMessagedetailController.m
//
//
//  Created by echo on 16/2/29.
//
//

#import "BXMessagedetailController.h"

@interface BXMessagedetailController ()

@property (nonatomic, strong) UIWebView  *webView;

@end

@implementation BXMessagedetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addWebView];
    [self loadData];
}

- (void)addWebView
{
    CGFloat top = 0;
    if ([self.type isEqual:@"0"]) {
        top = 51;
    }
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, top, SCREEN_SIZE.width - 0, SCREEN_SIZE.height - 51 - 64)];
    webview.backgroundColor = [UIColor whiteColor];
    
    for (UIView *_aView in [webview subviews]) {
        if ([_aView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews) {
                if ([_inScrollview isKindOfClass:[UIImageView class]]) {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    
    self.webView = webview;
    //        webview.scalesPageToFit = YES;
    [self.view addSubview:webview];
}

- (void)loadData
{
    if ([self.type isEqual:@"0"]) {
        self.title = @"公告详情";
        [MBProgressHUD showMessage:nil delayTime:5.0];
        [self postIndustryDetailWithId:self.parameterId];
    } else {
        self.title = @"信息详情";

        [MBProgressHUD showMessage:nil delayTime:5.0];
        [self postGetInnerMailByIdWithReadId:self.parameterId];
    }
}

/** 获取公告详情 */
- (void)postIndustryDetailWithId:(NSString *)ID
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestIndustryDetail;
    info.dataParam = @{@"id":ID};
    
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
     
        self.titleLab.text = dict[@"body"][@"pageData"][0][@"BT"];
        NSString *str = dict[@"body"][@"pageData"][0][@"NR"];

        [self.webView loadHTMLString:str baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        [MBProgressHUD hideHUD];
    } faild:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
    }];
}

/** 获取个人消息详情 */
- (void)postGetInnerMailByIdWithReadId:(NSString *)readId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestGetInnerMailById;
    info.dataParam = @{@"readId":readId};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
     
        [self.webView loadHTMLString:dict[@"body"][@"NR"] baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        [MBProgressHUD hideHUD];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

/** 创建控制器 **/
+ (instancetype)creatVCFromStroyboard
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BXMessagedetailController" bundle:nil];
    BXMessagedetailController *detailVC = [sb instantiateInitialViewController];
    return detailVC;
}

@end
