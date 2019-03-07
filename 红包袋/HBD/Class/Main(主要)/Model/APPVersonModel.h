//
//  APPVersonModel.h
//  HBD
//
//  Created by hongbaodai on 2017/8/11.
//

#import <Foundation/Foundation.h>

typedef enum {
    MoneyPartOneStep,  // 一锤定音
    MoneyPartOnlyMe,   // 唯我独尊
    MoneyPartMore      // 出借确认弹框
}MoneyPart;

typedef void(^ClosebtnBlock)(void);


@interface APPVersonModel : NSObject

@property (nonatomic, assign) MoneyPart moneyPart;

// 叉号回调
@property (nonatomic, copy) ClosebtnBlock closebtnBlock;

/**
 app版本进行更新
 */

- (void)APPVersionInfor;
/**
 跳转到银行存管页面

 @param vc 控制器
 */
+ (void)pushBankDepositoryWithVC:(UIViewController *)vc urlStr:(NSString *)urlStr;


/**
 首页五天一轮弹框

 @param vc 控制器
 */
+ (void)showHomeAlertEveryDayWithVC:(UIViewController *)vc;



/**
 用于出借确认弹框、唯我独尊弹框、一锤定音弹框

 @param vc 控制器
 @param moneyPart 分类
 @param leftBlock 左按钮回调
 @param rightBlock 右按钮回调
 */
+ (void)showAlertViewThreeWith:(MoneyPart)moneyPart textStr:(NSString *)texStr left:(void(^)(void))leftBlock right:(void(^)(void))rightBlock;

@end
