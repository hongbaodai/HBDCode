//
//  DDUpgradeView.h
//  HBD
//
//  Created by hongbaodai on 2017/8/3.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^DDUpgradeBlock)();
@protocol DDUpgradeDelegate <NSObject>

@optional
/**  
    点击取消按钮
 */
- (void)didClickCancelBtn;

/**
 点击升级按钮
 */
- (void)didClickUpgradeBtn;

@end

@interface DDUpgradeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *upgradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *knowsLab;
//@property (nonatomic, copy) DDUpgradeBlock upgradeBlock;
@property (nonatomic, weak) id<DDUpgradeDelegate> delegate;

@end
