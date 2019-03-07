//
//  DDInvestSegmentVC.h
//  HBD
//
//  Created by hongbaodai on 2017/9/18.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "ViewPagerController.h"
#import "BXInvestmentModel.h"

@interface DDInvestSegmentVC : ViewPagerController

@property (nonatomic, copy) NSString *loanID;
@property (nonatomic, copy) NSString *isBankStr;
@property (nonatomic, assign) NSInteger starTab;
@property (nonatomic, strong) BXInvestmentModel *tempModel;

@end
