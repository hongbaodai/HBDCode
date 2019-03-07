//
//  BXSendMessage.h
//  HBD
//
//  Created by echo on 15/7/31.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXSendMessage : NSObject

//初始化请求数据
+(NSMutableDictionary *)initWithService:(NSString *)service Body:(NSDictionary *)body;

//初始化登录请求数据
+(NSMutableDictionary *)initWithHeadAndService:(NSString *)service Body:(NSDictionary *)body;

////初始化统计请求数据
//+(NSMutableDictionary *)initWithBody:(NSDictionary *)body;

@end
