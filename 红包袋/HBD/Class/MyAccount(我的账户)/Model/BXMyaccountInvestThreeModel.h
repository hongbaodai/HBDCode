//
//  BXMyaccountInvestThreeModel.h
//  sinvo
//
//  Created by 李先生 on 15/4/22.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  回款中

#import <Foundation/Foundation.h>

@interface BXMyaccountInvestThreeModel : NSObject

// 借款标题
@property (nonatomic, copy)NSString *JKBT;
// 借款人
@property (nonatomic, copy)NSString *JRZNC;

// 年化利率
@property (nonatomic, copy)NSString *NHLL;

// 借款周期数字
@property (nonatomic, copy)NSString *HKZQSL;

// 借款周期单位(月或天)
@property (nonatomic, copy)NSString *HKZQDW;

// 下期待收本息 (废弃改用xqdsbx)
@property (nonatomic, copy)NSString *XYQYHLX;
@property (nonatomic, copy)NSString *XYQYHJE;
@property (nonatomic, copy)NSString *xqdsbx;

// 出借金额
@property (nonatomic, copy)NSString *JCJE;
// 标ID
@property (nonatomic, copy)NSString *B_ID;
// 已投金额
@property (nonatomic, copy)NSString *MQYTBJE;
// 总金额
@property (nonatomic, copy)NSString *ZE;

//下期还款时间
@property (nonatomic, copy) NSString *XYGHKRQ;
//剩余还款期数
@property (nonatomic, copy) NSString *SYHKQS;
//每期的回款额
@property (nonatomic, copy) NSString *MQHKE;
//还款方式 1:按月付息到期还本 2：到期还本付息 3：等额回款
@property (nonatomic, copy) NSString *HKFS;
//是否转让标识
@property (nonatomic, copy) NSString *TZR_ID;

@property (nonatomic, copy) NSString *SYGTZR_ID;
// 加息劵
@property (nonatomic, copy)NSString *JXQ_ID;
// 出借记录加息利率
@property (nonatomic, copy)NSString *JXLL;
// 出借时间
@property (nonatomic, copy)NSString *TBSJ;

// 出借记录ID
@property (nonatomic, copy)NSString *TZJL_ID;
@end
