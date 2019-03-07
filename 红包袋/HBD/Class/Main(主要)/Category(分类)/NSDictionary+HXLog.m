//
//  NSDictionary+HXLog.m
//  HBD
//
//  Created by hongbaodai on 2018/10/18.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "NSDictionary+HXLog.h"

@implementation NSDictionary (HXLog)
#if DEBUG
- (NSString *)descriptionWithLocale:(nullable id)locale{

    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}
#endif

@end
