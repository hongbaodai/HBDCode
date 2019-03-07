//
//  UIView+SLAddition.m
//  SLAddition
//
//  Created by shicuf on 15/1/24.
//  Copyright (c) 2015年 shicuf. All rights reserved.
//

#import "UIView+SLAddition.h"

@implementation UIView (SLAddition)

- (void)setX_:(CGFloat)x_
{
    CGRect frame = self.frame;
    frame.origin.x = x_;
    self.frame = frame;
}

- (CGFloat)x_
{
    return self.frame.origin.x;
}

- (void)setY_:(CGFloat)y_
{
    CGRect frame = self.frame;
    frame.origin.y = y_;
    self.frame = frame;
}

- (CGFloat)y_
{
    return self.frame.origin.y;
}

- (void)setCenterX_:(CGFloat)centerX_
{
    CGPoint center = self.center;
    center.x = centerX_;
    self.center = center;
}

- (CGFloat)centerX_
{
    return self.center.x;
}

- (void)setCenterY_:(CGFloat)centerY_
{
    CGPoint center = self.center;
    center.y = centerY_;
    self.center = center;
}

- (CGFloat)centerY_
{
    return self.center.y;
}

- (void)setWidth_:(CGFloat)width_
{
    CGRect frame = self.frame;
    frame.size.width = width_;
    self.frame = frame;
}

- (CGFloat)width_
{
    return self.frame.size.width;
}

- (void)setHeight_:(CGFloat)height_
{
    CGRect frame = self.frame;
    frame.size.height = height_;
    self.frame = frame;
}

- (CGFloat)height_
{
    return self.frame.size.height;
}

- (void)setSize_:(CGSize)size_
{
    CGRect frame = self.frame;
    frame.size = size_;
    self.frame = frame;
}

- (CGSize)size_
{
    return self.frame.size;
}

- (void)setOrigin_:(CGPoint)origin_
{
    CGRect frame = self.frame;
    frame.origin = origin_;
    self.frame = frame;
}


- (CGPoint)origin_
{
    return self.frame.origin;
}

#pragma 圆角
- (void) setRoundBorder
{
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.2f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma margins zero
- (void) setLayoutMarginsZero{
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
