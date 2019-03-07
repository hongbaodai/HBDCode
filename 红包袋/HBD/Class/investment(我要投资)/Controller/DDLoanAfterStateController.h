//
//  DDLoanAfterStateController.h
//  HBD
//
//  Created by hongbaodai on 17/1/19.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDStateType){
    DDStateTypeSuccess= 1,           // 成功
    DDStateTypeFaild = 2,           // 失败
    DDStateTypeThree = 3,         // 备用
};


@interface DDLoanAfterStateController : BaseNormolViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) IBOutlet HXButton *stateBtn;
@property (nonatomic, assign) DDStateType stateStyle;

@end
