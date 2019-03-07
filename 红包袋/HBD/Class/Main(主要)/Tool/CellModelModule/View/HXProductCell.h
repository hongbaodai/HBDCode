//
//  HXProductCell.h
//  test
//
//  Created by hongbaodai on 2017/11/22.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXItem.h"

@class HXProductCell;

typedef void(^SwitchBlock)(UISwitch *);

@interface HXProductCell : UITableViewCell

@property (nonatomic, copy) SwitchBlock switchBlock;

/**
 模型数据
 */
@property (nonatomic, strong) HXItem *item;

/**
 初始化cell

 @param tableView tableView
 @return HXProductCellHXProductCell.h
 */
//+ (instancetype)hxProductCellWithTableView:(UITableView *)tableView;
+ (instancetype)hxProductCellWithTableView:(UITableView *)tableView style:(NSInteger)style;


@end
