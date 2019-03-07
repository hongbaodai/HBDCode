//
//  DDInvestListCell.h
//  HBD
//
//  Created by hongbaodai on 2017/9/28.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXInvestmentModel.h"
@class DDProgressView;

typedef void(^DDInvestBlock)();

@interface DDInvestListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *pecentLab;
@property (weak, nonatomic) IBOutlet UIImageView *IncreasesInInterestRates;


@property (weak, nonatomic) IBOutlet UILabel *limitdayLab;
@property (weak, nonatomic) IBOutlet UILabel *limitdayUnitLab;//单位

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *amountUnitLab;

//@property (weak, nonatomic) IBOutlet UILabel *progressLab;

// 等额本息图标
@property (weak, nonatomic) IBOutlet UIImageView *dengEBXIma;

@property (weak, nonatomic) IBOutlet UILabel *activityLab; //新手标
@property (weak, nonatomic) IBOutlet UIImageView *activityImg; // 右边的

@property (nonatomic, strong) DDProgressView *progresVeiw;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UIView *probackView;

@property (nonatomic, assign) CGFloat blueW;;

@property (nonatomic, strong) BXInvestmentModel *model;

@property (nonatomic, copy) DDInvestBlock investBlock;

/// ---------------倒计时----------------
/// 可能有的不需要倒计时,如倒计时时间已到, 或者已经过了
@property (nonatomic, assign) BOOL needCountDown;
/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)();


+ (instancetype)investListCellWithTableView:(UITableView *)tableView;
- (void)fillDataWithInvestList:(BXInvestmentModel *)model;

@end
