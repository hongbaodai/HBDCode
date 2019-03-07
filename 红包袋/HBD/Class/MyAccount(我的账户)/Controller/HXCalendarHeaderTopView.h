//
//  HXCalendarHeaderTopView.h
//  HBD
//
//  Created by hongbaodai on 2018/9/10.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCalendarHeaderTopView : UIView
// 本月剩余回款
@property (weak, nonatomic) IBOutlet UILabel *mouthMoneyLab;
// 今日剩余回款
@property (weak, nonatomic) IBOutlet UILabel *dayMoneyLab;


+ (instancetype)creatHXCalendarHeaderTopViewWithFrame:(CGRect)frame;

@end
