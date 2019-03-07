//
//  AlertImgViewController.h
//  HBD
//
//  Created by hongbaodai on 2017/12/29.
// 纯图片弹框：浮框五个轮弹

#import <UIKit/UIKit.h>

@interface AlertImgViewController : UIViewController

/**
 创建AlertImgViewController
 
 @param imageStr 显示的图片名
 @param button的颜色
 @param moreBlock 点击事件
 @return ImageAertView
 */
+ (instancetype)alertImgViewControllerWithImageStr:(NSString *)imageStr butColor:(UIColor *)butColor moreBlock:(void(^)(void))moreBlock;


@end
