//
//  BXNavigationController.m
//  222
//
//  Created by 李先生 on 15/3/25.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXNavigationController.h"
#import "DDActivityWebController.h"

@interface BXNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BXNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *backgroundImage = [AppUtils imageWithColor:kColor_Red_Main];
    [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    // 去黑线
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                               NSFontAttributeName : [UIFont systemFontOfSize:17]};

    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.interactivePopGestureRecognizer.enabled = YES;
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >= 1) {
        // 左上角的返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];

        backButton.mj_size = CGSizeMake(60, 44);
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"fanhuianniu"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"fanhuianniu"] forState:UIControlStateHighlighted];
        // 让按钮内部的所有内容左对齐
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];



    }
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
    viewController.navigationController.interactivePopGestureRecognizer.enabled = YES ;
}



- (void)back:(UIButton *)but
{
    if ([self.topViewController isMemberOfClass:[DDActivityWebController class]]) {
        DDActivityWebController *webvc = (DDActivityWebController *)self.topViewController;
        if ([webvc.webView canGoBack]) {
            [webvc.webView goBack];
            return;
        }

        [self popViewControllerAnimated:YES];

    } else {
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark- 左滑手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}


@end

