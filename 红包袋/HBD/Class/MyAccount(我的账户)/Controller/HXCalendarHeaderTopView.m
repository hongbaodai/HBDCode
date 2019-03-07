//
//  HXCalendarHeaderTopView.m
//  HBD
//
//  Created by hongbaodai on 2018/9/10.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "HXCalendarHeaderTopView.h"

@implementation HXCalendarHeaderTopView

+ (instancetype)creatHXCalendarHeaderTopViewWithFrame:(CGRect)frame
{
    HXCalendarHeaderTopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"HXCalendarHeaderTopView" owner:nil options:nil] firstObject];
    topView.frame = frame;
    return topView;
}

@end
