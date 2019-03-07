//
//  DDChooseHbCell.h
//  HBD
//
//  Created by hongbaodai on 2017/11/1.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXCouponModel.h"

@interface DDChooseHbCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *limitLab;
@property (weak, nonatomic) IBOutlet UILabel *styleLab;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *hbBackImg;

@property (nonatomic, strong) BXCouponModel *model;
@property(assign,nonatomic)BOOL selectState;//选中状态

- (void)fillWithCouponModel:(BXCouponModel *)model;

@end
