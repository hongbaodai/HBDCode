//
//  BXNewPeopleModel.h
//  HBD
//
//  Created by echo on 15/9/8.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXNewPeopleModel : NSObject

// 借款标题
@property (nonatomic, copy)NSString *JKBT;
// 年化收益
@property (nonatomic, copy)NSString *NHLL;

// 借款金额
@property (nonatomic, copy)NSString *ZE;

// 借款周期数字
@property (nonatomic, copy)NSString *HKZQSL;

// 借款周期单位(月或天)
@property (nonatomic, copy)NSString *HKZQDW;

// 进度环
@property (nonatomic, copy)NSString *schedule;

// 进度标签
@property (nonatomic, copy)NSString *InvestmentProgressLab;

// 标ID
@property (nonatomic, copy)NSString *B_ID;

@end
