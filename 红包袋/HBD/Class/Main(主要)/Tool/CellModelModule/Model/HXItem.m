//
//  HXItem.m
//  test
//
//  Created by hongbaodai on 2017/11/13.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXItem.h"

@implementation HXItem

/** 实例初始化HXItem */
- (instancetype)initWithImg:(NSString *)img title:(NSString *)title
{
    if (self = [super init]) {
        self.img = img;
        self.title = title;
//        self.destVC = destVC;
    }
    return self;
}

/** 类初始化HXItem */
+ (instancetype)itemWithTitle:(NSString *)title
{
    return  [[self alloc] initWithImg:nil title:title];
}

@end
