//
//  HXProgressTool.h
//  test
//
//  Created by hongbaodai on 2017/9/6.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXProgressTool : NSObject

/**
 创建HXProgressTool

 @param inView 父视图
 @return HXProgressTool
 */
+ (instancetype)progressShowInView:(UIView *)inView;

/**
 Progress视图消失
 */
+ (void)progressToolDismiss;

@end
