//
//  BXPaymentTwoCell.h
//  
//
//  Created by echo on 16/2/25.
//
//  回款日历下方cell

#import <UIKit/UIKit.h>
#import "BXPaymentModel.h"

@interface BXPaymentTwoCell : UITableViewCell

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 类型图标
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
// 右侧金额
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
// 投资金额
@property (weak, nonatomic) IBOutlet UILabel *label1;
// 回款进度
@property (weak, nonatomic) IBOutlet UILabel *label2;
// 本期本息
@property (weak, nonatomic) IBOutlet UILabel *label3;
// 利率
@property (weak, nonatomic) IBOutlet UILabel *label4;

// 底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *separationView;


- (void)fillInWithPaymentModel:(BXPaymentModel *)model;

@end
