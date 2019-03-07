//
//  BXInvestFinishModel.h
//  sinvo
//
//  Created by 李先生 on 15/4/22.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  已完成

#import <Foundation/Foundation.h>

@interface BXInvestFinishModel : NSObject



// 借款标题
@property (nonatomic, copy)NSString *JKBT;
// 借款人
@property (nonatomic, copy)NSString *JRZNC;
// 出借时间
@property (nonatomic, copy)NSString *TBSJ;

// 利率
@property (nonatomic, copy)NSString *NHLL;

// 出借金额
@property (nonatomic, copy)NSString *JCJE;

// 净收益(下面两个)
@property (nonatomic, copy) NSString *jsy;

// 借款周期
@property (nonatomic, copy)NSString *HKZQSL;

// 剩余周期
@property (nonatomic, copy)NSString *SYHKQS;

// 出借人ID
@property (nonatomic, copy)NSString *TZR_ID;
// 上一个出借人ID
@property (nonatomic, copy)NSString *SYGTZR_ID;


@property (nonatomic, copy)NSString *B_ID;

// 还款方式 1:按月付息到期还本 2：到期还本付息 3：等额回款
@property (nonatomic, copy)NSString *HKFS;

// 加息劵
@property (nonatomic, copy)NSString *JXQ_ID;

// 出借记录加息
@property (nonatomic, copy)NSString *JXLL;

@end
