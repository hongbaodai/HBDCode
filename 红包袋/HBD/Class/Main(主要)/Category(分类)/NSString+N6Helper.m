//
//  NSString+N6Helper.m
//  mobip2p
//
//  Created by Guo Yu on 14/11/1.
//  Copyright (c) 2014年 zkbc. All rights reserved.
//

#import "NSString+N6Helper.h"

@implementation NSString (N6Helper)

- (NSString*)n6_trimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)n6_isEmpty {
    BOOL res = (nil == self ||0 == [[self n6_trimmedString] length]);
    return res;
//    return (nil == self ||0 == [[self n6_trimmedString] length]);
}

- (BOOL)n6_isEmail {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailPredicate evaluateWithObject:self];
}
// 手机号
- (BOOL)n6_isMobile {
    NSString *mobileRegex = @"^[1][34578][0-9]{9}$";
//    @"1[0-9]{10}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", mobileRegex];
    return [predicate evaluateWithObject:self];
}

/**
 * 身份证验证
 */
- (BOOL)n6_isIdentityCard {
    NSString *IDRegex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IDRegex2];
    return [predicate evaluateWithObject:self];
}

/**
 * 纯数字验证
 */
- (BOOL)n6_isNumber {
    NSString *numberRegex =
    @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [predicate evaluateWithObject:self];
}

/**
 * 只能输入字母、数字、汉字验证
 */
- (BOOL)n6_isName {
    NSString *nameRegex =
    @"^[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9_\u4E00-\u9FA5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [predicate evaluateWithObject:self];
}

/**
 * 只能输入字母、数字验证
 */
- (BOOL)n6_isPassWord {
    NSString *passwordRegex =
    @"[a-zA-Z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [predicate evaluateWithObject:self];
}

/**
 * 以数字开头验证
 */
- (BOOL)n6_isNumberHeader {
    NSString *numberHeaderRegex =
    @"^[0-9][a-zA-Z0-9_\u4E00-\u9FA5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberHeaderRegex];
    return [predicate evaluateWithObject:self];
}

+ (NSString*)formattedAmountStringWithDouble:(double)amount {
    NSMutableString *resultString = [NSMutableString stringWithFormat:@"%.2f", amount];
    
    BOOL bellowZearo = NO;
    if (amount < 0.0f) {
        bellowZearo = YES;
        [resultString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    NSInteger count = ([resultString length] - 1) / 3 - 2;
    NSInteger mod = [resultString length]%3==0?3:[resultString length]%3;
    
    for (int i=0; i<=count; i++) {
        [resultString insertString:@"," atIndex:mod+3*(count-i)];
    }
    
    if (bellowZearo) {
        [resultString insertString:@"-" atIndex:0];
    }
    
    return [[NSString stringWithString:resultString] stringByAppendingString:@"元"];
}

+ (NSString*)formattedAmountStringWithString:(NSString*)amount {
    return [self formattedAmountStringWithDouble:[amount doubleValue]];
}
+ (NSString *)formattedGenderWithIdCardNo:(NSString *)idCardNo{
    int a=0;
    if (idCardNo.length==15) {
        a=[idCardNo substringFromIndex:14].intValue;
    }else if (idCardNo.length==18){
        a=[idCardNo substringWithRange:NSMakeRange(16, 1)].intValue;
    }
    if (a%2==1) {
        return @"男";
    }else{
        return @"女";
    }
}
@end
