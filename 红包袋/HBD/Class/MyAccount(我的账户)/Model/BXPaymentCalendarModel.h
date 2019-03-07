//
//  BXPaymentCalendarModel.h
//  
//
//  Created by echo on 16/2/26.
//
//  回款日历的元素模型

#import <Foundation/Foundation.h>

@interface BXPaymentCalendarModel : NSObject

// 回款日期
@property (nonatomic, copy) NSString *HKRQ;
// 未回数目
@property (nonatomic, copy) NSString *WHSM;
// 已回数目
@property (nonatomic, copy) NSString *YSSM;
// 逾期数目
@property (nonatomic, copy) NSString *YQSM;

@end
