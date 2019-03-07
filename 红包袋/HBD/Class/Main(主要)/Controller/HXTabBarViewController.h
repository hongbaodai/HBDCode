//
//  HXTabBarViewController.h
//  HBD
//
//  Created by hongbaodai on 2017/10/30.
//

#import <UIKit/UIKit.h>

@interface HXTabBarViewController : UITabBarController
/** 0：没登录  1：已经登录的 */
@property (nonatomic, assign)int bussinessKind;

/** 更新下登录回来的数据 */
- (void)reloadSelecThres;

/** 修改登录密码回来重新修改ui还有出借详情页纯文字弹框 */
- (void)reloadSelecAndAlert;

- (void)reloadHomeVC;

/** 设置选择位置 */
- (void)loginStatusWithNumber:(int)Number;

@end
