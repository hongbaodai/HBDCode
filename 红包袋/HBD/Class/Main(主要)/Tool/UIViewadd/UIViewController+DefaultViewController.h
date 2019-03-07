//
//  UIViewController+DefaultViewController.h
//  iFengAdvertisement
//
//  Created by szjx on 14-8-20.
//  Copyright (c) 2014年 szjx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

typedef NS_ENUM(NSInteger, ShowProgressHUDstate) {
    ShowProgressHUDFullScreen,    // 全屏
    ShowProgressHUDSelfScreen,    // 当前view
};

@interface UIViewController (DefaultViewController)

/** 初始化导航控制器标题属性 */
- (void) initNavigationController:(NSString *) title backgroundColor:(UIColor *) backgroundColor;

/** 自定义返回按钮 */
- (void) initNavigationLeftBarButtonItem;

/** 得到返回按钮 */
- (UIBarButtonItem *) backBarButtonItem;

/** push指定UIViewController，IOS7以上启动侧滑返回 */
- (void) pushWithPopGestureRecognizerViewController:(UIViewController *) controller animated:(BOOL) animated;

/** 初始化加载视图,不显示 */
- (MBProgressHUD *)progressHUDinit:(NSString *)startText withShowState:(ShowProgressHUDstate)showState;

/** 开始显示加载框 */
- (void)progressHUDstart:(MBProgressHUD *)hud;

/** 加载框显示成功 */
- (void) progressHUD:(MBProgressHUD *) hud successText:(NSString *) successText;

/** 加载框加载完成 */
- (void) progressHUDFinish:(MBProgressHUD *) hud;

/** 设置状态栏白色 */
- (void) setStatusBarStyleWhite;

/** 设置状态栏黑色 */
- (void) setStatusBarStyleBlack;

/** 添加无数据蒙版view */
- (void)setupEmptyViewlabel:(NSString *)text AndImageName:(NSString *)imgName;
- (void)removeEmptyView;

@end
