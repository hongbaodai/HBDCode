//
//  SinvoClick.m
//  HBD 
//
//  Created by echo on 15/11/20.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  统计相关类

#import "SinvoClick.h"
#import "sys/utsname.h"

@implementation SinvoClick{
    
    NSString *_cid;      // sessionID
    NSString *_uid;      // userID
    NSString *_czlx;     // 操作类型(10：登陆  20：注册 30:开户 40：出借 50：充值 60：提现  70：购买债权 80：APP启用)
    NSString *_lxid;     // 类型ID (操作类型对应的ID，有就是有，没有就是userId)
    NSString *_version;  // APP版本
    NSString *_os;       // 操作系统版本
    NSString *_model;    // 手机机型
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _cid = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"cid"]];
        NSString *key =  @"CFBundleShortVersionString";
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        _version = [NSString stringWithFormat:@"%@",infoDict[key]];
        _os = [NSString stringWithFormat:@"ios_%@",[[UIDevice currentDevice] systemVersion]];
        _model = [self deviceVersion];
    }
    return self;
}

+ (instancetype)standardSinvoClick
{
    static SinvoClick *s_SinvoClick;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        s_SinvoClick = [[SinvoClick alloc] init];
    });
    return s_SinvoClick;
    
}

// 避免多次重复发送
- (void)sendStatisticsWithczlx:(NSString *)czlx lxid:(NSString *)lxid{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([czlx isEqualToString:@"80"]) {
        [defaults setObject:@"" forKey:@"lxid"];
        [self sendWithczlx:czlx lxid:lxid];
    }else{
        if ([lxid isEqual:[defaults objectForKey:@"userId"]]) {
            [self sendWithczlx:czlx lxid:lxid];
        }else{
            if (![lxid isEqual:[defaults objectForKey:@"lxid"]]) {
                [self sendWithczlx:czlx lxid:lxid];
                [defaults setObject:lxid forKey:@"lxid"];
            }
        }
    }
}

// 发送统计
- (void)sendWithczlx:(NSString *)czlx lxid:(NSString *)lxid{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"userId"]) {
         _uid = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
    }else{
        _uid = @"";
    }

    info.dataParam = @{@"cid":_cid,@"uid":_uid,@"czlx":czlx,@"lxid":lxid,@"version":_version,@"os":_os,@"model":_model};

    [[BXNetworkRequest defaultManager] getStatisticsWithWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {

    } faild:^(NSError *error) {
        
    }];

}

// 判断机型
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    // iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S plus";
    // iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
    // iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad air 2";
    if ([deviceString isEqualToString:@"iPhone Simulator"] || [deviceString isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return deviceString;
}

@end





@implementation PageClick{
    NSString *_cid;      // sessionID
    NSString *_uid;      // userID
    NSString *_version;  // APP版本
    NSString *_os;       // 操作系统版本
    NSString *_model;    // 手机机型
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _cid = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"cid"]];
        NSString *key =  @"CFBundleShortVersionString";
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        _version = [NSString stringWithFormat:@"%@",infoDict[key]];
        _os = [NSString stringWithFormat:@"ios_%@",[[UIDevice currentDevice] systemVersion]];
        _model = [self deviceVersion];
    }
    return self;
}

+ (instancetype)standardPageClick
{
    static PageClick *s_PageClick;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        s_PageClick = [[PageClick alloc] init];
    });
    return s_PageClick;
}

- (void)sendStatisticsWithPageName:(NSString *)name{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"userId"]) {
        _uid = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
    }else{
        _uid = @"";
    }
    info.dataParam = @{@"cid":_cid,@"uid":_uid,@"version":_version,@"os":_os,@"model":_model,@"href":name};
    [[BXNetworkRequest defaultManager] getStatisticsWithWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {

    } faild:^(NSError *error) {
        
    }];
}


// 判断机型
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S plus";
    // iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
    // iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad air 2";
    if ([deviceString isEqualToString:@"iPhone Simulator"] || [deviceString isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return deviceString;
}

@end




