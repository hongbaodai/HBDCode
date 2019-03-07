//
//  BXRepaymentTwoCell.m
//  
//
//  Created by echo on 16/2/25.
//
//

#import "BXRepaymentTwoCell.h"

@implementation BXRepaymentTwoCell

+ (instancetype)bxRepaymentTwoCellWithTableView:(UITableView *)tableView
{
    BXRepaymentTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepaymentTwoCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"BXRepaymentTwoCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.hidden = YES;
    self.separationView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillInWithRepaymentModel:(BXRepaymentModel *)model{
    // 借款标题
    if (model.JKBT) {
        
        if (SCREEN_SIZE.width == 320) {
            if (model.JKBT.length > 12) {
                NSString *str1 = [model.JKBT substringToIndex:4];
                NSString *str2 = [model.JKBT substringFromIndex:model.JKBT.length - 6];
                self.titleLabel.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
            }else{
                self.titleLabel.text = model.JKBT;
            }
        }else{
            self.titleLabel.text = model.JKBT;
        }
    }
    // 图标
    if ([model.YQTS doubleValue] > 0 || ![model.YQTS isEqual:@""]) { // 逾期
        self.typeImageView.image = [UIImage imageNamed:@"calendar_yuqi"];
    }else if([model.SFYHK integerValue] == 0){ // 未还
        self.typeImageView.image = [UIImage imageNamed:@"calendar_weihuan"];
    }else if([model.SFYHK integerValue] == 1){ // 已还
        self.typeImageView.image = [UIImage imageNamed:@"calendar_yihuan"];
    }
    // 金额
    if (model.SXF || model.YFFX || model.YHBQ || model.YFYQFY) {
        self.amoutLabel.text = [NSString stringWithFormat:@"￥%.2lf",[model.SXF doubleValue] + [model.YFFX doubleValue] + [model.YHBQ doubleValue] + [model.YFYQFY doubleValue]];
    }else{
        self.amoutLabel.text = @"￥0.00";
    }
    
    // 还款进度  self.label2.text = model.hkjd;
    if (model.QS) {

        if ([model.HKFS isEqualToString:@"2"]) {
            self.label1.text = @"1/1";
        } else {
            self.label1.text = [NSString stringWithFormat:@"%@/%@",model.QS,model.HKZQSL];
        }
       
    }else{
        self.label1.text = @"0/0";
    }
    // 应交滞纳金
    if (model.YFYQFY) {
        self.label2.text = [NSString stringWithFormat:@"￥%.2lf",[model.YFYQFY doubleValue]];
    }else{
        self.label2.text = @"￥0.00";
    }
    // 应还手续费
    if (model.SXF) {
        self.label3.text = [NSString stringWithFormat:@"￥%.2lf",[model.SXF doubleValue]];
    }else{
        self.label3.text = @"￥0.00";
    }
    // 应还本息
    if (model.YHBQ) {
        self.label4.text = [NSString stringWithFormat:@"￥%.2lf",[model.YHBQ doubleValue]];
    }else{
        self.label4.text = @"￥0.00";
    }
    // 应交罚息
    if (model.YFFX) {
        self.label5.text = [NSString stringWithFormat:@"￥%.2lf",[model.YFFX doubleValue]];
    }else{
        self.label5.text = @"￥0.00";
    }
}

- (void)makeCellWithIndex:(NSIndexPath *)index selecIndex:(NSInteger)selecIndex open:(BOOL)open
{
    if (index.row == selecIndex) {
        //如果是展开
        if (open == YES) {
            //xxxxxx
            self.bottomView.hidden = NO;
            self.separationView.hidden = NO;
        } else {
            //收起
            self.bottomView.hidden= YES;
            self.separationView.hidden = YES;
        }
        
        //不是自身
    } else {
        
    }
}

@end
