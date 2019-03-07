//
//  DDInvestRecordVC.h
//  HBD
//
//  Created by hongbaodai on 2017/10/12.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDInSegmentDelegate <NSObject>

@optional
- (void)didClickLoginVc;

@end

@interface DDInvestRecordVC : UIViewController

@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, assign) BOOL islogin;

@property (nonatomic, weak) id<DDInSegmentDelegate>ddelegate;

@end
