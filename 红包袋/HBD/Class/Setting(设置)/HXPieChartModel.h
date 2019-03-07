//
//  HXPieChartModel.h
//  HBD
//
//  Created by hongbaodai on 2017/12/6.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXPieChartModel : NSObject

/**
 创建model

 @param value 值
 @param color 颜色
 @return HXPieChartModel
 */
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor*)color;

/** 值 */
@property (nonatomic, assign) CGFloat value;

/** 颜色 */
@property (nonatomic, copy) UIColor *color;

@end
