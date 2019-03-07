//
//  UIView+SLAddition.h
//  SLAddition
//
//  Created by shicuf on 15/1/24
//  Copyright (c) 2015年 shicuf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SLAddition)
@property (nonatomic, assign) CGFloat x_;
@property (nonatomic, assign) CGFloat y_;
@property (nonatomic, assign) CGFloat centerX_;
@property (nonatomic, assign) CGFloat centerY_;
@property (nonatomic, assign) CGFloat width_;
@property (nonatomic, assign) CGFloat height_;
@property (nonatomic, assign) CGSize size_;
@property (assign, nonatomic) CGPoint origin_;
#pragma 设置圆角
- (void) setRoundBorder;
- (void) setLayoutMarginsZero;

@end
