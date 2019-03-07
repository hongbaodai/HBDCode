//
//  BXDebentureControllerNew.h
//  HBD
//
//  Created by hongbaodai on 2018/1/26.
//

#import <UIKit/UIKit.h>
#import "HXBaseCustomTableVC.h"

@interface BXDebentureControllerNew : HXBaseCustomTableVC

/** 是否删除vip管理这一行 yes：是 */
@property (nonatomic, assign) BOOL isDelete;

/** 银行卡管理 */
@property (nonatomic, copy)NSString *kSFMRTX;

@property (nonatomic, strong) NSDictionary *currDict;

@end
