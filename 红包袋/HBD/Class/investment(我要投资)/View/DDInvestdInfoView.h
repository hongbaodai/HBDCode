//
//  DDInvestdInfoView.h
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowView.h"

@interface DDInvestdInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *percentLab;
@property (weak, nonatomic) IBOutlet UIImageView *increasesInInterestRates;
// 中间竖线的位置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCenterXConstaint;

// 等额本息label
@property (weak, nonatomic) IBOutlet UILabel *dengEBXLabel;

@property (weak, nonatomic) IBOutlet UILabel *limitLab;
@property (weak, nonatomic) IBOutlet UILabel *qtamountLab;
@property (weak, nonatomic) IBOutlet UILabel *allAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *nowAmountLab;

// 新手标提示view
@property (weak, nonatomic) IBOutlet ShadowView *markView;
// 新手标提示文字
@property (weak, nonatomic) IBOutlet UILabel *markTextLab;

+ (instancetype)investmentDetailInfoView;

@end
