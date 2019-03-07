//
//  DDInvestRecordCell.h
//  HBD
//
//  Created by hongbaodai on 2017/10/18.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDInvestRecordModel;

@interface DDInvestRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) NSString *only;

@property (nonatomic, strong) DDInvestRecordModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

- (void)fillDataWithInvestRecordModel:(DDInvestRecordModel *)model indexpath:(NSIndexPath *)index;
@end
