//
//  HXProgress.h
//  test
//
//  Created by hongbaodai on 2017/9/6.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXProgress : UIView

/**
 创建HXProgress
 
 @param frame frame
 @param imgNum 动画数量
 @param str 动画名字
 @return HXProgress
 */
+ (instancetype)hxProgressWithFrame:(CGRect)frame ImgNum:(NSUInteger )imgNum imgStr:(NSString *)str;

/**
 消失
 */
- (void)dismissProgress;

@end
