//
//  BXPlatformDataModel.h
//  
//
//  Created by echo on 16/3/23.
//
//  平台数据模型

#import <Foundation/Foundation.h>

@interface BXPlatformDataModel : NSObject

// 用户数量
@property (nonatomic, copy) NSString *userCount;
// 出借总额
@property (nonatomic, copy) NSString *investAmount;
// 收益总额
@property (nonatomic, copy) NSString *collectedInterest;

@end

@interface BXPlatformDataModel1 : NSObject

// 最高收益
@property (nonatomic, copy) NSString *zgnh;
// 逾期
//@property (nonatomic, copy) NSString *yq;
//// 坏账
//@property (nonatomic, copy) NSString *hz;

@end
