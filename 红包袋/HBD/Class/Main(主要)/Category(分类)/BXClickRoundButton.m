//
//  BXClickRoundButton.m
//  sinvo
//
//  Created by 李先生 on 15/4/15.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXClickRoundButton.h"

@implementation BXClickRoundButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer setCornerRadius:5];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}
@end
