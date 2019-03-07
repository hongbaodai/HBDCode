//
//  HXAlertAccount.h
//  HBD
//
//  Created by hongbaodai on 2017/12/13.
//  首页弹框专用类

#import <Foundation/Foundation.h>

@interface HXAlertAccount : NSObject


//// 上一个登录的人
//@property (nonatomic, copy) NSString *user;
//// 上一个登录的人
//@property (nonatomic, copy) NSString *oldUser;
// 首页弹框五天轮一次
@property (nonatomic, copy) NSString *numStr;
// 首页弹框是否显示过
@property (nonatomic, assign) BOOL show;
// 弹框的时间
@property (nonatomic, copy) NSString *showTime;

// 单例
singletonInterface(HXAlertAccount);

/** 归档 */
- (void)encodeAlertAccout;

/** 解档 */
- (instancetype)coderAlertAccout;

/** 获取当前控制器 */
+ (UIViewController *)getCurrentVC;

@end
