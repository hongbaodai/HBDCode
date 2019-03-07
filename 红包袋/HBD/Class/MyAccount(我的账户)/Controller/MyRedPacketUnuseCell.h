//
//  MyRedPacketUnuseCell.h
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//

#import <UIKit/UIKit.h>
#import "BXCouponModel.h"


typedef NS_ENUM(NSUInteger, RedType){ // 普通红包
    RedTypeUnuse = 1,           // 未使用
    RedTypeFreeze,          // 冻结
    RedTypeUsed,            // 已使用
    RedTypeOutOfDate,       // 已过期
};

typedef NS_ENUM(NSUInteger, RedPackeType){
    RedPackeTypeNormal = 1,               // 普通红包
    RedPackeTypeRaiseInterestRates,   // 加息券
    RedPackeTypeCash,                 // 现金红包
};

typedef void (^CashUseBlock) (RedPackeType redPackeType, BXCouponModel *model);

@interface MyRedPacketUnuseCell : UITableViewCell

/** 创建我的红包 */
+ (instancetype)myRedPacketUnuseCell:(UITableView *)tableView;

/**
 需要判断是现金红包还是普通红包-再处理.
 */
- (void)makeCellWithType:(RedType)type model:(BXCouponModel *)model;

@property (nonatomic, copy) CashUseBlock cashUseBlock;

@end
