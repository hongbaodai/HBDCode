//
//  BXLoginViewController.h
//  sinvo
//
//  Created by 李先生 on 15/3/27.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  登录界面

#import <UIKit/UIKit.h>
#import "DDLoginSuperVC.h"

typedef NS_ENUM(NSUInteger, DDLoginStyle) {
    DDLoginStyleDefaut,                     // 默认弹出
    DDLoginStyleChangePwd,                  // 修改密码弹出
    DDLoginStyleDec,                    // 12月活动弹出
};

@protocol LoginVCDelegate <NSObject>
@optional
-(void)refreshVCType:(BOOL)refresh;

@end

@interface BXLoginViewController : DDLoginSuperVC

@property (nonatomic, assign) DDLoginStyle loginStyle;

@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
// 判断是否有返回按钮
//@property (nonatomic, assign)BOOL haveBackBar;
// 判断是否从我的账户弹出
@property (nonatomic, assign)BOOL isPresentedWithMyAccount;
// 判断是否是从手势页面弹出的登陆
@property (nonatomic, assign)BOOL isPresentedWithLockVC;
//判断是否跳转邀请好友页面
@property (nonatomic, assign) BOOL isShowFriendVC;

@property (nonatomic, weak) id<LoginVCDelegate> LoginDelegate;

@end
