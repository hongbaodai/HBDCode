//
//  NSString+Other.m
//  HBD
//
//  Created by hongbaodai on 2017/7/27.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "NSString+Other.h"


static NSString *const salt = @"HXWcjvQWVG1wI4FQBLZpQ3pWj48AV63d";

@implementation NSString (Other)

/** 去掉字符串中html标签 */
+ (NSString *)filterHTML:(NSString *)html
{
    if (html) {
        NSScanner *scanner = [NSScanner scannerWithString:html];
        NSString *text = nil;
        while ([scanner isAtEnd] == NO)
        {
            //找到标签的起始位置
            [scanner scanUpToString:@"<" intoString:nil];
            //找到标签的结束位置
            [scanner scanUpToString:@">" intoString:&text];
            //替换字符串
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }
    }
    return html;
}

/** 判断是输入小数 */
+ (BOOL)checkNum:(NSString *)str
{
    //小数
    NSString *regex = @"^\\d+(\\.[\\d]{1,2})?$";
    //    NSString *regex = @"^[0-9]+$";  //整数
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

/** 判断是输入整数 */
+ (BOOL)checkNumisWholeNumber:(NSString *)str
{
    //小数
//    NSString *regex = @"^\\d+(\\.[\\d]{1,2})?$";
    NSString *regex = @"^[0-9]+$";  //整数
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

/** MD5加密 */
+ (NSString *)MD5:(NSString *)inbuf
{
    const char *cStr = [inbuf UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (uint)strlen(cStr), result); // This is the md5 call
    
    NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    return [hash uppercaseString];
}

/** 加盐 */
+ (NSString *)encodeByMd5AndSalt:(NSString *)inbuf
{
    NSString *str = [self MD5:inbuf];
    str = [str stringByAppendingString:salt];
    
    return [self MD5:str];
}

/** 计算文本文字的矩形的尺寸 */
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize
{
    //传入一个字体（大小号）保存到字典
    NSDictionary *attrs = @{NSFontAttributeName : font};
    //maxSize定义他的最大尺寸   当实际比定义的小会返回实际的尺寸，如果实际比定义的大会返回定义的尺寸超出的会剪掉，所以一般要设一个无限大 MAXFLOAT
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/** 计算文本文字的矩形的尺寸:返回尺寸 */
- (CGFloat)sizeWithFontNum:(CGFloat)fontNum MaxSize:(CGSize)maxSize
{
    //传入一个字体（大小号）保存到字典
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    NSDictionary *attrs = @{NSFontAttributeName : font};
    //maxSize定义他的最大尺寸   当实际比定义的小会返回实际的尺寸，如果实际比定义的大会返回定义的尺寸超出的会剪掉，所以一般要设一个无限大 MAXFLOAT
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
}

/** 字符串中包含几个str */
- (NSInteger)coutOfStrContainWith:(NSString *)str
{
    int num = 0;
    for (int i = 0; i < self.length; i ++) {
        NSString *newStr = [self substringWithRange:NSMakeRange(i, 1)];
        
        if ([newStr isEqual:@"."]) {
            num ++;
        }
    }
    return num;
}

- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{

    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }

    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;

        for (int i = 0;; i++)
        {
            if (0 == i) {
                //去掉这个abc字符串
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }

            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];

            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                break;
            }
            else//添加符合条件的location进数组

                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}

/**
 对string中无数SmallStr字符串进行字体smallFont修改。原字符串StrbigFont;

 @param str 要修改的smallStr
 @param smallFont 要修改smallStr的大小
 @param bigFont 本身字符串的大小
 @return 设置好的富文本
 */
- (NSAttributedString *)homeAttributedStringWithSmallStr:(NSString *)str smallFont:(UIFont *)smallFont bigFont:(UIFont *)bigFont
{
    NSArray *arr = [self getRangeStr:self findText:str];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self];
    [attr addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, self.length)];

    for (int i = 0; i < arr.count; i ++) {

        NSRange rag = NSMakeRange([arr[i] integerValue], 1);
        NSDictionary * firstAttributes = @{ NSFontAttributeName:smallFont};
        [attr setAttributes:firstAttributes range:rag];
    }

    if (arr.count > 0) {
        NSInteger cou = [arr[0] integerValue] + 1;
        if (self.length >= cou) {
            [attr addAttribute:NSForegroundColorAttributeName value:kColor_Orange_Dark range:NSMakeRange(0, self.length)];
            [attr addAttribute:NSForegroundColorAttributeName value:kColor_Red_Main range:NSMakeRange(0, cou)];
            return attr;
        };
    }
    [attr addAttribute:NSForegroundColorAttributeName value:kColor_Red_Main range:NSMakeRange(0, self.length)];
    return attr;
}

// 四舍五入并保留两位小数
- (NSString *)roundWithTwo
{
    double i = (double)([self doubleValue] * 100.0 + 0.5);
    int j = (int)i;
    double x = (double)(j / 100.0);

    NSString *result = [NSString stringWithFormat:@"%.2lf",x];
    return result;
}

// 判断输入字符串是否包含数字和字母 特殊字符不限
- (BOOL)isValidPasswordString
{
    BOOL result = NO;
    if ([self length] >= 8 && [self length] <= 16){
        //数字条件
        NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];

        //符合数字条件的有几个
        NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:self
                                                                           options:NSMatchingReportProgress
                                                                             range:NSMakeRange(0, self.length)];

        //英文字条件
        NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];

        //符合英文字条件的有几个
        NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self
                                                                                 options:NSMatchingReportProgress
                                                                                   range:NSMakeRange(0, self.length)];

        if(tNumMatchCount >= 1 && tLetterMatchCount >= 1){
            result = YES;
        }

    }
    return result;
}


@end
