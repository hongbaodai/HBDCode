//
//  AppUtils.m
//  textBiaoqianBtn
//
//  Created by 董晓合 on 15/8/31.
//  Copyright (c) 2015年 cuoohe. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

// 颜色转image
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


// 清除个人Default信息
+ (void)clearLoginDefaultCachesAndCookieImgCaches:(BOOL)isClear
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [LLLockPassword saveLockPassword:nil];
    [defaults setObject:@(0) forKey:DDKeyLoginState];
    [defaults setObject:nil forKey:@"username"];
    [defaults setObject:nil forKey:@"phoneNumber"];
    [defaults setObject:nil forKey:@"LoginPassword"];
    [defaults setObject:nil forKey:@"password"];
    [defaults setObject:nil forKey:@"AvlBal"];
    [defaults setObject:nil forKey:@"userId"];
    [defaults setObject:nil forKey:@"_T"];
    [defaults setObject:nil forKey:@"roles"];
    [defaults setObject:nil forKey:@"_U"];
    [defaults setObject:nil forKey:@"khfs"];
    [defaults setObject:nil forKey:@"TS"];
    [defaults setObject:nil forKey:@"QP"];
    [defaults setObject:nil forKey:DDUserVipState];
    [defaults setObject:nil forKey:@"sessionId"];
    [defaults setObject:nil forKey:@"ifRiskEval"];
    [defaults setObject:nil forKey:BXTouchIDEnabe];
    [defaults setObject:nil forKey:@"ACTIVATED"];
    [defaults setObject:nil forKey:@"ISLOCKVC"];
    [defaults setObject:nil forKey:@"lxid"];
    [defaults setObject:nil forKey:@"isTadayDate"];
    
    if (isClear == YES) {
        [AppUtils clearWebAndCookieAndIamgeCaches];
    }
}

// 清除网页/cookie/ 图片缓存
+ (void)clearWebAndCookieAndIamgeCaches
{
    //清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/** Alert弹框（系统的）: 无取消按钮 */
+ (void)alertWithVC:(UIViewController *)vc title:(NSString *)titleStr messageStr:(NSString *)messageStr enSureBlock:(Ensure)ensureBlok
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ensureBlok();
    }];
    
    [alert addAction:action1];
    [vc presentViewController:alert animated:YES completion:nil];
}

/** Alert弹框（系统的）: 带取消按钮 */
+ (void)alertWithVC:(UIViewController *)vc title:(NSString *)titleStr messageStr:(NSString *)messageStr enSureBlock:(Ensure)ensureBlo cancelBlock:(Cancel)cancelBlc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ensureBlo();
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlc();        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [vc presentViewController:alert animated:YES completion:nil];
}

/** Alert弹框（系统的）: 带取消按钮、取消按钮文字、确认按钮文字 */
+ (void)alertWithVC:(UIViewController *)vc title:(NSString *)titleStr messageStr:(NSString *)messageStr enSureStr:(NSString *)sureStr cancelStr:(NSString *)cancelStr enSureBlock:(Ensure)ensureBlo cancelBlock:(Cancel)cancelBlc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ensureBlo();
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlc();
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

/**
 *  创建标签时会调用该方法
 */
+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)text {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize retSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return retSize;
}

// 获取验证码读秒
+ (void)startCodeTimeGetcodeBtn:(UIButton *)getcodeBtn{
    //倒计时时间
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                getcodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [getcodeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                getcodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


/**
 从沙河中取出银行字典
 
 @return 字典--key:银行名  value：简写
 */
+ (NSDictionary *)creatBankDic
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyBanckPlist" ofType:@"plist"];
//    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

/**
 从沙河中取出银行简写字典
 
 @return 字典--key:简写  value：银行名
 */
+ (NSDictionary *)creatBankForShortDic
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyBanckPlistForShort" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dic;
}

/**
 联系客服
 */
+ (void)contactCustomerService
{
    NSString *telUrl = [NSString stringWithFormat:callService];
    
    CGFloat version = [[[UIDevice currentDevice]systemVersion] floatValue];
    if (version >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
    }
}

/** 处理银行卡号：每四位加空格 */
+ (NSString *)makeCardNumWith:(NSString *)str
{
    NSString *strNew = [str substringFromIndex:str.length - 16];
    
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < strNew.length; i++) {
        
        count++;
        doneTitle = [doneTitle  stringByAppendingString:[strNew substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

@end
