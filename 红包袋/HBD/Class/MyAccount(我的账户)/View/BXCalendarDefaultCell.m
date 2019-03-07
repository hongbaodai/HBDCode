//
//  BXCalendarDefaultCell.m
//  
//
//  Created by echo on 16/2/29.
//
//

#import "BXCalendarDefaultCell.h"

@implementation BXCalendarDefaultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithType:(NSString *)type{
    if ([type isEqualToString:@"回款"]) {
        self.logoImageView.image = [UIImage imageNamed:@"calendar_whk"];
        self.upLabel.text = @"暂无回款";
        self.downLabel.text = @"投资更多收益更多";
    }else if([type isEqualToString:@"还款"]){
        self.logoImageView.image = [UIImage imageNamed:@"calendar_whhk"];
        self.upLabel.text = @"暂无还款";
        self.downLabel.text = @"";
    }
}

@end
