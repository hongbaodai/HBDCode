//
//  IpDeviceInfo.m
//  HBD
//
//  Created by 草帽~小子 on 2019/3/13.
//  Copyright © 2019 李先生. All rights reserved.
//

#import "CDInfo.h"
#include <sys/utsname.h>
#import "CHUtil.h"

@implementation CDInfo

+ (NSDictionary *)clientInfo
{
    NSDictionary *models = @{
                             @"iPhone1,1":@"iPhone",
                             @"iPhone1,2":@"iPhone 3G",
                             @"iPhone2,1":@"iPhone 3GS",
                             @"iPhone3,1":@"iPhone 4",
                             @"iPhone3,2":@"iPhone 4",
                             @"iPhone3,3":@"iPhone 4",
                             @"iPhone4,1":@"iPhone 4S",
                             @"iPhone5,1":@"iPhone 5",
                             @"iPhone5,2":@"iPhone 5",
                             @"iPhone5,3":@"iPhone 5c",
                             @"iPhone5,4":@"iPhone 5c",
                             @"iPhone6,1":@"iPhone 5s",
                             @"iPhone6,2":@"iPhone 5s",
                             @"iPhone7,2":@"iPhone 6",
                             @"iPhone7,1":@"iPhone 6 Plus",
                             @"iPhone8,1":@"iPhone 6s",
                             @"iPhone8,2":@"iPhone 6s Plus",
                             @"iPhone8,4":@"iPhone SE",
                             @"iPhone9,1":@"iPhone 7",
                             @"iPhone9,3":@"iPhone 7",
                             @"iPhone9,2":@"iPhone 7",
                             @"iPhone9,4":@"iPhone 7 Plus",
                             @"iPhone10,1":@"iPhone 8",
                             @"iPhone10,4":@"iPhone 8",
                             @"iPhone10,2":@"iPhone 8 Plus",
                             @"iPhone10,5":@"iPhone 8 Plus",
                             @"iPhone10,3":@"iPhone X",
                             @"iPhone10,6":@"iPhone X",
                             @"iPod1,1":@"iPod touch",
                             @"iPod2,1":@"iPod touch 2G",
                             @"iPod3,1":@"iPod touch 3G",
                             @"iPod4,1":@"iPod touch 4G",
                             @"iPod5,1":@"iPod touch 5G",
                             @"iPod7,1":@"iPod touch 6G",
                             @"iPad1,1":@"iPad",
                             @"iPad2,1":@"iPad 2",
                             @"iPad2,2":@"iPad 2",
                             @"iPad2,3":@"iPad 2",
                             @"iPad2,4":@"iPad 2",
                             @"iPad3,1":@"iPad 3",
                             @"iPad3,2":@"iPad 3",
                             @"iPad3,3":@"iPad 3",
                             @"iPad3,4":@"iPad 4",
                             @"iPad3,5":@"iPad 4",
                             @"iPad3,6":@"iPad 4",
                             @"iPad4,1":@"iPad Air",
                             @"iPad4,2":@"iPad Air",
                             @"iPad4,3":@"iPad Air",
                             @"iPad5,3":@"iPad Air 2",
                             @"iPad5,4":@"iPad Air 2",
                             @"iPad6,7":@"iPad Pro (12.9-inch)",
                             @"iPad6,8":@"iPad Pro (12.9-inch)",
                             @"iPad6,3":@"iPad Pro (9.7-inch)",
                             @"iPad6,4":@"iPad Pro (9.7-inch)",
                             @"iPad6,11":@"iPad 5G",
                             @"iPad6,12":@"iPad 5G",
                             @"iPad7,1":@"iPad Pro (12.9-inch, 2G)",
                             @"iPad7,2":@"iPad Pro (12.9-inch, 2G)",
                             @"iPad7,3":@"iPad Pro (10.5-inch)",
                             @"iPad7,4":@"iPad Pro (10.5-inch)",
                             @"iPad2,5":@"iPad mini 1G",
                             @"iPad2,6":@"iPad mini 1G",
                             @"iPad2,7":@"iPad mini 1G",
                             @"iPad4,4":@"iPad mini 2",
                             @"iPad4,5":@"iPad mini 2",
                             @"iPad4,6":@"iPad mini 2",
                             @"iPad4,7":@"iPad mini 3",
                             @"iPad4,8":@"iPad mini 3",
                             @"iPad4,9":@"iPad mini 3",
                             @"iPad5,1":@"iPad mini 4",
                             @"iPad5,2":@"iPad mini 4"
                             };
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *mType = models[deviceString] ? : deviceString;
    NSString *system = [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [CHUtil localVersion];
    
    return @{@"system": system, @"m_type": mType, @"app": appName, @"app_v": appVersion};
}


+ (CDeviceType)getDeviceType
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        if (height <= 480) {
            return CDeviceType_4;
        }
        else if (height > 480 && height <= 568)
        {
            return CDeviceType_5;
        }
        else if (height > 568 && height <= 667)
        {
            return CDeviceType_6;
        }
        else if (height > 667 && height <= 736)
        {
            return CDeviceType_6p;
        }
        else
        {
            return CDeviceType_X;
        }
    }else {
        return CDeviceType_pad;
    }
}

+ (BOOL)isUnderIPhone5
{
    return [UIScreen mainScreen].bounds.size.height <= 480;
}

+ (float)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)isIOS9
{
    return [CDInfo systemVersion] >= 9.0;
}

+ (BOOL)isIOS10
{
    return [CDInfo systemVersion] >= 10.0;
}

+ (BOOL)isIOS11
{
    return [CDInfo systemVersion] >= 11.0;
}

@end
