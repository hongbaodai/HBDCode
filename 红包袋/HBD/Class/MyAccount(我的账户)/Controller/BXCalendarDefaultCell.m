//
//  BXCalendarDefaultCell.m
//  
//
//  Created by echo on 16/2/29.
//
//

#import "BXCalendarDefaultCell.h"

@implementation BXCalendarDefaultCell

+ (instancetype)bxCalendarDefaultCellWithTableView:(UITableView *)tableView
{
    BXCalendarDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"BXCalendarDefaultCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)fillWithType:(NSString *)type{
    if ([type isEqualToString:@"回款"]) {
        self.logoImageView.image = [UIImage imageNamed:@"calendar_whk"];

        self.upLabel.text = @"暂无回款";
        self.downLabel.text = @"出借更多收益更多";
    } else if([type isEqualToString:@"还款"]){
        self.logoImageView.image = [UIImage imageNamed:@"calendar_whhk"];
        self.upLabel.text = @"暂无还款";
        self.downLabel.text = @"";
    }
}

@end
