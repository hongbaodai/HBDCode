//
//  NSDate+Setting.h
//  HBD
//
//  Created by hongbaodai on 2017/7/27.
//

#import <Foundation/Foundation.h>

typedef enum {
    TimeStateNow,
    TimeStateOther
}TimeState;

@interface NSDate (Setting)

/** 时间转成：时：分：秒 HH:mm:ss */
+ (NSString *)transformDateSecondsToTime:(NSString *)timeStr;

/** 时间转成:yyyy-MM-dd HH:mm */
+ (NSString *)transformDateSecondsNoMToTime:(NSString *)timeStr;

/**
 时间转成:年、月、日  yyyy/MM/dd

 @param dayStr 需要转化的时间字符串
 @return 返回年月日格式字符串
 */
+ (NSString *)transformStrToDay:(NSString *)dayStr;
/**
 时间转成:时、分 HH:mm
 
 @param dayStr 需要转化的时间字符串
 @return 返回年月日格式字符串
 */
+ (NSString *)ConvertStrToTime:(NSString *)timeStr;

/**
 处理时间格式:yyyy-MM-dd HH:mm:ss.0 -> yyyy-MM-dd

 @param str 时间格式字符串
 @return yyyy.MM.dd格式字符串
 */
+ (NSString *)formmatDateStr:(NSString *)str;

/**
 处理时间格式:现在时间 -> yyyy-MM-dd
 
 @return yyyy.MM.dd格式字符串
 */
+ (NSString *)formmatDate;
/**
 处理时间格式:发送时间 -> yyyy-MM-dd HH:mm:ss

 @return yyyy-MM-dd格式字符串
 */
+ (NSString *)formmatThisDateSFMWithDate:(NSDate *)datee;

/**
 处理时间格式:现在时间 -> yyyy-MM-dd
 
 @return yyyy-MM-dd HH:mm:ss格式字符串
 */
+ (NSString *)formmatDateSFM;

/**
 时间字符串：年月日 -> 时间戳
 @param timeChuo 时间字符串：年月日
 @return 时间戳
 */
+ (NSString *)transformTimeToChuo:(NSString *)timeChuo;

+ (TimeState)timeStateWithTimeStrWithStr:(NSString *)dateStr;

@end
