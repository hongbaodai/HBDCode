//
//  BXTransferModel.h
//  HBD
//
//  Created by echo on 15/10/27.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  转让中模型

#import <Foundation/Foundation.h>

@interface BXTransferModel : NSObject

// 标题
@property (nonatomic, copy) NSString *JKBT;
// 待收本金
@property (nonatomic, copy) NSString *JYHSBJ;
// 下期还款时间
@property (nonatomic, copy) NSString *XYGHKRQ;
// 费用
@property (nonatomic, copy) NSString *cost;
// 剩余周期
@property (nonatomic, copy) NSString *SYHKQS;
// 总周期
@property (nonatomic, copy) NSString *HKZQSL;
// 还款方式 1:按月付息到期还本 2：到期还本付息 3：等额回款
@property (nonatomic, copy) NSString *HKFS;
//债券id
@property (nonatomic , copy)NSString *TZJL_ID;
@end
