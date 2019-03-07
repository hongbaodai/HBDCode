
//  LADAccoutTVCell.m
//  HBD
//
//  Created by hongbaodai on 2018/4/4.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "LADAccoutTVCell.h"

@interface LADAccoutTVCell()


@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end


@implementation LADAccoutTVCell

+(instancetype)creatLADAccoutTVCellWithTableView:(UITableView *)tableview
{
    LADAccoutTVCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LADAccoutTVCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LADAccoutTVCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUpUI];
    }
    return cell;
}

- (void)setUpUI
{
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"ADD9E7"].CGColor;
}

- (void)setModel:(LADAccoutModel *)model
{
    self.leftLabel.text = model.YHMC;
    NSString *dbStr = @"";
//    if ([model.DBXE isEqualToString:@"无限额"]) {
        dbStr = [NSString stringWithFormat:@"单笔%@",model.DBXE];
//    } else {
//        dbStr = [NSString stringWithFormat:@"单笔%@元",model.DBXE];
//    }
    NSString *mrStr = @"";
//    if ([model.MRXE isEqualToString:@"无限额"]) {
        mrStr = [NSString stringWithFormat:@"日累计%@",model.MRXE];
//    } else {
//        mrStr = [NSString stringWithFormat:@"日累计%@元",model.MRXE];
//    }
    self.rightLabel.text = [NSString stringWithFormat:@"%@,%@",dbStr, mrStr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
