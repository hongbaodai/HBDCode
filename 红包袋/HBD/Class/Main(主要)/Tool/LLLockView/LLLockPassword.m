//
//  LLLockPassword.m
//  LockSample
//
//  Created by Lugede on 14/11/12.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockPassword.h"

@implementation LLLockPassword

#pragma mark - 锁屏密码读写
+ (NSString*)loadLockPassword
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* pswd = [ud  objectForKey:@"lock"];
    if (pswd != nil && ![pswd isEqualToString:@""] && ![pswd isEqualToString:@"(null)"]) {
        return pswd;
    }
    
    return nil;
}

+ (void)saveLockPassword:(NSString*)pswd
{
    
    [[NSUserDefaults standardUserDefaults] setObject:pswd forKey:@"lock"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 是否需要提示输入密码
+ (BOOL)isAlreadyAskedCreateLockPassword
{
    //    BXAccount *account = [BXAccountTool account];
    //    NSString* pswd = account.AlreadyAsk;
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* pswd = [ud objectForKey:@"AlreadyAsk"];

    if (pswd != nil && [pswd isEqualToString:@"YES"]) {
        
        return NO;
    }
    
    return YES;
}

// 需要提示过输入密码了
+ (void)setAlreadyAskedCreateLockPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"AlreadyAsk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 退出登录状态
+ (void)setLogoutState{
    // 清除缓存
    [AppUtils clearLoginDefaultCachesAndCookieImgCaches:YES];
}


@end
