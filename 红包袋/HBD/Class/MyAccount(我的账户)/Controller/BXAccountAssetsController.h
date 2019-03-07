//
//  BXAccountAssetsController.h
//  sinvo
//  账户资产

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface BXAccountAssetsController : BaseTableViewController

/** 个人账户钱的情况 */
@property (nonatomic, strong) NSDictionary *AccountDetaildict;

/** 创建控制器 **/
+ (instancetype)creatVCFromStroyboard;

@end
