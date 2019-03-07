//
//  BXAccountAssetsVC.h
//  sinvo
//
//  Created by 李先生 on 15/4/15.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXAccountAssetsVC : NSObject

// 待收本金
@property (nonatomic, copy)NSString *toCollectPrincipal;
// 待收收益
@property (nonatomic, copy)NSString *toCollectInterest;
// 已收收益
@property (nonatomic, copy)NSString *totalEarnedInterest;
// 可用余额
@property (nonatomic, copy)NSString *cash;

// 下期应还
@property (nonatomic, copy)NSString *zjdhje;
// 体验金余额
@property (nonatomic, copy)NSString *usedmoney;

// 冻结资金
@property (nonatomic, copy)NSString *frozenBiddingCash;
// 出借总额
@property (nonatomic, copy)NSString *amount;

// 待还资金
@property (nonatomic, copy)NSString *totalToRepayAmount;
// 总资产
@property (nonatomic, copy)NSString *totalAssets;

//借款类型 个人借款1 企业借款2
@property (nonatomic, copy) NSString *khfs;

//  已收奖励
@property (nonatomic, copy)NSString *collectedReward;

// 代收奖励 
@property (nonatomic, copy)NSString *toCollectReward ;

// 累计充值
@property (nonatomic, copy)NSString *collectRecharge ;

// 已冻结提现金额
@property (nonatomic, copy)NSString *YDJTXZXJ;
// 已冻结投标金额
@property (nonatomic, copy)NSString *YDJTBZXJ;

@end
