//
//  BXRedPackRecordsModel.h
//  HBD
//
//  Created by echo on 15/9/6.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  红包记录

#import <Foundation/Foundation.h>

@interface BXRedPackRecordsModel : NSObject

// 创建时间
@property (nonatomic, copy)NSString *LSSJ;
// 类型
@property (nonatomic, copy)NSString *LSLX;
// 红包金额
@property (nonatomic, copy)NSString *HBJE;

@end
