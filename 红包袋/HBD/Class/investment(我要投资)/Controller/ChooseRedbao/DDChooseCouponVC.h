//
//  DDChooseCouponVC.h
//  HBD
//
//  Created by hongbaodai on 2018/3/5.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "BaseNormolViewController.h"
#import "BXCouponModel.h"

@protocol DDChooseCouponDelegate <NSObject>

@optional
- (void)chooseCouponSureSingleHb:(BXCouponModel *)singleHb AndHbID:(NSInteger )hbID;


@end

@interface DDChooseCouponVC : BaseNormolViewController

@property (nonatomic, strong) NSArray *singleCouponArr;
@property (nonatomic, assign) NSInteger singleIndex;
@property (nonatomic, strong) NSArray *availbleHbArr;
@property (nonatomic, copy) NSString *investMoney;
@property (nonatomic, strong) BXCouponModel *singleModel;
@property (nonatomic, assign) double dikouNum;

@property (nonatomic, weak) id<DDChooseCouponDelegate> delegate;

@end
