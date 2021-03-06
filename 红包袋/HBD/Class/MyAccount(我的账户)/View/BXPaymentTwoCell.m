//
//  BXPaymentTwoCell.m
//  
//
//  Created by echo on 16/2/25.
//
//

#import "BXPaymentTwoCell.h"

@implementation BXPaymentTwoCell

- (void)awakeFromNib {
    // Initialization code
    self.bottomView.hidden = YES;
    self.separationView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillInWithPaymentModel:(BXPaymentModel *)model{
    // 标题
    if (model.title) {
        if (BXSize.width == 320) {
            if (model.title.length > 12) {
                NSString *str1 = [model.title substringToIndex:4];
                NSString *str2 = [model.title substringFromIndex:model.title.length - 6];
                self.titleLabel.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
            }else{
                self.titleLabel.text = model.title;
            }
        }else{
            self.titleLabel.text = model.title;
        }
    }
    // 图标
    if (model.zt) {
        if ([model.zt integerValue] == 1) {  //已回
            self.typeImageView.image = [UIImage imageNamed:@"calendar_yihui"];
        }else if([model.zt integerValue] == 0){
            if ([self compareTodayWithTradeTime:model.tradeTime] == 1) {  //逾期
                self.typeImageView.image = [UIImage imageNamed:@"calendar_yuqi"];
            }else{  //未回
                self.typeImageView.image = [UIImage imageNamed:@"calendar_weihui"];
            }
        }
    }
    // 金额&&本期本息
    if (model.amount) {
        self.amoutLabel.text = [NSString stringWithFormat:@"￥%.2lf",[model.amount doubleValue]];
        self.label3.text = [NSString stringWithFormat:@"￥%.2lf",[model.amount doubleValue]];
    }else{
        self.amoutLabel.text = @"￥0.00";
        self.label3.text = @"￥0.00";
    }
    // 投资金额
    if (model.tzje) {
        self.label1.text = [NSString stringWithFormat:@"￥%.2lf",[model.tzje doubleValue]];
    }else{
        self.label1.text = @"￥0.00";
    }
    // 回款进度 
    if (model.hkjd) {
        self.label2.text = model.hkjd;
    }else{
        self.label2.text = @"0/0";
    }
    // 利率
    if (model.nh) {
        self.label4.text = [NSString stringWithFormat:@"%g%%",[model.nh doubleValue]];
    }else{
        self.label4.text = @"0%";
    }
}

// 比较日期大小
- (int)compareTodayWithTradeTime:(NSString *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *today = [NSDate date];
    NSString *todayStr = [formatter stringFromDate:today];
    NSDate *today1 = [formatter dateFromString:todayStr];
    
    NSDate *date1 = [formatter dateFromString:date];
    
    NSComparisonResult result = [today1 compare:date1];
    
    if (result == NSOrderedDescending) {
        return 1; //date是过去
    }else if(result == NSOrderedAscending){
        return -1; // date是将来
    }else{
        return 0;
    }
    
}

@end
