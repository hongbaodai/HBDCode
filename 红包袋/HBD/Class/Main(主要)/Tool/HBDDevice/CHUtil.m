//
//  CHUtil.m
//  HBD
//
//  Created by 草帽~小子 on 2019/3/13.
//  Copyright © 2019 李先生. All rights reserved.
//

#import "CHUtil.h"

@implementation CHUtil

+ (NSString *)localVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (BOOL)checkInputPhoneNum:(NSString*)num
{
    if (num.length != 11)
    {
        return NO;//!请输入正确的手机号码
    }
    NSString *compare = @"0123456789";
    NSString *temp;
    for (NSInteger i = 0; i < [num length]; i ++)
    {
        temp = [num substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [compare rangeOfString:temp];
        NSInteger location = range.location;
        if (location < 0)
        {
            return NO;//!请输入正确的号码
        }
    }
    return YES;
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]){
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)textField:(UITextField *)textField evaluateNumberChargeInRange:(NSRange)range replacementString:(NSString *)string hasDot:(BOOL *)hasDot
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        *hasDot = NO;
    }
    if ([string length]>0)
    {
        if ((textField.text.length < 6 && !*hasDot) || ([textField.text rangeOfString:@"."].location < 6 && *hasDot)) {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single == '.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return YES;
                    }
                }
                if (single=='.')
                {
                    //text中还没有小数点
                    if(!*hasDot)
                    {
                        *hasDot = YES;
                        return YES;
                    }else
                    {
                        //已经输入过小数点了
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    if (*hasDot)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        NSInteger tt=range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                    else
                    {
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                //            [self alertView:@"亲，您输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else if(textField.text.length == 6 && !*hasDot && [string characterAtIndex:0] == '.'){
            return YES;
        }else if((textField.text.length == 7 || textField.text.length == 8) && [textField.text rangeOfString:@"."].location == 6)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if (single >='0' && single<='9')//数据格式正确
            {
                NSRange ran=[textField.text rangeOfString:@"."];
                NSInteger tt=range.location-ran.location;
                if (tt <= 2){
                    return YES;
                }else{
                    return NO;
                }
            }
            else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
            return NO;
        }
    }
    else
    {
        return YES;
    }
    return NO;
}

+ (CGSize)textSize:(NSString *)text font:(UIFont *)font bounding:(CGSize)size
{
    if (!(text && font) || [text isEqual:[NSNull null]]) {
        return CGSizeZero;
    }
    CGRect rect = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
    return CGRectIntegral(rect).size;
}

+ (NSString *)formatFloat:(CGFloat)number
{
    NSNumberFormatter *formatter = [CHUtil numberFormatter];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:number]];
}

+ (NSNumberFormatter *)numberFormatter
{
    NSNumberFormatter *formatter;
    if (formatter == nil)
    {
        formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //小数最多位数
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
    }
    
    return formatter;
}

+ (CGFloat)singleLineHeight:(UIFont *)font
{
    return [CHUtil textSize:@"A" font:font bounding:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
//    if ([cString length] < 6) {
//        return [ECStyle blackTextColor];
//    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)formatTime:(NSInteger)time
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithSeconds:(NSTimeInterval)seconds timeFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    static NSDateFormatter *formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSTimeInterval)secondsWithString:(NSString *)string timeFormat:(NSString *)format
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:string];
    return [date timeIntervalSince1970];
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){CGPointZero,size});
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
