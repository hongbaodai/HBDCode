//
//  HXPopUpViewController.h
//  HBD
//
//  Created by hongbaodai on 2017/12/28.
// 银行存管弹框：图文+ 按钮

#import <UIKit/UIKit.h>

typedef void(^LittleButBlock)(void);

@interface HXPopUpViewController : UIViewController

@property (nonatomic, copy) LittleButBlock littlButBlock;

/**
 创建弹框MYPopupView：没有银行存管按钮
 
 @param titleStr 文字描述
 @param sureButton 确定按钮文字描述
 @param imageStr 显示图片样式
 @param isHidden 银行按钮：银行存管
 @param sureBlock 确定按钮点击事件
 @param deleteBlock 叉号按钮点击事件
 @return MYPopupView
 */
/** 创建弹框MYPopupView */
+ (instancetype)popUpVCInitWithTitle:(NSString *)titleStr sureButton:(NSString *)sureButton imageStr:(NSString *)imageStr isHidden:(BOOL)isHidden sureBlock:(void(^)(void))sureBlock deletBlock:(void (^)(void))deleteBlock;

@end
