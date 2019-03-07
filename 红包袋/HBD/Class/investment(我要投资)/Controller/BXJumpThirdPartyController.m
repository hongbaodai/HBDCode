//
//  BXJumpThirdPartyController.m
//  sinvo
//
//  Created by 李先生 on 15/4/14.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXJumpThirdPartyController.h"
#import "BXPayObject.h"
#import "NJKWebViewProgressView.h"


@interface BXJumpThirdPartyController ()<NSURLConnectionDataDelegate>
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, strong) NSTimer  *timer;

@end

@implementation BXJumpThirdPartyController
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    BOOL _willPush;
    BOOL _authed;
    NSURLRequest *_originRequest;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addRefreshButton];
    [self makeProgressView];
    [self makeWebViewWithTitle:self.payType PayObject:self.info];
    _willPush = YES;
    _authed = NO;
}

//刷新按钮
- (void)addRefreshButton
{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadRequest)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

-(void)reloadRequest
{
    [self.webView stopLoading];
    [self makeWebViewWithTitle:self.payType PayObject:self.info];
    
}

//初始化网页
- (void)makeWebViewWithTitle:(MPPayType )payType PayObject:(BXWebRequesetInfo *)payObject{
    
    self.payType = payType;
    
    NSMutableURLRequest *request = [[BXUIWebRequsetManager defaultManager] requestWithPayType:payType PayObject:payObject];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.webView loadRequest:request];
}

//初始化进度条
- (void)makeProgressView
{
    // 1.webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
    //    webView.delegate = self;
    webView.scrollView.clipsToBounds = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.scalesPageToFit = YES;
    _progressProxy = [[NJKWebViewProgress alloc]init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}



#pragma mark - NSURLconnectionDataDelegate代理方法

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]== 0) {
        _authed = YES;
        
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    _authed = YES;
    //webview 重新加载请求。
    [self.webView loadRequest:_originRequest];
    [connection cancel];
}

/**
 * 查询状态
 */
- (void)queryTradeStatusWithOrdId:(NSString *)ordId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
//    info.serviceString = DDRequestQueryTradeStatus;
    info.serviceString = DDRequestlmQueryTradeStatus;
    if (ordId) {
        info.dataParam = @{@"ordId":ordId};
    } else {
        info.dataParam = @{@"ordId":@""};
    }
    
    
    [[BXNetworkRequest defaultManager] getWithWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSString *status = dict[@"body"][@"trade"][@"JYZT"];
        NSString *message = dict[@"body"][@"trade"][@"HFFHCWXX"];
        NSString *serial_number = dict[@"body"][@"trade"][@"JYJL_ID"];
        
        if ([status isEqualToString:@"WAITING"]) {
            return;
        }else if([status isEqualToString:@"SUCCESS"]){
            [self removeTimer];
            if (_willPush) {
                [self.payDelegate payThirdPartyFinish:YES Message:message Type:self.payType Serial_number:serial_number];
                _willPush = NO;
                
            }
            
        }else if([status isEqualToString:@"FAIL"]){
            [self removeTimer];
            if (_willPush) {
                [self.payDelegate payThirdPartyFinish:NO Message:message Type:self.payType Serial_number:serial_number];
                _willPush = NO;
            }
        }
        
    } faild:^(NSError *error) {
        
    }];
}

#pragma mark - 定时器
-(void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(queryTradeStatus) userInfo:self repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)removeTimer
{
    [self.timer invalidate];
}

- (void)queryTradeStatus
{
    
    if (self.payType == MPPayTypeHKBank) {//海口联合农村商业银行
        [self queryTradeStatusWithOrdId:self.info.requestNo];
    } else {//联动
        [self queryTradeStatusWithOrdId:self.info.order_id];
    }
}

- (void)dealloc {
    
}

#pragma mark - view视图方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    
    if (self.timer) {
        [self removeTimer];
        [self addTimer];
    }else{
        [self addTimer];
    }
    
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    
    if (self.timer) {
        [self removeTimer];
    }
    [_progressView removeFromSuperview];
}


@end
