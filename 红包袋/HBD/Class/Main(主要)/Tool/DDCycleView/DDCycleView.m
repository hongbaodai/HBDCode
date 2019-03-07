//
//  DDCycleView.m
//  DDCycleProgress
//
//  Created by qianjianeng on 16/2/22.
//  Copyright © 2016年 SF. All rights reserved.
//

// 进度颜色
#define pColor        [UIColor redColor]
// 进度背景颜色
#define pBgColor      [UIColor groupTableViewBackgroundColor]

#define pCycleW       7

// 弧度转角度
#define RADIANS_TO_DEGREES(radians)    ((radians) * (180.0 / M_PI))
// 角度转弧度
#define DEGREES_TO_RADIANS(angle)      ((angle) / 180.0 * M_PI)


#import "DDCycleView.h"
@interface DDCycleView ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *backLayer;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) CALayer *gradientLayer;

@end
@implementation DDCycleView

- (void)drawRect:(CGRect)rect {
    
    [self drawNewProgress];
    
}

- (void)drawProgress:(CGFloat )progress
{
//    _progress = progress;
    _progress = 80;
    [_progressLayer removeFromSuperlayer];
    [_gradientLayer removeFromSuperlayer];
    [self setNeedsDisplay];



    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:10];
    _progressLayer.strokeEnd = progress/100.0;
    [CATransaction commit];

//    _percent = percent;



}


- (void)drawNewProgress
{
    CGPoint center = CGPointMake(self.width_/2, self.width_/2);
    CGFloat radius = self.width_/2;
    CGFloat startA = DEGREES_TO_RADIANS(150);  //设置进度条起点位置
    CGFloat endA = DEGREES_TO_RADIANS(30);  //设置进度条终点位置
    CGFloat nowA = DEGREES_TO_RADIANS(150) + M_PI * 2/3*2 * _progress;  //当前进度

    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  =  [pBgColor CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = pCycleW;
    _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES].CGPath;
    _progressLayer.strokeEnd = 0;

    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, self.width_/2, self.height_);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:231.0/255.0f green:56.0/255.0f blue:61.0/255.0f alpha:1] CGColor],(id)[[UIColor colorWithRed:245.0/255.0f green:105.0/255.0f blue:112.0/255.0f alpha:1] CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:gradientLayer1];

    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    [gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
    gradientLayer2.frame = CGRectMake(self.width_/2, 0, self.width_/2, self.height_);
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:227.0/255.0f green:227.0/255.0f blue:227.0/255.0f alpha:1] CGColor], nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];



    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

- (void)drawCycleProgress
{

    CGPoint center = CGPointMake(self.width_/2, self.width_/2);
    CGFloat radius = self.width_/2;
    CGFloat startA = DEGREES_TO_RADIANS(150);  //设置进度条起点位置
    CGFloat endA = DEGREES_TO_RADIANS(30);  //设置进度条终点位置
    CGFloat nowA = DEGREES_TO_RADIANS(150) + M_PI * 2/3*2 * _progress;  //当前进度
    
//    CGPoint center = CGPointMake(self.width_/2, self.width_/2);
//    CGFloat radius = self.width_/2;
//    CGFloat startA = DEGREES_TO_RADIANS(135);  //设置进度条起点位置
//    CGFloat endA = DEGREES_TO_RADIANS(45);  //设置进度条终点位置
//    CGFloat nowA = DEGREES_TO_RADIANS(135) + (M_PI * 2 +M_PI)/2 * _progress;  //当前进度
    
    
    //创建背景圆环
    _backLayer = [CAShapeLayer layer];
    _backLayer.frame = self.bounds;
    _backLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _backLayer.strokeColor = [pBgColor CGColor]; //渲染颜色
    _backLayer.opacity = 1; //背景颜色的透明度
    _backLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _backLayer.lineWidth = pCycleW;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _backLayer.path =[path CGPath];
    
    [self.layer addSublayer:_backLayer];
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    //创建进度圆环
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [COLOUR_BTN_BLUE_NEW CGColor];//指定path的渲染颜色    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = pCycleW;//线的宽度
    UIBezierPath *pathpro = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:nowA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[pathpro CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:_progressLayer];
    
    
    [self changeGradientLayer];
}

////生成渐变色
- (void)changeGradientLayer {
    
    _gradientLayer = [CALayer layer];

    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(-10, -10, self.bounds.size.width + 15 , self.bounds.size.height + 15);    // 分段设置渐变色
    leftLayer.locations = @[@0.3, @0.7];
    leftLayer.colors = @[(id)[UIColor colorWithRed:245.0/255.0f green:105.0/255.0f blue:112.0/255.0f alpha:1].CGColor, (id)[UIColor colorWithRed:231.0/255.0f green:56.0/255.0f blue:61.0/255.0f alpha:1].CGColor];
    [_gradientLayer addSublayer:leftLayer];

    //右侧渐变色
//    CAGradientLayer *rightLayer = [CAGradientLayer layer];
//    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
//    rightLayer.locations = @[@0.3, @0.9, @1];
//    rightLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
//    [_gradientLayer addSublayer:rightLayer];

    [self.layer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
}

- (UILabel *)label
{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self addSubview:label];
        _label = label;
    }
    return _label;
}



@end
