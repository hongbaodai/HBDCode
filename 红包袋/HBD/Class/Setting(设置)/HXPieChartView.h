//
//  HXPieChartView.h
//  HBD
//
//  Created by hongbaodai on 2017/12/6.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXPieChartView : UIView
/**
 创建视图

 @param frame frame
 @param items 数据
 @return HXPieChartView
 */
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;


@end
