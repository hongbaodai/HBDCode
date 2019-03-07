

//
//  NSDate+Setting.m
//  HBD
//
//  Created by hongbaodai on 2017/7/27.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "NSDate+Setting.h"

@implementation NSDate (Setting)


/** 时间转成年月日时分秒(转成年月日 ，到天) */
+ (NSString *)transformStrToDay:(NSString *)dayStr
{
    long long time = [dayStr longLongValue];
    
    NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString * timeString = [formatter stringFromDate:data];
    return timeString;
}

/** 时间转成：时、分、秒 */
+ (NSString *)transformDateSecondsToTime:(NSString *)timeStr
{
    
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}

/** 时间转成:yyyy-MM-dd HH:mm */
+ (NSString *)transformDateSecondsNoMToTime:(NSString *)timeStr
{
    NSString *tradeTime = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    
    NSDate *date = [formatter dateFromString:tradeTime];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

/** 时间转成：时、分 */
+ (NSString *)ConvertStrToTime:(NSString *)timeStr
{
    
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}

/** 处理时间格式:yyyy-MM-dd HH:mm:ss.0 -> yyyy-MM-dd */
+ (NSString *)formmatDateStr:(NSString *)str
{
    NSString *tradeTime = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:tradeTime];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

/**
 处理时间格式:现在时间 -> yyyy-MM-dd
 
 @return yyyy.MM.dd格式字符串
 */
+ (NSString *)formmatDate
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *endTime = [formatter stringFromDate:nowDate];
    return endTime;
}

/**
 处理时间格式:现在时间 -> yyyy-MM-dd
 
 @return yyyy.MM.dd格式字符串
 */
+ (NSString *)formmatDateSFM
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *endTime = [formatter stringFromDate:nowDate];
    return endTime;
}

/**
 处理时间格式:发送时间 -> yyyy-MM-dd HH:mm:ss

 @return yyyy-MM-dd格式字符串
 */
+ (NSString *)formmatThisDateSFMWithDate:(NSDate *)datee
{
    NSDate *nowDate = datee;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSString *endTime = [formatter stringFromDate:nowDate];
    return endTime;
}

/** 时间转化为时间戳 */
+ (NSString *)transformTimeToChuo:(NSString *)timeChuo
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //设置时区,这个对于时间的处理有时很重要   此项目用不到
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:timeChuo];
    NSTimeInterval timel = [date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timel]; //转为字符型
    
    return timeString;
}

+ (TimeState)timeStateWithTimeStrWithStr:(NSString *)dateStr
{
    
    NSDate *today = [[NSDate alloc] init];

    NSString * todayString = [[today description] substringToIndex:10];
    
    NSString * dateString = [[dateStr description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return TimeStateNow;
    } else {
        return TimeStateOther;
    }
}

@end
