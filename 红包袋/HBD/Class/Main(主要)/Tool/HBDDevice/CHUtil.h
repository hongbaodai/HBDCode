//
//  CHUtil.h
//  HBD
//
//  Created by 草帽~小子 on 2019/3/13.
//  Copyright © 2019 李先生. All rights reserved.
//

/*
 *common handle 通用处理
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHUtil : NSObject

+ (NSString *)localVersion;
+ (NSString *)appName;

# pragma mark - 有效性检查
/**
 *  简单判断是否是电话号码（11位&数字）
 *
 *  @param num 字符串
 *
 *  @return 是否是电话号码
 */
+ (BOOL)checkInputPhoneNum:(NSString*)num;

/**
 *  判断是否是空字符串
 *
 *  @param string 字符串
 *
 *  @return 是否为空
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 *  限制输入（最多两位小数，最多8位数字）
 *
 *  @param textField 见说明
 *  @param range     见说明
 *  @param string    见说明
 *  @param hasDot    见说明
 *
 *  @return 见说明
 *  将此方法置于 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 中使用
 */
+ (BOOL)textField:(UITextField *)textField evaluateNumberChargeInRange:(NSRange)range replacementString:(NSString *)string hasDot:(BOOL *)hasDot;

# pragma mark - 其他方法
/**
 *  计算文字尺寸
 *
 *  @param text 文字
 *  @param font 字号
 *  @param size 范围
 *
 *  @return 文字占用尺寸
 */
+ (CGSize)textSize:(NSString *)text font:(UIFont *)font bounding:(CGSize)size;

/**
 *  数字转字符串
 *
 *  @param number 数字
 *
 *  @return 字符串
 */
+ (NSString *)formatFloat:(CGFloat)number;

/**
 *  单行文字高度
 *
 *  @param font 字号
 *
 *  @return 高度
 */
+ (CGFloat)singleLineHeight:(UIFont *)font;

#pragma mark - 颜色相关
/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color 十六进制颜色码
 *
 *  @return 相对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

# pragma mark - 时间相关

/**
 *  格式化时间字符串转换
 *
 *  @param time 时间戳
 *
 *  @return 格式化时间
 */
+ (NSString *)formatTime:(NSInteger)time;

/**
 *  时间戳2字符串
 *
 *  @param seconds 时间戳
 *  @param format  时间格式
 *
 *  @return 格式化时间
 */
+ (NSString *)stringWithSeconds:(NSTimeInterval)seconds timeFormat:(NSString *)format;

/**
 *  字符串2时间戳
 *
 *  @param string 字符串
 *  @param format 时间格式
 *
 *  @return 时间戳
 */
+ (NSTimeInterval)secondsWithString:(NSString *)string timeFormat:(NSString *)format;

# pragma mark - 图片相关操作

/**
 *  颜色转图片
 *
 *  @param color 颜色
 *  @param rect  尺寸
 *
 *  @return 图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
