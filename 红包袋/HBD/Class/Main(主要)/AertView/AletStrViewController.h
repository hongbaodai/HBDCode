//
//  AletStrViewController.h
//  HBD
//
//  Created by hongbaodai on 2017/12/28.
// 纯文字-弹框

#import <UIKit/UIKit.h>

@interface AletStrViewController : UIViewController


/**
 创建AletStrViewController（默认 确认按钮文字：我知道了）

 @param attrStr NSAttributedString
 @param sureBlock sureBlock
 @return TextAerltView
 */
+ (instancetype)creatAlertVCWithAttributedString:(NSAttributedString *)attrStr sureBlock:(void(^)(void))surevcBlock;

/**
 创建AletStrViewController

 @param attrStr NSAttributedString
 @param sureStr 确认按钮文字
 @param sureBlock sureBlock
 @return TextAerltView
 */
+ (instancetype)creatAlertVCWithAttributedString:(NSAttributedString *)attrStr sureStr:(NSString *)sureStr sureBlock:(void(^)(void))surevcBlock;


/**
 创建AletStrViewController
 
 @param str NSString
 @param sureBlock sureBlock
 @return TextAerltView
 */
+ (instancetype)creatAlertStrWithStr:(NSString *)str sureBlock:(void(^)(void))surevcBlock;


@end
