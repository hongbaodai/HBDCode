//
//  MyRedPacketListVC.h
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//

#import <UIKit/UIKit.h>
#import "BaseNormolViewController.h"
#import "MyRedPacketUnuseCell.h"

@interface MyRedPacketListVC : BaseNormolViewController

/** 用户绑卡信息 */
@property (nonatomic, strong) NSDictionary *cardDict;

/**
 创建MyRedPacketListVC

 @param redType RedType
 @return MyRedPacketListVC
 */
- (instancetype)myRedPacketListVC:(RedType)redType;


@end
