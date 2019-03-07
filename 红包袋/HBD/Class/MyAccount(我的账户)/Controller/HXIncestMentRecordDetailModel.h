//
//  HXIncestMentRecordDetailModel.h
//  HBD
//
//  Created by hongbaodai on 2017/11/3.
//

#import <Foundation/Foundation.h>

@interface HXIncestMentRecordDetailModel : NSObject

// 预期年化利率
@property (nonatomic, copy) NSString *annualRate;
// 净收益
@property (nonatomic, copy) NSString *netEarning;
// 出借金额
@property (nonatomic, copy) NSString *investAmount;
// 出借时间
@property (nonatomic, copy) NSString *investDate;
// 回款总额(本金+利息)
@property (nonatomic, copy) NSString *totalAmount;
// 到期时间
@property (nonatomic, copy) NSString *endDate;
// 使用的红包金额
@property (nonatomic, copy) NSString *investCoupon;
// 还款进度
@property (nonatomic, copy) NSString *repaymentProcess;
// 累计获得利息
@property (nonatomic, copy) NSString *curEarning;
// 下期待收金额
@property (nonatomic, copy) NSString *nextTotalAmount;
// 下期还款时间
@property (nonatomic, copy) NSString *nextRepayDate;

@end
