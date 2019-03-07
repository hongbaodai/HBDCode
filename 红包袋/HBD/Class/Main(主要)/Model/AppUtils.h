//
//  AppUtils.h
//  textBiaoqianBtn
//
//  Created by 董晓合 on 15/8/31.
//  Copyright (c) 2015年 cuoohe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Ensure) (void);
typedef void (^Cancel) (void);

@interface AppUtils : NSObject<UIAlertViewDelegate>

/** Alert弹框：确认按钮回调
 */
@property(nonatomic, copy) Ensure ensureBlock;

/** Alert弹框：取消按钮回调
 */
@property(nonatomic, copy) Cancel cancelBlock;



/**
    颜色转image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
     清除个人Default信息
 */
+ (void)clearLoginDefaultCachesAndCookieImgCaches:(BOOL)isClear;

/**
    清除网页/cookie/ 图片缓存
 */
+ (void)clearWebAndCookieAndIamgeCaches;

/**
 Alert弹框（系统的）: 无取消按钮
 
 @param vc 推出的控制器
 @param titleStr title
 @param messageStr message
 @param ensureBlo 确认按钮回调
 @param cancelBlc 取消按钮回调
 */
+ (void)alertWithVC:(UIViewController *)vc title:(NSString *)titleStr messageStr:(NSString *)messageStr enSureBlock:(Ensure)ensureBlok;

/**
 Alert弹框（系统的）: 带取消按钮

 @param vc 推出的控制器
 @param titleStr title
 @param messageStr message
 @param ensureBlo 确认按钮回调
 @param cancelBlc 取消按钮回调
 */
+ (void)alertWithVC:(UIViewController *)vc title:(NSString *)titleStr messageStr:(NSString *)messageStr enSureBlock:(Ensure)ensureBlo cancelBlock:(Cancel)cancelBlc;

/**
 Alert弹框（系统的）: 带取消按钮、取消按钮文字、确认按钮文字

 @param vc 控制器
 @param titleStr title
 @param messageStr message
 @param sureStr 确认按钮文字
 @param cancelStr 取消按钮文字
 @param ensureBlo 确认按钮回调
 @param cancelBlc 取消按钮回调
 */
+ (void)alertWithVC:(UIViewController *)vc title:(NSString *)titleStr messageStr:(NSString *)messageStr enSureStr:(NSString *)sureStr cancelStr:(NSString *)cancelStr enSureBlock:(Ensure)ensureBlo cancelBlock:(Cancel)cancelBlc;

/**
 *  创建标签时会调用该方法
 */
+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)text;

/**
    获取验证码读秒
 */
+ (void)startCodeTimeGetcodeBtn:(UIButton *)getcodeBtn;

/**
 从沙河中取出银行字典

 @return 字典--key:银行名  value：简写
 */
+ (NSDictionary *)creatBankDic;

/**
 从沙河中取出银行简写字典
 
 @return 字典--key:简写  value：银行名
 */
+ (NSDictionary *)creatBankForShortDic;

/**
 联系客服
 */
+ (void)contactCustomerService;

/**
 处理银行卡号：每四位加空格

 @param str 需处理银行卡号
 @return 处理好的四位密文加空格
 */
+ (NSString *)makeCardNumWith:(NSString *)str;

@end
