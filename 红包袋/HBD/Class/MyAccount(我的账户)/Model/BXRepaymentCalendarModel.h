//
//  BXRepaymentCalendarModel.h
//  
//
//  Created by echo on 16/2/26.
//
//  还款日历的元素模型

#import <Foundation/Foundation.h>

@interface BXRepaymentCalendarModel : NSObject

// 还款日期
@property (nonatomic, copy) NSString *HKRQ;
// 未还数目
@property (nonatomic, copy) NSString *WHSM;
// 已还数目
@property (nonatomic, copy) NSString *YHSM;
// 逾期数目
@property (nonatomic, copy) NSString *YQSM;

@end
