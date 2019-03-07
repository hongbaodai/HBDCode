//
//  BXPaymentModel.h
//  
//
//  Created by echo on 16/2/25.
//
//

#import <Foundation/Foundation.h>

@interface BXPaymentModel : NSObject

// 本期本息
@property (nonatomic, copy) NSString *amount;
// 回款进度
@property (nonatomic, copy) NSString *hkjd;
// 电话
@property (nonatomic, copy) NSString *mobile;
// 年化利率
@property (nonatomic, copy) NSString *nh;
// 标题
@property (nonatomic, copy) NSString *title;
// 交易时间
@property (nonatomic, copy) NSString *tradeTime;
// 出借金额
@property (nonatomic, copy) NSString *tzje;
// 状态（0：未回，1：已回，0&&tradeTime在今天之前，逾期）
@property (nonatomic, copy) NSString *zt;

// 加息劵
@property (nonatomic, copy) NSString *JXQ_ID;

// 出借记录加息
@property (nonatomic, copy) NSString *JXLL;

@end
