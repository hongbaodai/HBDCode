//
//  BXTransferableModel.h
//  HBD
//
//  Created by echo on 15/10/28.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  回款中--可转让债权

#import <Foundation/Foundation.h>

@interface BXTransferableModel : NSObject

// 借款标题
@property (nonatomic, copy)NSString *loanTitle;
// 年化利率
@property (nonatomic, copy)NSString *loanAnnualInterestRate;
// 借款周期数字
@property (nonatomic, copy)NSString *HKZQSL;
// 出借金额
@property (nonatomic, copy)NSString *JCJE;
// 标id
@property (nonatomic, copy)NSString *B_ID;
//下期还款时间
@property (nonatomic, copy) NSString *XYGHKRQ;
//剩余还款期数
@property (nonatomic, copy) NSString *leftTermCount;
//还款方式
@property (nonatomic, copy) NSString *loanRepayType;
//债权id
@property (nonatomic, copy) NSString *TZJL_ID;

// 调取服务用
@property (nonatomic, copy) NSString *TZR_ID;
//折让率c
@property (nonatomic, copy) NSString *ZQJYZRL;
// 待收本金
@property (nonatomic, copy) NSString *JYHSBJ;


@end
