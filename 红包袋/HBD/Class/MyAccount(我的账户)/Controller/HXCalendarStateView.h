//
//  HXCalendarStateView.h
//  HBD
//
//  Created by hongbaodai on 2018/9/10.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCalendarStateView : UIView

// 选中的今天的日子
@property (weak, nonatomic) IBOutlet UILabel *selectTodayLabel;

+ (instancetype)creatHXCalendarStateViewWithFrame:(CGRect)frame;
@end
