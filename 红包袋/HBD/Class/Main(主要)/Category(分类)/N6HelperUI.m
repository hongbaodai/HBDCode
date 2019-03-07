//
//  N6HelperUI.m
//  mobip2p
//
//  Created by Guo Yu on 14-10-22.
//  Copyright (c) 2014年 zkbc. All rights reserved.
//

#import "N6HelperUI.h"

UIColor *UIColorFromRGBValue(UInt32 rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:1.0];
}

UIColor *UIColorFromRGBDecValue(unsigned int r, unsigned int g, unsigned int b) {
    return [UIColor colorWithRed:((float)r)/255.0f
                           green:((float)g)/255.0f
                            blue:((float)b)/255.0f
                           alpha:1.0];
}

NSString * N6GenerateUUID(void) {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef theString = CFUUIDCreateString(NULL, theUUID);
    NSString *unique = [NSString stringWithString:(__bridge id)theString];
    CFRelease(theString);
    CFRelease(theUUID);
    
    return unique;
}