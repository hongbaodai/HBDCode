//
//  TopButton.m
//  HBD
//
//  Created by hongbaodai on 2018/9/7.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "TopButton.h"

@implementation TopButton


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];

    }
    return self;
}

- (void)setUI
{
    [self setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];

    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

@end
