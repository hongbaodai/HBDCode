//
//  InvestHeaderView.h
//  HBD
//
//  Created by hongbaodai on 2018/4/8.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowView.h"

@interface InvestHeaderView : UIView

// 底部红色view距离上面的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewToTopCons;
// 等额本息label
@property (weak, nonatomic) IBOutlet UILabel *dengEBXiLab;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
// 预期年化
@property (weak, nonatomic) IBOutlet UILabel *percentLab;
// 加息小图标
@property (weak, nonatomic) IBOutlet UIImageView *increasesInInterestRates;
// 剩余可投金额
@property (weak, nonatomic) IBOutlet UILabel *loanAmountLab;
// 可用余额
@property (weak, nonatomic) IBOutlet UILabel *useAmountLab;
// 新手标提示语：新手专享Label
@property (weak, nonatomic) IBOutlet UILabel *isNewMarkTipLab;
// 新手标提示语：新手专享View
@property (weak, nonatomic) IBOutlet ShadowView *isNewMarkTipView;


+ (instancetype)investHeaderView;

@end
