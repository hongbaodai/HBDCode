//
//  HXCalendarStateView.m
//  HBD
//
//  Created by hongbaodai on 2018/9/10.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "HXCalendarStateView.h"

@implementation HXCalendarStateView

+ (instancetype)creatHXCalendarStateViewWithFrame:(CGRect)frame
{
    HXCalendarStateView *topView = [[[NSBundle mainBundle] loadNibNamed:@"HXCalendarStateView" owner:nil options:nil] firstObject];
    topView.frame = frame;
    return topView;
}

@end
