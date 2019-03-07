//
//  BXPaymentOneCell.m
//  
//
//  Created by echo on 16/2/25.
//
//

#import "BXPaymentOneCell.h"

@implementation BXPaymentOneCell

+ (instancetype)bxPaymentOneCellWithTableView:(UITableView *)tableView
{
    BXPaymentOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentOneCell"];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"BXPaymentOneCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)makeUIWithReturnMoney:(NSDictionary *)dic
{
    self.upTypeLabel.text = @"本月剩余回款";
    self.downTypeLabel.text = @"今日剩余回款";
    if (dic[@"body"][@"amountMonth"]) {
        self.upAmoutLabel.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:dic[@"body"][@"amountMonth"]]];
    } else {
        self.upAmoutLabel.text = @"￥0.00";
    }
    if (dic[@"body"][@"amountDay"]) {
        self.downAmoutLabel.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:dic[@"body"][@"amountDay"]]];
    } else {
        self.downAmoutLabel.text = @"￥0.00";
    }
}

- (void)makeUIWithDic:(NSDictionary *)dic
{
    self.upTypeLabel.text = @"应还金额";
    self.downTypeLabel.text = @"账户余额";
    if (dic[@"body"][@"repaymentAmout"]) {
        self.upAmoutLabel.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:dic[@"body"][@"repaymentAmout"]]];
    } else {
        self.upAmoutLabel.text = @"￥0.00";
    }
    if (dic[@"body"][@"cash"]) {
        self.downAmoutLabel.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:dic[@"body"][@"cash"]]];
    } else {
        self.downAmoutLabel.text = @"￥0.00";
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

// 四舍五入并保留两位小数
- (NSString *)roundWithInput:(NSString *)input
{
    double i = (double)([input doubleValue] * 100.0 + 0.5);
    int j = (int)i;
    double x = (double)(j / 100.0);
    
    NSString *result = [NSString stringWithFormat:@"%.2lf",x];
    return result;
}

@end
