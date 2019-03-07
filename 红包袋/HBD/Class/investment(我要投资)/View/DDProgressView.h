//
//  DDProgressView.h
//  HBD
//
//  Created by hongbaodai on 2017/9/30.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DDInvestDelegate <NSObject>

@end

@interface DDProgressView : UIView

@property (nonatomic, assign) CGFloat progressW;
@property (nonatomic, assign) CGFloat progressH;

@end
