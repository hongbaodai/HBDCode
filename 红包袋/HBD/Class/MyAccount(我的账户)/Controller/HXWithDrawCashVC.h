//
//  HXWithDrawCashVC.h
//  HBD
//
//  Created by hongbaodai on 2017/10/13.
//

#import "BaseNormolViewController.h"

@interface HXWithDrawCashVC : BaseNormolViewController

/** 用户绑卡信息 */
@property (nonatomic, strong) NSDictionary *bankCardDict;

/** 可提现的金额 */
@property (nonatomic, strong) NSString *drawlCanshStr;

/**
 创建HXWithDrawCashVC

 @return HXWithDrawCashVC
 */
+ (instancetype)creatVCFromStroyboard;

@end
