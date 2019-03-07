//
//  SinvoClick.h
//  HBD
//
//  Created by echo on 15/11/20.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  统计相关类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SinvoClick : NSObject

// 统计类型及类型ID
- (void)sendStatisticsWithczlx:(NSString *)czlx lxid:(NSString *)lxid;

// 初始化
+ (instancetype)standardSinvoClick;

@end



@interface PageClick : NSObject

// 统计页面
- (void)sendStatisticsWithPageName:(NSString *)name;

// 初始化
+ (instancetype)standardPageClick;

@end
