//
//  AppDelegate.h
//  Created by 李先生 on 14/12/29.
//  Copyright (c) 2014年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLLockViewController.h"
#import "DDCoverView.h"

// 友盟分享
#define UM_APPKEY_NEW               @"5983e340c895762fe8001de4"
#define DDKeyLoginState             @"DDKeyLoginState"
#define DDUserVipState              @"DDUserVipState"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

// 手势解锁相关
@property (strong, nonatomic) LLLockViewController* lockVc; // 添加解锁界面
- (void)showLLLockViewController:(LLLockViewType)type isPresentedWithMyAccount:(BOOL)isPresentedWithMyAccount;

@end

