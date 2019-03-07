//
//  BXInvestmentDetailModel.h
//  sinvo
//
//  Created by 李先生 on 15/4/6.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  出借详情header模型

#import <Foundation/Foundation.h>

@interface BXInvestmentDetailModel : NSObject
// 借款标题
@property (nonatomic, copy)NSString *JKBT;
// 年化收益
@property (nonatomic, copy)NSString *NHLL;

// 借款金额
@property (nonatomic, copy)NSString *ZE;

// 借款周期数字
@property (nonatomic, copy)NSString *HKZQSL;

// 借款周期单位(月或天) 1：天 2：周 3：月  4：年
@property (nonatomic, copy)NSString *HKZQDW;


//还款方式 1:按月付息到期还本 2：到期还本付息 3：等额回款
@property (nonatomic, copy)NSString  *HKFS;

/**
 * 起投金额
 */
@property (nonatomic, copy)NSString *QTJE;

/**
 * 递增金额
 */
@property (nonatomic, copy)NSString *DZJE;


/**
 * 目前已投标的金额
 */
@property (nonatomic, copy)NSString *MQYTBJE;

// 投标进度
@property (nonatomic, copy)NSString *schedule;

@property (nonatomic, copy)NSString *JKMS;

// 红包类型
//@property (nonatomic, copy)NSString *prizeType;

// 红包金额
//@property (nonatomic, copy)NSString *prizeValue;

// 出借权限
//@property (nonatomic, copy)NSString *investRight;

// 平台贴息
@property (nonatomic, copy)NSString *TXY;

// 平台贴息
@property (nonatomic, copy)NSString *TXZ;

// 用户组ID
@property (nonatomic, copy)NSString *YHZ_ID;

// 红包使用金额
@property (nonatomic, copy)NSString *SYJE;
// 红包使用比例
@property (nonatomic, copy)NSString *SYBL;
// 是否可使用红包
@property (nonatomic, copy)NSString *SFSYYHQ;

// 加息方式
@property (nonatomic, copy)NSString *JXFS;

// 活动标
@property (nonatomic, copy)NSString *HDBMC;

// SFTYB 1：普通标 3：新手标 2：体验标（预留字段，现在不作处理）
@property (nonatomic, copy)NSString *SFTYB;

// 起投上限
@property (nonatomic, copy)NSString *QTQX;

// 是否可叠加 0 不能，1可以
@property (nonatomic, copy)NSString *SFDJSY;

// 现在时间
@property (nonatomic, copy)NSString *nowDate;

// 倒计时开标时间
@property (nonatomic, copy)NSString *DJSKBSJ;

// 最大出借额
@property (nonatomic, copy)NSString *ZDTZJE;


// 当前用对当前标已经投过的金额数
@property (nonatomic, copy)NSString *haveinvestAmount;

@end
