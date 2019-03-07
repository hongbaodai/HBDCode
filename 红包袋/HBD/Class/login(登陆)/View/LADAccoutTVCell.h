//
//  LADAccoutTVCell.h
//  HBD
//
//  Created by hongbaodai on 2018/4/4.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LADAccoutModel.h"

@interface LADAccoutTVCell : UITableViewCell

@property (nonatomic, strong) LADAccoutModel *model;
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 创建LADAccoutTVCell

 @param tableview tableview
 @return LADAccoutTVCell
 */
+(instancetype)creatLADAccoutTVCellWithTableView:(UITableView *)tableview;
@end
