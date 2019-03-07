//
//  DDCoverView.h
//  HBD
//
//  Created by hongbaodai on 2017/8/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDUpgradeView.h"
#import "DDUpgradeStopView.h"


typedef NS_ENUM(NSUInteger, DDViewStyle) {
    DDViewStyleUpgradeView,
    DDViewStyleUpgradeStopView
};

@protocol DDCoverViewDelegate <NSObject>

@optional
/**
 账户升级
 */
- (void)didClickZhsjBtn;

/**
 停服升级
 */
- (void)didClickTfsjBtn;

@end

@interface DDCoverView : UIView <DDUpgradeDelegate, DDupgradeStopDelegate>

@property (nonatomic, strong) DDUpgradeView *upgradeView;
@property (nonatomic, strong) DDUpgradeStopView *upgradeStopView;
@property (nonatomic, assign) DDViewStyle viewStyle;

@property (nonatomic, weak) id<DDCoverViewDelegate>delegate;

- (void)removeUpgradeView;

@end
