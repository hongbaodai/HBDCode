//
//  HXPieChartModel.m
//  HBD
//
//  Created by hongbaodai on 2017/12/6.
//

#import "HXPieChartModel.h"

@implementation HXPieChartModel

/** 创建model */
+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
{
    HXPieChartModel *item = [HXPieChartModel new];
    item.value = value;
    item.color  = color;
    return item;
}

@end
