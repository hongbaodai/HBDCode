
//
//  HXProgressTool.m
//  test
//
//  Created by hongbaodai on 2017/9/6.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXProgressTool.h"
#import "HXProgress.h"

@interface HXProgressTool()
{
    NSInteger imgNum;
    NSString *imgStr;
}
// 显示动态图
@property (nonatomic, strong) HXProgress *progress;

@end

@implementation HXProgressTool

+ (HXProgressTool*)sharedView
{
    static dispatch_once_t once;
    
    static HXProgressTool *sharedView;
    dispatch_once(&once, ^{ sharedView = [[self alloc] init]; });
    return sharedView;
}

/** 创建HXProgressTool */
+ (instancetype)progressShowInView:(UIView *)inView
{
    HXProgressTool *tool = [HXProgressTool sharedView];
    [tool makeUIInView:inView];
    return tool;
}

/** 设置数据 */
- (void)makeData
{
    NSInteger cout = 5;
    imgStr = @"PlatformData_icon";
    imgNum = cout;
}

/** 设置UI */
- (void)makeUIInView:(UIView *)inView
{
    [self makeData];
    
    CGRect frame = inView.frame;
    frame.origin.y = 0;
    self.progress = [HXProgress hxProgressWithFrame:frame ImgNum:imgNum imgStr:imgStr];
    [inView addSubview:self.progress];
}

/** Progress视图消失 */
+ (void)progressToolDismiss
{
    HXProgressTool *tool = [HXProgressTool sharedView];
    [tool.progress dismissProgress];
}

@end
