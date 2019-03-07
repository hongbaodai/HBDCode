//
//  UILabel+Addtion.h
//  HBD
//
//  Created by hongbaodai on 2017/8/3.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addtion)

/**
 *  快速创建Lable
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                  backgroundColor:(UIColor *)backgroundColor
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)textAlignment
                             font:(UIFont *)font
                              tag:(NSInteger)tag;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;



@end
