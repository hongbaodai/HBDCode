//
//  DDCoverView.m
//  HBD
//
//  Created by hongbaodai on 2017/8/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDCoverView.h"
#import "AppUtils.h"

@implementation DDCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //设置弹出视图
        self.bounds = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *bizStr = [defaults objectForKey:@"BIZUPGRADE"];
        
        if ([bizStr isEqualToString:@"1"]) {
            //添加视图
            _upgradeStopView = [[DDUpgradeStopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 290)];
            _upgradeStopView.center = self.center;
            _upgradeStopView.centerY_ = _upgradeStopView.centerY_ -50;
            self.upgradeStopView.backgroundColor = [UIColor whiteColor];
            self.upgradeStopView.delegate = self;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.windowLevel = UIWindowLevelNormal;
            
            [window addSubview:self];
            [window addSubview:self.upgradeStopView];
            
        } else if ([bizStr isEqualToString:@"2"]){
            self.upgradeView = [[NSBundle mainBundle] loadNibNamed:@"DDUpgradeView" owner:self options:nil].lastObject;
            self.upgradeView.center = self.center;
            self.upgradeView.delegate = self;
            
            self.upgradeView.layer.cornerRadius = 5;
            self.upgradeView.layer.masksToBounds = YES;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.windowLevel = UIWindowLevelNormal;
            
            [window addSubview:self];
            [window addSubview:self.upgradeView];
        }
        
    }
    return self;
}


- (void)removeUpgradeView {
    
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
        weakSelf.upgradeView.alpha = 0;
        weakSelf.upgradeStopView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.upgradeView removeFromSuperview];
        [weakSelf.upgradeStopView removeFromSuperview];
    }];
}

#pragma mark - DDUpgradeDelegate
- (void)didClickUpgradeBtn {
    
    [self.delegate didClickZhsjBtn];
}

- (void)didClickUpgradeStopBtn {
    
    [self.delegate didClickTfsjBtn];
    
    // 清除缓存
    [AppUtils clearLoginDefaultCachesAndCookieImgCaches:YES];
}




@end
