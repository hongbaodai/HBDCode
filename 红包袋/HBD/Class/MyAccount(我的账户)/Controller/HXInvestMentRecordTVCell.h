//
//  HXInvestMentRecordTVCell.h
//  HBD
//
//  Created by hongbaodai on 2017/9/29.
//

#import <UIKit/UIKit.h>
#import "BXMyaccountInvestThreeModel.h"
#import "BXMyAccountInvestmentModel.h"
#import "BXInvestFinishModel.h"

typedef NS_ENUM(NSUInteger, AssetType){
    AssetTypeRecovery,           // 回款中
    AssetTypeRaiseMoney,         // 筹款中
    AssetTypeDone,               // 已完成
};

@interface HXInvestMentRecordTVCell : UITableViewCell

/**
 创建HXInvestMentRecordTVCell

 @param tableView tableView
 @param assetType AssetType
 @return HXInvestMentRecordTVCell
 */
+ (instancetype)hxInvestMentRecordTVCell:(UITableView *)tableView type:(AssetType)assetType;

/** 回款中 */
- (void)makeModel:(BXMyaccountInvestThreeModel *)recordThreeModel;

/** 筹款中 */
- (void)myAccountInvestRecordWithModel:(BXMyAccountInvestmentModel *)accountModel;

/** 已完成 */
- (void)accountInvestRecordThreeModel:(BXInvestFinishModel *)finishModel;


@end
