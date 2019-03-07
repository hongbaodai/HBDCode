
//
//  ShadowView.m
//  HBD
//
//  Created by hongbaodai on 2018/4/3.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self creatShadow];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super initWithCoder:aDecoder]) {
        [self creatShadow];
    }
    return self;
}

- (instancetype)init
{
    if (self == [super init]) {
        [self creatShadow];
    }
    return self;
}

- (void)creatShadow
{
    self.layer.cornerRadius = 18;
    self.layer.shadowRadius = 3;// 阴影圆角
    self.layer.shadowOpacity = 0.2;// 阴影透明度
    self.layer.shadowOffset = CGSizeMake(2, 2);// 阴影的范围
    self.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
}

@end
