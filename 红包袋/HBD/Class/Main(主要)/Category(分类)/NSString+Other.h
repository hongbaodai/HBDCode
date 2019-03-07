//
//  NSString+Other.h
//  HBD
//
//  Created by hongbaodai on 2017/7/27.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSString (Other)

/**
 去掉字符串中html标签

 @param html 带有html的字符串
 @return string
 */
+ (NSString *)filterHTML:(NSString *)html;

/**
 判断是输入小数

 @param str 需要判断的Str
 @return 返回bool
 */
+ (BOOL)checkNum:(NSString *)str;

/**
 判断是输入整数
 
 @param str 需要判断的Str
 @return 返回bool
 */
+ (BOOL)checkNumisWholeNumber:(NSString *)str;

/**
 MD5加密

 @param inbuf 需加密的字符串
 @return 加密好的字符串
 */
+ (NSString *)MD5:(NSString *)inbuf;

/**
 加盐

 @param inbuf 需要加密字符串
 @return 返回加盐字符串
 */
+ (NSString *)encodeByMd5AndSalt:(NSString *)inbuf;

/**
 计算文本文字的矩形的尺寸

 @param font 字号大小
 @param maxSize 定义他的最大尺寸
 @return 计算好的文字尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;

/**
 计算文本文字的矩形的尺寸:返回尺寸

 @param fontNum 字号大小
 @param maxSize 定义他的最大尺寸
 @return 高度
 */
- (CGFloat)sizeWithFontNum:(CGFloat)fontNum MaxSize:(CGSize)maxSize;

/**
 字符串中包含几个str

 @param str 被检测的字符
 @return 检测出来的数量
 */
- (NSInteger)coutOfStrContainWith:(NSString *)str;

/**
 对string中无数SmallStr字符串进行字体smallFont修改。原字符串StrbigFont;

 @param str 要修改的smallStr
 @param smallFont 要修改smallStr的大小
 @param bigFont 本身字符串的大小
 @return 设置好的富文本
 */
- (NSAttributedString *)homeAttributedStringWithSmallStr:(NSString *)str smallFont:(UIFont *)smallFont bigFont:(UIFont *)bigFont;

// 四舍五入并保留两位小数
- (NSString *)roundWithTwo;


/**
 判断输入字符串是否包含数字和字母 特殊字符不限 8-16位
 */
- (BOOL)isValidPasswordString;

@end
