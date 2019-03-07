//
//  BXCalendarDefaultCell.h
//  
//
//  Created by echo on 16/2/29.
//
//  回款还款缺省cell

#import <UIKit/UIKit.h>

@interface BXCalendarDefaultCell : UITableViewCell
// 图标
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *downLabel;

+ (instancetype)bxCalendarDefaultCellWithTableView:(UITableView *)tableView;

- (void)fillWithType:(NSString *)type;

@end
