//
//  AlertTextStyle.m
//  HBD
//
//  Created by hongbaodai on 2018/7/4.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "AlertTextStyle.h"

@implementation AlertTextStyle


+ (instancetype)AlertStyleTextStr:(NSString *)textStr textColor:(UIColor *)color
{
    AlertTextStyle *style = [[AlertTextStyle alloc] init];
    style.textColor = color;
    style.textStr = textStr;
    return style;
}

@end
