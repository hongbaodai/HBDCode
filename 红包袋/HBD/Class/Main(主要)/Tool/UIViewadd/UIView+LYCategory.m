//
//  UIView+LYCategory.m
//  niuchebang
//
//  Created by liyan on 16/3/11.
//  Copyright © 2016年 牛车网. All rights reserved.
//

#import "UIView+LYCategory.h"

@implementation UIView (LYCategory)

-(UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}
@end
