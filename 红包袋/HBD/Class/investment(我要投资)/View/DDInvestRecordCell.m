//
//  DDInvestRecordCell.m
//  HBD
//
//  Created by hongbaodai on 2017/10/18.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestRecordCell.h"
#import "DDInvestRecordModel.h"
#import "NSDate+Setting.h"


@interface DDInvestRecordCell ()
// 提示图片
@property (weak, nonatomic) IBOutlet UIImageView *imageTipview;
// 提示文字
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation DDInvestRecordCell

+ (instancetype)initCellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DDInvestRecordCell";
    DDInvestRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (void)fillDataWithInvestRecordModel:(DDInvestRecordModel *)model indexpath:(NSIndexPath *)index{
    
    _model = model;
    if (model.TZRNC) {
        self.userLab.text = model.TZRNC;
    } else {
        self.userLab.text = @"";
    }
    if (model.JCJE) {
        self.amountLab.text = model.JCJE;
    } else {
        self.amountLab.text = @"";
    }
    if (model.TBSJ) { //2017-11-14 19:43:34
        NSString *daystr = [model.TBSJ substringToIndex:10];
        NSString *timestr = [model.TBSJ substringFromIndex:10];
        
        self.dayLab.text = daystr;
        self.timeLab.text = timestr;

    } else {
        self.dayLab.text = @"";
        self.timeLab.text = @"";
    }


    [self hidden];
    if (index.row != 0 ) return;

    if ([self.only isEqualToString:@"1"]) {
        self.imageTipview.hidden = NO;
        self.imageTipview.image = [UIImage imageNamed:@"onlyOne"];
        self.tipLabel.hidden = NO;
        self.tipLabel.text = @"唯我独尊奖";
    } else if ([self.only isEqualToString:@"2"]) {
        self.imageTipview.hidden = NO;
        self.imageTipview.image = [UIImage imageNamed:@"oneStep"];
        self.tipLabel.hidden = NO;
        self.tipLabel.text = @"一锤定音奖";
    }

}

- (void)hidden
{
    self.imageTipview.hidden = YES;
    self.tipLabel.hidden = YES;
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
