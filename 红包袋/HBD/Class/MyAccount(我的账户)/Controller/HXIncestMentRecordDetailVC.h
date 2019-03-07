//
//  HXIncestMentRecordDetailVC.h
//  HBD
//
//  Created by hongbaodai on 2017/9/29.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface HXIncestMentRecordDetailVC : BaseTableViewController

/** 出借记录ID */
@property (nonatomic, strong) NSString *idStr;

/**
 创建HXIncestMentRecordDetailVC

 @return HXIncestMentRecordDetailVC
 */
+ (instancetype)creatVCFromSB;


@end
