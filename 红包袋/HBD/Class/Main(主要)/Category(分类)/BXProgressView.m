//
//  BXProgressView.m
//  sinvo
//
//  Created by 李先生 on 15/4/1.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXProgressView.h"

@interface BXProgressView ()


@end

@implementation BXProgressView


- (void)setProgressViewLab:(CGFloat)progressViewLab
{
    _progressViewLab = progressViewLab;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%.02f%%", progressViewLab * 100];
    
    // 重新绘制视图
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    /**
     1. 中心点坐标
     2. 半径
     3. 起始角度
     4. 结束角度
     5. 是否顺时针
     */
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat r = (rect.size.width > rect.size.height) ? rect.size.height * 0.5 : rect.size.width * 0.5;
    r -= 3;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = self.progressViewLab * 2 * M_PI + startAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    // 线宽
    path.lineWidth = 3.0;
    path.lineCapStyle = kCGLineCapRound;
    // 颜色
    [COLOUR_BTN_BLUE set];
    
    [path stroke];
}


@end
