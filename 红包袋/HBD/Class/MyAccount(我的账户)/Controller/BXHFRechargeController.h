//
//  BXHFRechargeController.h
//  
//
//  Created by echo on 16/3/29.
//
//  充值

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface BXHFRechargeController : BaseTableViewController

/** 可提现的金额 */
@property (nonatomic, strong) NSString *drawlCanshStr;

/**
 创建BXHFRechargeController
 
 @return BXHFRechargeController
 */
+ (instancetype)creatVCFromStroyboard;

@end

