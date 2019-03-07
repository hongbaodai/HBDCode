//
//  NSString+URLEncoding.m
//  HBD
//
//  Created by echo on 16/8/10.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)bx_URLEncodedString{
    CFStringRef encodeRef = CFURLCreateStringByAddingPercentEscapes(
                                                                     kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     NULL,
                                                                     (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                     kCFStringEncodingUTF8);
    
    return (NSString *)CFBridgingRelease(encodeRef);
}

@end
