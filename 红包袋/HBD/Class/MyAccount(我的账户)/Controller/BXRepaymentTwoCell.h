//
//  BXRepaymentTwoCell.h
//  
//
//  Created by echo on 16/2/25.
//
//  还款日历下方cell

#import <UIKit/UIKit.h>
#import "BXRepaymentModel.h"

@interface BXRepaymentTwoCell : UITableViewCell
// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 类型图标
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
// 右侧金额
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
// 还款进度
@property (weak, nonatomic) IBOutlet UILabel *label1;
// 应交滞纳金
@property (weak, nonatomic) IBOutlet UILabel *label2;
// 应还手续费
@property (weak, nonatomic) IBOutlet UILabel *label3;
// 应还本息
@property (weak, nonatomic) IBOutlet UILabel *label4;
// 应交罚息
@property (weak, nonatomic) IBOutlet UILabel *label5;
// 底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *separationView;

+ (instancetype)bxRepaymentTwoCellWithTableView:(UITableView *)tableView;


- (void)fillInWithRepaymentModel:(BXRepaymentModel *)model;

- (void)makeCellWithIndex:(NSIndexPath *)index selecIndex:(NSInteger)selecIndex open:(BOOL)open;


@end
