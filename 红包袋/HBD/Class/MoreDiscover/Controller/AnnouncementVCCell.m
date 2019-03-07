//
//  AnnouncementVCCell.m
//  HBD
//
//  Created by hongbaodai on 2017/9/25.
//

#import "AnnouncementVCCell.h"
#import "NSDate+Setting.h"

@interface AnnouncementVCCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end


@implementation AnnouncementVCCell

/** 创建AnnouncementVCCell */
+ (instancetype)annoucementVCCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"AnnouncementVCCell";
    AnnouncementVCCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnnouncementVCCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
/** 处理数据 */
- (void)makeUIWithModel:(BXIndustryModel *)model
{
    // 标题
    if (model.BT) {
        self.titleLabel.text = model.BT;
    }
    self.dateLabel.text = model.FBSJ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}



@end
