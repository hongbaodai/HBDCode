//
//  HBDImmediateTapGradientView.m
//  HBD
//
//  Created by 草帽~小子 on 2019/6/5.
//  Copyright © 2019 李先生. All rights reserved.
//

#import "HBDGradientTapView.h"

@interface HBDGradientTapView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation HBDGradientTapView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpViews];
}

- (void)setUpViews {
    [self.layer addSublayer:self.gradientLayer];
    [self addSubview:self.projectStatuLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.cornerRadius = self.frame.size.height / 2;
    self.gradientLayer.masksToBounds = YES;
    self.projectStatuLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)tap:(UITapGestureRecognizer *)sender {
    if (self.gradientTapAction) {
        self.gradientTapAction();
    }
}

- (void)timerAction:(NSTimer *)time {
    self.projectStatuLab.text = @"";
}

- (void)timeStart {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)timeFinish {
    [self.timer setFireDate:[NSDate distantFuture]];
    self.projectStatuLab.text = @"立即开始";
}

- (UILabel *)projectStatuLab {
    if (_projectStatuLab == nil) {
        _projectStatuLab = [[UILabel alloc] init];
        _projectStatuLab.textColor = [UIColor whiteColor];
        _projectStatuLab.font = FONT_15;
        _projectStatuLab.textAlignment = NSTextAlignmentCenter;
        _projectStatuLab.text = @"立即出借";
    }
    return _projectStatuLab;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        //渐变的分割线位置默认0-1
        _gradientLayer.locations = @[@(0.0),@(1.0)];
    }
    return _gradientLayer;
}

//- (UIFont *)font {
//    if (_font == nil) {
//        _font = [UIFont systemFontOfSize:15];
//    }
//    return _font;
//}

@end
