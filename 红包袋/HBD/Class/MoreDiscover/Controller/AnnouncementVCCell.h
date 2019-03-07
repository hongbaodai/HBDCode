//
//  AnnouncementVCCell.h
//  HBD
//
//  Created by hongbaodai on 2017/9/25.
//

#import <UIKit/UIKit.h>
#import "BXIndustryModel.h"

@interface AnnouncementVCCell : UITableViewCell

/**
 创建AnnouncementVCCell

 @param tableView tableView
 @return AnnouncementVCCell
 */
+ (instancetype)annoucementVCCellWithTableView:(UITableView *)tableView;

/**
 处理数据

 @param model BXIndustryModel
 */
- (void)makeUIWithModel:(BXIndustryModel *)model;

@end
