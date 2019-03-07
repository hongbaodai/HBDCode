//
//  MBProgressHUD+NJ.m
//
//  Created by 李南江 on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD+NJ.h"

@implementation MBProgressHUD (NJ)

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message delayTime:(NSTimeInterval)delay
{
    return [self showMessage:message toView:nil delayTime:delay];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)hideHUDCustomWithView:(UIView *)view
{
    MBProgressHUD *hod = [self HUDForView:view];
    [hod hide:YES];
}

#pragma mark toView
+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.detailsLabelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (MBProgressHUD *)showCustomAnimate:(NSString *)title imageStr:(NSString *)imageStr imageNum:(NSInteger)imageNum view:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (view == nil) view = window;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = YES;

    hud.detailsLabelText = title;
    // 模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",imageStr]];
    UIImageView *animateGifView = [[UIImageView alloc]initWithImage:image];

    NSMutableArray *gifArray = [NSMutableArray array];
    for (int i = 1; i <= imageNum; i ++) {
        UIImage *images = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd", imageStr, i]];
        [gifArray addObject:images];
    }
    
    [animateGifView setAnimationImages:gifArray];
    [animateGifView setAnimationDuration:0.5];
    [animateGifView setAnimationRepeatCount:0];
    [animateGifView startAnimating];
    
    hud.customView = animateGifView;
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view delayTime:(NSTimeInterval)delay
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    
    // 延时
    [hud hide:YES afterDelay:delay];
    return hud;
}

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;

    [hud hide:YES afterDelay:1.5];
}





@end
