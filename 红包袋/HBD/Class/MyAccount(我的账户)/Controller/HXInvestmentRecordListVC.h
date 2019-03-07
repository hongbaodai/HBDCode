//
//  HXInvestmentRecordListVC.h
//  HBD
//
//  Created by hongbaodai on 2017/9/29.
//

#import <UIKit/UIKit.h>
#import "HXInvestMentRecordTVCell.h"
#import "BaseNormolViewController.h"

@interface HXInvestmentRecordListVC : BaseNormolViewController

/**
 创建HXInvestmentRecordListVC

 @param assetType AssetType
 @return HXInvestmentRecordListVC
 */
- (instancetype)hxInvestmentRecordListVC:(AssetType)assetType;

@end
