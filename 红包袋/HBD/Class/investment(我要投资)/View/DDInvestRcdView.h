//
//  DDInvestRcdView.h
//  HBD
//
//  Created by hongbaodai on 2017/12/8.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DDInvestRcdBlock)();

@interface DDInvestRcdView : UIView

- (instancetype)initWithFrame:(CGRect)frame isLogin:(BOOL)isLogin;

@property (nonatomic, copy) DDInvestRcdBlock investRcdBlock;

@end
