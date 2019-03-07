//
//  DDUpgradeView.m
//  HBD
//
//  Created by hongbaodai on 2017/8/3.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDUpgradeView.h"

@implementation DDUpgradeView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.upgradeBtn.layer.cornerRadius = 3;
    self.upgradeBtn.layer.masksToBounds = YES;
    [self.upgradeBtn addTarget:self action:@selector(upgradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.knowsLab.text = @"1、红包袋老用户，需在3个月将旧资金账户(联动优势)中的余额提现。\n2、老用户完成资金账户升级后，未到账的待收本息到期后会自动转到新资金账户中。\n3、用户在旧资金账户提现(联动优势)，免提现手续费。";
    
}
- (void)cancelBtnClick {
    [self.delegate didClickCancelBtn];
}
- (void)upgradeBtnClick {

    [self.delegate didClickUpgradeBtn];
}

@end
