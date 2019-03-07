//
//  BXMessageCell.m
//  
//
//  Created by echo on 16/2/29.
//
//

#import "BXMessageCell.h"

@interface BXMessageCell()
// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end

@implementation BXMessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

/** 未读消息cell更新 */
- (void)fillWithIndustryModel:(BXIndustryModel *)model
{
    // 标题
    if (model.BT) {
        self.titleLab.text = model.BT;
    }
    // 时间
    if (model.FBSJ) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:model.FBSJ];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr= [formatter stringFromDate:date];
        NSDate *date1 = [formatter dateFromString:dateStr];
        NSDate *today = [NSDate date];
        NSString *todayStr = [formatter stringFromDate:today];
        NSDate *today1 = [formatter dateFromString:todayStr];
        if ([today1 compare:date1] == NSOrderedSame) {
            self.dateLab.text = @"今天";
        }else{
            self.dateLab.text = dateStr;
        }
    }
}

/** 已读消息cell更新 */
- (void)fillWithMessageModel:(BXMessageModel *)model
{
    // 标题
    if (model.title) {
        self.titleLab.text = model.title;
        
    }
    // 时间
    if (model.FSSJ) {
        self.dateLab.text = model.FSSJ;
    }
}

/** 创建BXMessageCell */
+ (instancetype)bxMessageCellWithTableView:(UITableView *)tableview statusType:(StatusType)statusType
{
    BXMessageCell *cell = [tableview dequeueReusableCellWithIdentifier:@"messageCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"BXMessageCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (statusType == StatusTypeRead) {
            cell.titleLab.textColor = DDRGB(156, 168, 186);
        }
    }
    return cell;
}

@end
