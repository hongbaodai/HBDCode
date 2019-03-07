//
//  AlertThreeViewController.h
//  HBD
//
//  Created by hongbaodai on 2018/3/29.
//
// 提现、一锤定音、唯我独尊弹框

#import <UIKit/UIKit.h>

typedef void(^LeftBtnBlock)(void);
typedef void(^RightBtnBlock)(void);
typedef void(^CloseBtnBlock)(void);

@interface AlertThreeViewController : UIViewController

// 左按钮回调
@property (nonatomic, copy) LeftBtnBlock leftBtnBlock;
// 右按钮回调
@property (nonatomic, copy) RightBtnBlock rightBtnBlock;
// 叉号回调
@property (nonatomic, copy) CloseBtnBlock closeBtnBlock;

/**
 创建AlertThreeViewController

 @param texStr 显示的文字
 @param imgStr 显示的背景图片
 @return AlertThreeViewController
 */
+ (instancetype)createAlertThreeViewControllerWithTextStr:(NSString *)texStr imgStr:(NSString *)imgStr;

- (void)closeVC;

@end
