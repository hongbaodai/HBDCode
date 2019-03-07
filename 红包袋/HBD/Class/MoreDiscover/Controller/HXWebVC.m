//
//  HXWebVC.m
//  test
//
//  Created by hongbaodai on 2017/9/22.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXWebVC.h"
#import <WebKit/WebKit.h>

@interface HXWebVC ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *wkWebView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HXWebVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebview];
    [self addProgress];
    [self loadData];
}

// 添加进度条
- (void)addProgress
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
}

// 添加WKWebview
- (void)addWebview
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.preferences.minimumFontSize = 18;

    CGRect frame = self.view.frame;
    frame.size.height -= 64;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
    self.wkWebView = webView;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:webView];
  
}

- (void)loadData
{
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    if (self.urlStr.length > 0) {
        NSURL *baseURL = [NSURL URLWithString:self.urlStr];
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:baseURL]];
    } else {
        [self.wkWebView loadHTMLString:_htmlStr baseURL:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

- (void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
