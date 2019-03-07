//
//  BXMessageCell.h
//  Created by echo on 16/2/29.

#import <UIKit/UIKit.h>
#import "BXIndustryModel.h"
#import "BXMessageModel.h"

typedef NS_ENUM(NSUInteger, StatusType){
    StatusTypeUnRead,        // 未读
    StatusTypeRead,          // 已读
};

@interface BXMessageCell : UITableViewCell

/**
 创建BXMessageCell

 @param tableview tableView
 @param statusType statusType
 @return BXMessageCell
 */
+ (instancetype)bxMessageCellWithTableView:(UITableView *)tableview statusType:(StatusType)statusType;


/**
 未读消息cell更新

 @param model BXIndustryModel
 */
- (void)fillWithIndustryModel:(BXIndustryModel *)model;

/**
 已读消息cell更新

 @param model BXMessageModel
 */
- (void)fillWithMessageModel:(BXMessageModel *)model;

@end
