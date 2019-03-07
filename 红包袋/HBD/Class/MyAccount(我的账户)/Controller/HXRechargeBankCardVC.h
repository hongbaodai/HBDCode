//
//  HXRechargeBankCardVC.h
//  HBD
//
//  Created by hongbaodai on 2017/10/13.
//

#import "BaseNormolViewController.h"

@interface HXRechargeBankCardVC : BaseNormolViewController
//充值金额
@property (copy, nonatomic) NSString *moneystr;

/** 银行卡信息:图片和限额信息 */
@property (nonatomic, strong) NSDictionary *cardDic;

/** 银行卡信息:快捷银行卡传递来的 */
@property (nonatomic, strong) NSDictionary *cardKJDic;

@end
