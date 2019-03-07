//
//  DDProgressView.m
//  HBD
//
//  Created by hongbaodai on 2017/9/30.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//



#import "DDProgressView.h"

@interface DDProgressView ()

@end

@implementation DDProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOUR_BTN_BLUE_NEW;
//        [self setNeedsDisplay];
    }
    return self;
}

- (void)setProgressW:(CGFloat)progressW
{
    _progressW = progressW;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
//    //1.创建UIBezierPath
//    UIBezierPath *path = [UIBezierPath bezierPath];
//
//    self.progressH = 50;
////    self.progressW = 300;
//
//    [path moveToPoint:CGPointMake(0, 0)]; //起点
//    [path addLineToPoint:CGPointMake(0, self.progressH)];
//    [path addLineToPoint:CGPointMake(self.progressW, self.progressH)];
//    [path addLineToPoint:CGPointMake(self.progressW-20, 0)];
//    [path addLineToPoint:CGPointMake(0, 0)]; //终点
//
//
//    //    path.lineWidth = 10;//边线粗细
//    //    path.lineCapStyle = kCGLineCapSquare;//线头样式
//    //    path.lineJoinStyle = kCGLineJoinRound; //线头相交的部分样式
//
//    [[UIColor colorWithHexString:COLOUR_YELLOW] setStroke]; //边颜色
//    [[UIColor colorWithHexString:COLOUR_YELLOW] setFill]; //填充颜色
//
//
//    [path stroke];
//    [path fill];
//
////    圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
//    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
//    layer.frame = self.bounds;
//    layer.path = maskPath.CGPath;
//    self.layer.mask = layer;


    self.progressH = 50;
    //1.创建UIBezierPath
    UIBezierPath *maskPath =  [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];

    [maskPath moveToPoint:CGPointMake(0, 0)]; //起点
    [maskPath addLineToPoint:CGPointMake(0, self.progressH)];
    [maskPath addLineToPoint:CGPointMake(self.progressW, self.progressH)];
    [maskPath addLineToPoint:CGPointMake(self.progressW-20, 0)];
    [maskPath addLineToPoint:CGPointMake(0, 0)]; //终点
    [maskPath stroke];
    [maskPath fill];

    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = maskPath.CGPath;

    layer.frame = self.bounds;
    self.layer.mask = layer;
}

/**
 画圆
 @param point 圆心位置
 */
- (void)drawRectYuan:(CGPoint)point {
    // Drawing code
    
    // 第0种：UIView画圆
    UIView *yview = [[UIView alloc] initWithFrame:CGRectMake(self.progressW-20, 0, 8, 8)];
    yview.backgroundColor = [UIColor redColor];
    [self addSubview:yview];
    yview.center = point;
    yview.layer.cornerRadius = 4;
    yview.layer.masksToBounds = YES;
    
    // 第一种：UIBezierPath画圆
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    // 添加圆到path
//    [path addArcWithCenter:point radius:3.0 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
//    // 设置描边宽度
//    //    [path setLineWidth:5.0];
//    //设置颜色（颜色设置也可以放在最上面，只要在绘制前都可以）
//    [[UIColor yellowColor] setStroke];
//    [[UIColor yellowColor] setFill];
//    // 描边和填充
//    [path stroke];
//    [path fill];
    
//    // 第二种：上下文画圆
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//// CGContextAddArc：   CGContextRef：获取上下文，x,y：圆心坐标，radius:半径，startAngle：开始的弧度，endAngle：结束的弧度，clockwise： 0为顺时针，1为逆时针。
//    CGContextAddArc(ctx, self.progressW-20, 0, 10, 0, 360 * (M_PI/180), 0);
//    [[UIColor orangeColor] set];//填充当前绘画区域内的颜色
//    CGContextFillPath(ctx);
}

@end
