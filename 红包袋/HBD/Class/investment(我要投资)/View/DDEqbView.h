//
//  DDEqbView.h
//  HBD
//
//  Created by hongbaodai on 2017/12/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDEqbViewDelegate <NSObject>
@optional
// 点击开通
- (void)didClickNowOpenBtn;

@end

@interface DDEqbView : UIView

@property (nonatomic, weak) id<DDEqbViewDelegate>delegate;

- (instancetype)initWithTarget:(UIViewController *)target;

- (void)show;

@end



