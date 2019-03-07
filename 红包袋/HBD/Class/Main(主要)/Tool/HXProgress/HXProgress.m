
//
//  HXProgress.m
//  test
//
//  Created by hongbaodai on 2017/9/6.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXProgress.h"

@interface HXProgress()
{
    // 显示view
    UIImageView *imageView;
    // 动态图数量
    NSInteger imgNum;
    // 动态图名字
    NSString *imgStr;
    // 定时
    NSTimer *timer;
    NSInteger num;
}

@end

@implementation HXProgress

/** 创建HXProgress */
+ (instancetype)hxProgressWithFrame:(CGRect)frame ImgNum:(NSUInteger )imgNum imgStr:(NSString *)str
{
    HXProgress *hx = [[HXProgress alloc] initWithFrame:frame];
    [hx makeUIWithImgNum:imgNum imgStr:str];
    return hx;
}

/** 设置UI */
- (void)makeUIWithImgNum:(NSInteger)nums imgStr:(NSString *)str
{
    imgNum = nums;
    imgStr = str;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect frame = self.frame;
    frame.size.width = frame.size.height = 50;
    imageView.frame = frame;
    imageView.center = self.center;
    [self addSubview:imageView];
    
    __weak HXProgress *WeakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [WeakSelf timerStar];
    }];
}

/** 加载定时器 */
- (void)timerStar
{
    num ++;
    
    NSString *str = [NSString stringWithFormat:@"%@%ld",imgStr,(long)num];
    imageView.image = [UIImage imageNamed:str];
    if (num >= imgNum) {
        num = 0;
    }

}

/** 消失 */
- (void)dismissProgress
{
    imageView.hidden = YES;
    [timer invalidate];
    timer = nil;
    imgStr = nil;
    
    [self removeFromSuperview];
}

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
}

@end
