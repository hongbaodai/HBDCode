//
//  UIViewController+DefaultViewController.m
//  iFengAdvertisement
//
//  Created by szjx on 14-8-20.
//  Copyright (c) 2014年 szjx. All rights reserved.
//

#import "UIViewController+DefaultViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation UIViewController (DefaultViewController)

#pragma 初始化导航控制器标题
- (void)initNavigationController:(NSString *)title backgroundColor:(UIColor *)backgroundColor
{
    // 设置标题名称
    self.navigationItem.title = title;
    // 设置标题文字属性
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]};
    // 设置背景色
    self.view.backgroundColor = backgroundColor;
}

#pragma 返回按钮
- (UIBarButtonItem *)backBarButtonItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 22, 44);
    [backButton setImage:[UIImage imageNamed:NAV_BACK_BLACK_IMG] forState:UIControlStateNormal];
    backButton.adjustsImageWhenHighlighted = YES;
    [backButton addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return leftBarButtonItem;
}

#pragma 自定义返回按钮
- (void)initNavigationLeftBarButtonItem
{
    [self.navigationItem setLeftBarButtonItem:[self backBarButtonItem]];
}

#pragma 返回按钮点击事件处理
- (void) leftBarButtonItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

// push 到子页面，且子页面可使用侧滑返回
- (void)pushWithPopGestureRecognizerViewController:(UIViewController *)controller animated:(BOOL)animated
{
//    // push前 隐藏页面底部导航栏
//    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        // IOS7 滑动返回
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma 初始化加载视图,不显示
- (MBProgressHUD *)progressHUDinit:(NSString *)startText withShowState:(ShowProgressHUDstate)showState
{
    // 无网络连接
    MBProgressHUD *hud;
    if (showState == ShowProgressHUDSelfScreen)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        // 将加载框添加到当前View视图上
        [self.view addSubview:hud];
    }
    else
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        hud = [[MBProgressHUD alloc] initWithView:appDelegate.window];
        // 将加载框添加到当前View视图上
        [appDelegate.window addSubview:hud];
    }
    
    // 设置加载框模式
    hud.mode = MBProgressHUDModeIndeterminate;
    // 设置代理
    hud.removeFromSuperViewOnHide = YES;
    // 设置开始加载文字
    hud.labelText = startText;
    return hud;
}

#pragma 加载开始
- (void)progressHUDstart:(MBProgressHUD *)hud
{
    // 显示加载框
    [hud show:YES];
}

#pragma 加载完成
- (void)progressHUDFinish:(MBProgressHUD *)hud
{
    [hud hide:YES];
}

#pragma 加载成功
- (void)progressHUD:(MBProgressHUD *)hud successText:(NSString *)successText
{
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAV_BACK_BLACK_IMG]];
    hud.labelText = successText;
}

/** 设置状态栏白色 */
- (void) setStatusBarStyleWhite
{
    // 状态栏颜色设置
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

/** 设置状态栏黑色 */
- (void) setStatusBarStyleBlack
{
    // 状态栏颜色设置
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/** 添加无数据蒙版view */
- (void)setupEmptyViewlabel:(NSString *)text AndImageName:(NSString *)imgName
{
    UIImageView *view = (UIImageView *)[self.view viewWithTag:100];
    if(view)return;
    
    UIImage *empty = [UIImage imageNamed:imgName];
    UIImageView *iview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, empty.size.width, empty.size.height)];
    iview.image = empty;
    iview.tag = 100;
    iview.center = CGPointMake(self.view.center.x, self.view.center.y - 120);
    [self.view addSubview:iview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iview.frame) + 5, SCREEN_WIDTH, 20)];
    label.tag  = 101;
    label.text = text;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
}
- (void)setupEmptyView
{
//    [self setupEmptyViewlabel:@"暂无内容"];
    [self setupEmptyViewlabel:@"暂无内容" AndImageName:nil];
}

- (void)removeEmptyView
{
    UIImageView *view = (UIImageView *)[self.view viewWithTag:100];
    [view removeFromSuperview];
    view = nil;
    
    UILabel *label = (UILabel *)[self.view viewWithTag:101];
    [label removeFromSuperview];
    label = nil;
    
}


@end
