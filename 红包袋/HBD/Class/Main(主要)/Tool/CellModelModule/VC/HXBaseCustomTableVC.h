//
//  HXBaseCustomTableVC.h
//  test
//
//  Created by hongbaodai on 2017/11/13.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseTableViewController.h"
#import "HXProuductGroup.h"
#import "HXItem.h"
#import "HXLabelItem.h"
#import "HXSwitchItem.h"
#import "HXArrowItem.h"
#import "HXLabelArrowItem.h"
#define imgStr @"arrow"


@interface HXBaseCustomTableVC : BaseTableViewController

/**
 *  存储所有组的数据
 */
@property (nonatomic, strong) NSMutableArray *datas;

- (void)settingSwith:(UISwitch *)swi;

@end
