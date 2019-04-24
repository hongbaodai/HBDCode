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
//@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showArrow;

// 出借金额
@property (weak, nonatomic) IBOutlet UILabel *label1;
// 回款进度
@property (weak, nonatomic) IBOutlet UILabel *label3;
// 本期本息
@property (weak, nonatomic) IBOutlet UILabel *label2;
// 利率
@property (weak, nonatomic) IBOutlet UILabel *label4;
//预期年化
@property (weak, nonatomic) IBOutlet UILabel *label5;

// 底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *separationView;

// 加息
@property (weak, nonatomic) IBOutlet UIView *jiaxiView;
@property (weak, nonatomic) IBOutlet UILabel *jiaxiLab;

+ (instancetype)bxPaymentTwoCellWithTableView:(UITableView *)tableView;

- (void)fillInWithPaymentModel:(BXPaymentModel *)model;

- (void)makeUIWithSelecIndex:(NSInteger)selecIndex index:(NSIndexPath *)index open:(BOOL)open;


@end
