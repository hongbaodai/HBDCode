//
//  HXBankCardManagerVC.h
//  HBD
//
//  Created by hongbaodai on 2017/10/10.
//

#import <UIKit/UIKit.h>
#import "BaseNormolViewController.h"

typedef void (^CardStatus)(NSString *);

@interface HXBankCardManagerVC : BaseNormolViewController

@property (nonatomic, copy) CardStatus cardBlock;

// 银行卡信息
@property (nonatomic, weak)NSDictionary *infoDict;
/** 创建控制器 */
+ (instancetype)creatVCFromSB;

@end
