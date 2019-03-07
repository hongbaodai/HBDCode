//
//  BXInvestmentModel.h
//  sinvo
//
//  Created by 李先生 on 15/4/2.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  出借主页模型

#import <Foundation/Foundation.h>

@interface BXInvestmentModel : NSObject

// 借款标题
@property (nonatomic, copy)NSString *JKBT;
// 年化收益
@property (nonatomic, copy)NSString *NHLL;

// 借款金额
@property (nonatomic, copy)NSString *ZE;

// 借款周期数量
@property (nonatomic, copy)NSString *HKZQSL;

// 借款周期单位(月或天) 1：天 2：周 3：月  4：年
@property (nonatomic, copy)NSString *HKZQDW;

// 进度环
@property (nonatomic, copy)NSString *schedule;

// 进度标签
@property (nonatomic, copy)NSString *InvestmentProgressLab;

// 数据ID
@property (nonatomic, copy)NSString *B_ID;

// 产品ID
@property (nonatomic, copy)NSString *BCP_ID;

// 平台贴息：右边的加息
@property (nonatomic, copy)NSString *TXY;

// 平台利息：左边的利息
@property (nonatomic, copy)NSString *TXZ;

// 用户组ID
@property (nonatomic, copy)NSString *YHZ_ID;
// 红包使用金额
@property (nonatomic, copy)NSString *SYJE;
// 红包使用比例
@property (nonatomic, copy)NSString *SYBL;
// 借款账户ID
@property (nonatomic, copy)NSString *JKZH_ID;
// 是否可用优惠券
@property (nonatomic, copy)NSString *SFSYYHQ;
// 活动标签
@property (nonatomic, copy)NSString *HDBMC;
// 1：普通标 3：新手标 2：体验标（预留字段，现在不作处理）
@property (nonatomic, copy)NSString *SFTYB;

// 倒计时开标时间
@property (nonatomic, copy)NSString *DJSKBSJ;
// 当前时间
@property (nonatomic, copy)NSString *nowDate;

// 等额本息 3
@property (nonatomic, copy)NSString *HKFS;

@end
