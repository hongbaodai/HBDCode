//
//  BXUIWebRequsetManager.m
//  HBD
//
//  Created by echo on 15/8/10.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXUIWebRequsetManager.h"
#import <objc/runtime.h>
#import "NSString+URLEncoding.h"


@implementation BXWebRequesetInfo

//重写init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        int i;
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList([BXWebRequesetInfo class], &propertyCount);
        
        for (i = 0; i < propertyCount; i ++) {
            objc_property_t *thisProperty = propertyList + i;
            
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(*thisProperty)];
            [self setValue:@"" forKey:propertyName];

        }

    }
    return self;
}

@end




@implementation BXUIWebRequsetManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.info = [[BXWebRequesetInfo alloc]init];
    }
    return self;
}


+ (instancetype)defaultManager
{
    
    static BXUIWebRequsetManager *s_BXUIWebRequsetManager;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        s_BXUIWebRequsetManager = [[BXUIWebRequsetManager alloc] init];
        });
    return s_BXUIWebRequsetManager;
    
}


//拼接POST请求的请求链接
- (NSMutableURLRequest *)requestWithPayType:(MPPayType )payType PayObject:(BXWebRequesetInfo *)info
{
    NSURL *url;
    if (payType == MPPayTypeHKBank) {
        url = [NSURL URLWithString:info.url];
    } else {
        url = [NSURL URLWithString:info.action];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSString *body = [self splicingParametersWithWebRequesetInfo:info PayType:payType];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

    return request;
}
 
-(NSString *)splicingParametersWithWebRequesetInfo:(BXWebRequesetInfo *)info PayType:(MPPayType )payType
{
    NSString *parameters;
    
    switch (payType) {
        case MPPayTypeHKBank:{   //快捷充值

            parameters = [[NSString alloc]initWithFormat:@"reqData=%@&platformNo=%@&sign=%@&keySerial=%@&serviceName=%@&url=%@&userDevice=MOBILE", info.reqData, info.platformNo, [info.sign bx_URLEncodedString], info.keySerial, info.serviceName,[info.url bx_URLEncodedString]];
        }
            break;

        case MPPayTypeLDYS:{  //联动优势提现

            parameters = [[NSString alloc]initWithFormat:@"charset=%@&amount=%@&apply_notify_flag=%@&mer_id=%@&sign=%@&com_amt_type=%@&notify_url=%@&version=%@&mer_date=%@&user_id=%@&service=%@&sign_type=%@&res_format=%@&order_id=%@&ret_url=%@&sourceV=%@",info.charset,info.amount,info.apply_notify_flag,info.mer_id,[info.sign bx_URLEncodedString],info.com_amt_type,[info.notify_url bx_URLEncodedString],info.version,info.mer_date,info.user_id,info.service,info.sign_type,info.res_format,info.order_id,[info.ret_url bx_URLEncodedString],info.sourceV];
        }
            break;
        default:
            break;
    }
    
    return parameters;
}



@end
