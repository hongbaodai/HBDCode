//
//  AlertTextStyle.h
//  HBD
//
//  Created by hongbaodai on 2018/7/4.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertTextStyle : NSObject

/** 全部的文字 */
@property (nonatomic, strong) NSString *str;

/** 需要颜色的词 */
@property (nonatomic, strong) NSString *textStr;
/** 显示颜色 */
@property (nonatomic, strong) UIColor *textColor;

+ (instancetype)AlertStyleTextStr:(NSString *)textStr textColor:(UIColor *)color;


@end
