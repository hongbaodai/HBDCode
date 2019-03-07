//
//  DDMyRewardCell.m
//  HBD
//
//  Created by hongbaodai on 16/11/17.
//

#import "DDMyRewardCell.h"
#import "DDMyRewardModel.h"
#import "NSDate+Setting.h"
#import "BXAccountRecords.h"

@interface DDMyRewardCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

/**
 左边
 */
@property (weak, nonatomic) IBOutlet UILabel *fromLab;
@property (weak, nonatomic) IBOutlet UILabel *fromDesLab;

/**
 中间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeDesLab;

/**
 右边
 */
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *stateDesLab;

@end

@implementation DDMyRewardCell
/** 我的奖品-cell */
+ (instancetype)myRewordCellWithTableView:(UITableView *)tableView
{
    DDMyRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDMyRewardCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DDMyRewardCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

/** 我的奖品 */
- (void)setModel:(DDMyRewardModel *)model
{
    if (model) {
        // 奖品来源
        self.fromLab.text = model.HDMC;
        // 获得时间
        self.timeLab.text = [NSDate formmatDateStr:model.PRIZE_TIME];
        if (model.DESCRIBE == nil) {
            model.DESCRIBE = @"";
        }
        
        NSString *titlestr = [NSString stringWithFormat:@"%@ %@", model.SP_NAME, model.DESCRIBE];
        self.titleLab.text = titlestr;
        self.titleLab.textColor = COLOUR_BTN_BLUE_NEW;

        //设置标题文字不同字号
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:titlestr];
        NSRange rangel = [[attString string] rangeOfString:[titlestr substringFromIndex:model.SP_NAME.length]];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:rangel];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:COLOUR_YELLOW] range:rangel];
        
        [self.titleLab setAttributedText:attString];
        
        
        // 0 未激活 1 已激活 2 过期
        if ([model.STATE isEqualToString:@"0"]) {
            self.stateLab.text = @"未激活";
        } else if ([model.STATE isEqualToString:@"1"]) {
            self.stateLab.text = @"已激活";
        } else if ([model.STATE isEqualToString:@"2"]) {
            self.stateLab.text = @"过期";
        } else if ([model.STATE isEqualToString:@"3"]) {
            self.stateLab.text = @"已获得";
        } else {
            self.stateLab.text = @"-";
        }
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

/** 我的资金流水-cell */
+ (instancetype)myAccountRecordsWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"AccountRecordsCell";
    DDMyRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DDMyRewardCell" owner:nil options:nil] lastObject];
        cell.titleLab.textColor = COLOUR_BTN_BLUE_TITELCOLOR;
        cell.fromDesLab.text = @"时间／日期";
        cell.timeDesLab.text = @"存入/支出(元)";
        cell.stateDesLab.text = @"交易类型";
    }
    return cell;
}

/** 我的资金流水 */
- (void)accountRecordsModel:(BXAccountRecords *)finishModel
{
    // 存入/支出金额
    NSString *amount = [NSString stringWithFormat:@"%.2f",[finishModel.JYJE doubleValue]];
    if ([finishModel.ZJLWLX doubleValue] < 1000) {
        self.timeLab.text = [NSString stringWithFormat:@"+ %@",amount];
    } else {
        self.timeLab.text = [NSString stringWithFormat:@"- %@",amount];
    }
    // 交易类型
    self.stateLab.text = finishModel.mtype;
    // 流水明细名称
    self.titleLab.text = finishModel.JKBT;
    
    // 日期
    NSString *tradeTime = [finishModel.JYFSSJ stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *tradeTime1 = [NSDate formmatDateStr:tradeTime];
    self.fromLab.text = tradeTime1;
}


@end
