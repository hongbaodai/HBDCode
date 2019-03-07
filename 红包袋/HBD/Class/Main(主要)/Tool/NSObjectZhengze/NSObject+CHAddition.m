//
//  NSObject+CHAddition.m
//  BrilliantLoan
//
//  Created by cuoohe on 15/6/4.
//  Copyright (c) 2015年 cuoohe. All rights reserved.
//

#import "NSObject+CHAddition.h"

@implementation NSObject (CHAddition)

//验证输入的是否是正确格式的手机号
- (BOOL) isValidateMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,184,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,177,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,184,187,188,183
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189,181
     22         */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    /**
     29         * 国际长途中国区(+86)
     30         * 区号：+86
     31         * 号码：十一位
     32         */
    NSString * IPH = @"^\\+861(3|5|8)\\d{9}$";
    
    //判断是否为正确格式的手机号码
    NSPredicate* regextestmobile;
    NSPredicate* regextestcm;
    NSPredicate* regextestcu;
    NSPredicate* regextestct;
    NSPredicate* regextestiph;
    
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    regextestiph = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IPH];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestiph evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 判断输入的金额是否符合规则
- (BOOL) isValidateNum:(NSString *)text{
    
    NSString *regex = @"^[0-9]+(.[0-9]{2})?$";
    //    NSString *regex = @"^\d+(\.\d{2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:text];
}

//邮箱
- (BOOL) isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}



//用户名
- (BOOL) isValidateUserName:(NSString *)name {
    
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    
    BOOL B = [userNamePredicate evaluateWithObject:name];
    
    return B;
    
}

//昵称
- (BOOL) isValidateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


//身份证号
- (BOOL) isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    //    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSString *regex2 = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//密码
- (BOOL) isValidatePassword:(NSString *)passWord {
    //必须输入字母或数字
        NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    //必须输入字母和文字组合
//    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:passWord];
    
}
//验证数字：^[0-9]*$
- (BOOL) isValidateNumber:(NSString *)number {

    NSString *numRegex = @"^[0-9]*$";
    NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numRegex];
    
    return [numPredicate evaluateWithObject:number];
}

//车牌号验证
- (BOOL) isValidateCarNo:(NSString *)carNo {
    
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    
    return [carTest evaluateWithObject:carNo];
    
}

//车型
- (BOOL) isValidateCarType:(NSString *)CarType {
    
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    
    return [carTest evaluateWithObject:CarType];
    
}

// 是否全是汉字 ^[\u4E00-\u9FFF]+$   ^[\u4e00-\u9fa5],{0,}$
- (BOOL) isValidateText:(NSString *)text {
    
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    
    return [carTest evaluateWithObject:text];
    
}

//银行卡
- (BOOL) isValidateBankCardNum:(NSString *)bankCardNum
{
    BOOL flag;
    if (bankCardNum.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNum];
}

@end
