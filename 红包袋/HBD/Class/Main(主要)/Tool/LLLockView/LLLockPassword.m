//
//  LLLockPassword.m
//  LockSample
//
//  Created by Lugede on 14/11/12.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockPassword.h"
#import "AppUtils.h"

@implementation LLLockPassword

#pragma mark - 锁屏密码读写
+ (NSString*)loadLockPassword
{
    //    BXAccount *account = [BXAccountTool account];
    //    NSString* pswd = account.lock;
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* pswd = [ud  objectForKey:@"lock"];
    //    LLLog(@"pswd = %@", pswd);
    if (pswd != nil &&
        ![pswd isEqualToString:@""] &&
        ![pswd isEqualToString:@"(null)"]) {
        
        return pswd;
    }
    
    return nil;
}

+ (void)saveLockPassword:(NSString*)pswd
{
    //    NSDictionary *PasswordDict = @{@"lock" : pswd};
    //    BXAccount *account = [BXAccount accountWithDicht:PasswordDict];
    //    // 3.2保存模型对象
    //    [BXAccountTool saveAccount:account];
    
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
    //    NSDictionary *PasswordDict = @{@"AlreadyAsk" : @"YES"};
    //    BXAccount *account = [BXAccount accountWithDicht:PasswordDict];
    //    // 3.2保存模型对象
    //    [BXAccountTool saveAccount:account];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"AlreadyAsk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 退出登录状态
+ (void)setLogoutState{
    // 清除缓存
    [AppUtils clearLoginDefaultCachesAndCookieImgCaches:YES];
}


@end
