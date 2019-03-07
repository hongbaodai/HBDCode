//
//  BXMyAccountInvestmentModel.h
//  sinvo
//
//  Created by 李先生 on 15/4/21.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  筹款中

#import <Foundation/Foundation.h>

@interface BXMyAccountInvestmentModel : NSObject


// 借款标题
@property (nonatomic, copy)NSString *JKBT;
// 借款人
@property (nonatomic, copy)NSString *JRZNC;

// 投标时间
@property (nonatomic, copy)NSString *TBSJ;

// 年化利率
@property (nonatomic, copy)NSString *NHLL;

// 出借金额
@property (nonatomic, copy)NSString *JCJE;

// 逾期利息
@property (nonatomic, copy)NSString *JYHSLX;


// 借款周期数字
@property (nonatomic, copy)NSString *HKZQSL;

// 已还期数
@property (nonatomic, copy)NSString *SYHKQS;

// 借款周期单位(月或天)
@property (nonatomic, copy)NSString *HKZQDW;

// 进度标签
//@property (nonatomic, copy)NSString *InvestmentProgressLab;
// 进度环
//@property (nonatomic, copy)NSString *schedule;

@property (nonatomic, copy)NSString *B_ID;

// 已投金额
@property (nonatomic, copy)NSString *MQYTBJE;
// 总金额
@property (nonatomic, copy)NSString *ZE;
// 还款方式 1:按月付息到期还本 2：到期还本付息 3：等额回款
@property (nonatomic, copy)NSString *HKFS;

// 加息劵
@property (nonatomic, copy)NSString *JXQ_ID;

// 加息劵
@property (nonatomic, copy)NSString *JXLL;

@end



