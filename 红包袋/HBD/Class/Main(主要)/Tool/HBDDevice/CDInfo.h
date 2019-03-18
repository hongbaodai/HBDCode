//
//  IpDeviceInfo.h
//  HBD
//
//  Created by 草帽~小子 on 2019/3/13.
//  Copyright © 2019 李先生. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *common device info 常用硬件信息
 */

typedef NS_ENUM(NSInteger, CDeviceType){
    CDeviceType_4 = 0,
    CDeviceType_5 = 1,
    CDeviceType_6 = 2,
    CDeviceType_6p = 3,
    CDeviceType_X = 4,
    CDeviceType_pad = 5,
};

@interface CDInfo : NSObject

+ (NSDictionary *)clientInfo;
+ (NSString *)deviceUDID;
+ (CDeviceType)getDeviceType;
+ (BOOL)isUnderIPhone5;
+ (float)systemVersion;
+ (BOOL)isIOS9;
+ (BOOL)isIOS10;
+ (BOOL)isIOS11;

@end

NS_ASSUME_NONNULL_END
