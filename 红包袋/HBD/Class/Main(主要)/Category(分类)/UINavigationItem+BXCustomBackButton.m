//
//  UINavigationItem+BXCustomBackButton.m
//  HBD
//
//  Created by echo on 15/9/21.
//  Copyright © 2015年 caomaoxiaozi All rights reserved.
//

#import "UINavigationItem+BXCustomBackButton.h"
#import <objc/runtime.h>

@implementation UINavigationItem (BXCustomBackButton)

+ (void)load{
    static dispatch_once_t onceToKen;
    dispatch_once(&onceToKen, ^{
        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButton_backBarbuttonItem));
        method_exchangeImplementations(originalMethodImp, destMethodImp);
    });
}

static char kCustomBackButtonKey;
-(UIBarButtonItem *)myCustomBackButton_backBarbuttonItem{
    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
    if (item) {
        return item;
    }
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:NULL];
        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}


- (void)dealloc {
    objc_removeAssociatedObjects(self);
}

@end
