//
//  BXSendMessage.m
//  HBD
//
//  Created by echo on 15/7/31.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXSendMessage.h"

@implementation BXSendMessage

+(NSMutableDictionary *)initWithService:(NSString *)service Body:(NSDictionary *)body
{
    //传入的参数
    NSMutableDictionary *sendMessage = [[NSMutableDictionary alloc]init];
    //服务名
    [sendMessage setObject:service forKey:@"service"];
    //加密
    //    [sendMessage setObject:@(1) forKey:@"encrypt"];
    //    //压缩
    //    [sendMessage setObject:@(1) forKey:@"compress"];
    //中转用标示
    NSString *key =  @"CFBundleShortVersionString";
    // 3.2获取软件当前版本号
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *client = [NSString stringWithFormat:@"{\"plat\":\"ios\",\"version\":\"%@\"}",infoDict[key]];
    [sendMessage setObject:client forKey:@"client"];
    //body
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *bodyString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [sendMessage setObject:bodyString forKey:@"body"];
    
    return sendMessage;
}

+(NSMutableDictionary *)initWithHeadAndService:(NSString *)service Body:(NSDictionary *)body
{
    //传入的参数
    NSMutableDictionary *sendMessage = [[NSMutableDictionary alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = !([defaults objectForKey:@"userId"] == nil) ? [defaults objectForKey:@"userId"] : @"";
    NSString *_T = !([defaults objectForKey:@"_T"] == nil) ? [defaults objectForKey:@"_T"] : @"";
    
    NSString *head = [NSString stringWithFormat:@"{\"_U\":\"%@\",\"_T\":\"%@\",\"sessionId\":\"%@\"}",userId,_T,[defaults objectForKey:@"sessionId"]];
    
    
    //头信息
    [sendMessage setObject:head forKey:@"head"];
    //服务名
    [sendMessage setObject:service forKey:@"service"];
    //加密
    //    [sendMessage setObject:@(1) forKey:@"encrypt"];
    //    //压缩
    //    [sendMessage setObject:@(1) forKey:@"compress"];
    //中转用标示
    NSString *key =  @"CFBundleShortVersionString";
    // 3.2获取软件当前版本号
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *client = [NSString stringWithFormat:@"{\"plat\":\"ios\",\"version\":\"%@\"}",infoDict[key]];
    //    NSString *client = [NSString stringWithFormat:@"{\"plat\":\"android\",\"version\":\"2.0.5\"}"];
    [sendMessage setObject:client forKey:@"client"];
    //body
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *bodyString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    bodyString = [bodyString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [sendMessage setObject:bodyString forKey:@"body"];
    
    
    return sendMessage;
}



@end
