//
//  MBProgressHUD+NJ.h
//
//  Created by 李南江 on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (NJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
/*****帧动画*****/
+ (MBProgressHUD *)showCustomAnimate:(NSString *)title imageStr:(NSString *)imageStr imageNum:(NSInteger)imageNum view:(UIView *)view;
/** 消失方法：帧动画 */
+ (void)hideHUDCustomWithView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message delayTime:(NSTimeInterval)delay;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
@end
