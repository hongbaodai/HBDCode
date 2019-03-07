//
//  DDAccount.m
//  HBD
//
//  Created by hongbaodai on 16/8/17.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

#import "DDAccount.h"
#import <objc/message.h>

@interface DDAccount()

@end

@implementation DDAccount

static  DDAccount*sharedAccount;

- (NSString *)filePath
{
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath = [temp stringByAppendingPathComponent:@"acout.cout"];
    return filePath;
}

singletonImplementation(DDAccount)
/** 归档 */
- (void)encodeAccout
{
    [NSKeyedArchiver archiveRootObject:self toFile:[self filePath]];
}

/** 解档 */
- (instancetype)coderAccout
{
    DDAccount *valus = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    return valus;
}

/** 解档 */
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        unsigned int cout;
        Ivar *ivars = class_copyIvarList([self class], &cout);
        
        for (int i = 0; i < cout; i ++) {
            Ivar ivar = ivars[i];
            const char *str = ivar_getName(ivar);
            NSString *name = [NSString stringWithUTF8String:str];
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
        free(ivars);
    }
    return self;
}
/** 归档 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int cout;
    Ivar *ivars = class_copyIvarList([self class], &cout);
    for (int i = 0; i < cout; i ++) {
        Ivar ivar = ivars[i];
        const char *str = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:str];
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
    }
    free(ivars);
}

@end
