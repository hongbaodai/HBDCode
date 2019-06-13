//
//  HXInvestMentRecordTVCell.m
//  HBD
//
//  Created by hongbaodai on 2017/9/29.
//

#import "HXInvestMentRecordTVCell.h"
#import "NSDate+Setting.h"

@interface HXInvestMentRecordTVCell()

/** 名字 */
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
/** 出借金额 */
@property (weak, nonatomic) IBOutlet UILabel *investmentAmountLabel;
/** 约定年化利率 */
@property (weak, nonatomic) IBOutlet UILabel *annualEarningsLabel;
/** 出借时间 */
@property (weak, nonatomic) IBOutlet UILabel *investmentTimeLabel;
/** 出借时间描述 */
@property (weak, nonatomic) IBOutlet UILabel *investmentTimeDesLabel;

@end

@implementation HXInvestMentRecordTVCell

/** 创建HXInvestMentRecordTVCell */
+ (instancetype)hxInvestMentRecordTVCell:(UITableView *)tableView type:(AssetType)assetType
{
    static NSString *idenfier = @"hxInvestMentRecordTVCell";
    HXInvestMentRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HXInvestMentRecordTVCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeStatusUIWith:assetType];
    }
    return cell;
}
/** 处理各种状态 */
- (void)makeStatusUIWith:(AssetType)assetType
{
    switch (assetType) {
        case AssetTypeRecovery:
            self.arrowImageView.hidden = NO;
            break;
            
        case AssetTypeDone:
            self.investmentTimeDesLabel.text = @"净收益（元）";
            self.investmentTimeLabel.textColor = kColor_sRGB(236, 116, 96);
            
            break;
        default:
            break;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

/** 回款中 */
- (void)makeModel:(BXMyaccountInvestThreeModel *)recordThreeModel
{
    // 约定年化利率
    if (recordThreeModel.JXLL == nil || [recordThreeModel.JXLL isEqualToString:@""] || [recordThreeModel.JXLL isEqualToString:@"0"]) {
        self.annualEarningsLabel.text = [NSString stringWithFormat:@"%g%%",[recordThreeModel.NHLL doubleValue]];
    } else {
        self.annualEarningsLabel.text = [NSString stringWithFormat:@"%g%%+%@%%",[recordThreeModel.NHLL doubleValue], recordThreeModel.JXLL];
    }

    // 标题
    NSString *title =[NSString stringWithFormat:@"%@",recordThreeModel.JKBT];
    self.titleNameLabel.text = title;
    
    self.investmentAmountLabel.text = [NSString stringWithFormat:@"%.2lf",[recordThreeModel.JCJE doubleValue]];
    
    // 出借时间
    self.investmentTimeLabel.text = [NSDate formmatDateStr:recordThreeModel.TBSJ];
}

/** 筹款中 */
- (void)myAccountInvestRecordWithModel:(BXMyAccountInvestmentModel *)accountModel
{
    //年化利率
    if (accountModel.JXLL == nil || [accountModel.JXLL isEqualToString:@""] || [accountModel.JXLL isEqualToString:@"0"]) {
        self.annualEarningsLabel.text = [NSString stringWithFormat:@"%g%%",[accountModel.NHLL doubleValue]];
    } else {
        self.annualEarningsLabel.text = [NSString stringWithFormat:@"%g%%+%@%%",[accountModel.NHLL doubleValue], accountModel.JXLL];
    }
    
    //标题
    self.titleNameLabel.text = accountModel.JKBT;
    self.investmentAmountLabel.text = [NSString stringWithFormat:@"%.2lf",[accountModel.JCJE doubleValue]];
    
    //出借时间
    NSString *tradeTime = [accountModel.TBSJ stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSString *time = [NSDate formmatDateStr:tradeTime];
    self.investmentTimeLabel.text = time.length == 0 ? tradeTime :time;
}

/** 已完成 */
- (void)accountInvestRecordThreeModel:(BXInvestFinishModel *)finishModel
{
    // 利率
    if (finishModel.JXLL == nil || [finishModel.JXLL isEqualToString:@""] || [finishModel.JXLL isEqualToString:@"0"]) {
        self.annualEarningsLabel.text = [NSString stringWithFormat:@"%g%%",[finishModel.NHLL doubleValue]];
    } else {
        self.annualEarningsLabel.text = [NSString stringWithFormat:@"%g%%+%@%%",[finishModel.NHLL doubleValue], finishModel.JXLL];
    }
    
    // 标题
    self.titleNameLabel.text = finishModel.JKBT;

    if ([finishModel.JCJE doubleValue] >= 1000000.0) {
        self.investmentAmountLabel.text = [NSString stringWithFormat:@"%.2lf",[finishModel.JCJE doubleValue]];
    } else {
        self.investmentAmountLabel.text = [NSString stringWithFormat:@"%.2lf",[finishModel.JCJE doubleValue]];
    }
    // 净收益
    self.investmentTimeLabel.text = [NSString stringWithFormat:@"%.2lf",[finishModel.jsy doubleValue]];
}


@end
