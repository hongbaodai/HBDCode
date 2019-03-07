//
//  DDUpgradeStopView.h
//  HBD
//
//  Created by hongbaodai on 2017/8/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDupgradeStopDelegate <NSObject>

@optional
/**
 点击取消按钮
 */
- (void)didClickCancelStopBtn;

/**
 点击升级按钮
 */
- (void)didClickUpgradeStopBtn;

@end

@interface DDUpgradeStopView : UIView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *upgradeBtn;

@property (nonatomic, weak) id<DDupgradeStopDelegate>delegate;

@end
