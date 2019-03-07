//
//  NSString+N6Helper.h
//  mobip2p
//
//  Created by Guo Yu on 14/11/1.
//  Copyright (c) 2014年 zkbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (N6Helper)

- (NSString*)n6_trimmedString;
- (BOOL)n6_isEmpty;
- (BOOL)n6_isEmail;
- (BOOL)n6_isMobile;

/** 用户名验证 */
- (BOOL)n6_isName;

/** 身份证验证 */
- (BOOL)n6_isIdentityCard;

/** 纯数字验证 */
- (BOOL)n6_isNumber;

/** 密码验证 */
- (BOOL)n6_isPassWord;

/** 以数字开头验证 */
- (BOOL)n6_isNumberHeader;

+ (NSString*)formattedAmountStringWithDouble:(double)amount;
+ (NSString*)formattedAmountStringWithString:(NSString*)amount;
+ (NSString *)formattedGenderWithIdCardNo:(NSString *)idCardNo;
@end
