//
//  DDCycleView.h
//  DDCycleProgress
//
//  Created by qianjianeng on 16/2/22.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCycleView : UIView

@property (nonatomic, strong) UILabel *label;

- (void)drawProgress:(CGFloat )progress;

@end
