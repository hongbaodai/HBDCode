//
//  LLLockViewController.h
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//
//
//  解锁控件头文件，使用时包含它即可

#define LLLockRetryTimes 5 // 最多重试几次
#define LLLockAnimationOn  // 开启窗口动画，注释此行即可关闭

#import <UIKit/UIKit.h>
#import "LLLockView.h"
#import "LLLockPassword.h"
#import "LLLockConfig.h"

// 进入此界面时的不同目的
typedef enum {
    LLLockViewTypeCheck,  // 检查手势密码
    LLLockViewTypeCreate, // 创建手势密码
    LLLockViewTypeModify, // 修改
    LLLockViewTypeClean,  // 清除
    LLLockViewTypeNext,   // 跳过(下次设置)
    LLLockViewTypeForgetPwd, // 忘记密码
    
}LLLockViewType;

@protocol LLLockGesTureDelegate <NSObject>
@optional
-(void)gestureVCPopVCWithType:(NSString *)type;

@end

@interface LLLockViewController : UIViewController <LLLockDelegate>

@property (nonatomic) LLLockViewType nLockViewType; // 此窗口的类型
@property (nonatomic,assign) BOOL isPresentedWithMyAccount;

- (id)initWithType:(LLLockViewType)type; // 直接指定方式打开

// 修改手势密码判断
@property (nonatomic,assign) BOOL isHidenButton;

// 判断是否从修改手势密码那进入
@property (nonatomic, assign) BOOL isFromChangePwd;
// 判断是否是从后台到前台的check类型
@property (nonatomic, assign) BOOL isFromForeground;

@property (nonatomic, weak) id<LLLockGesTureDelegate> GestureDelegate;

- (void)hide;
@end
