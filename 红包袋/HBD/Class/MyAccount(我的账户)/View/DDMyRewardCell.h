//
//  DDMyRewardCell.h
//  HBD
//
//  Created by hongbaodai on 16/11/17.//

#import <UIKit/UIKit.h>
@class DDMyRewardModel;
@class BXAccountRecords;

@interface DDMyRewardCell : UITableViewCell


@property (nonatomic, strong) DDMyRewardModel *model;

/** 我的奖品-cell */
+ (instancetype)myRewordCellWithTableView:(UITableView *)tableView;

/** 我的资金流水-cell */
+ (instancetype)myAccountRecordsWithTableView:(UITableView *)tableView;
/** 我的资金流水 */
- (void)accountRecordsModel:(BXAccountRecords *)finishModel;

@end
