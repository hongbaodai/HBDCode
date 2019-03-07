//
//  BXDefaultCell.h
//  HBD
//
//  Created by echo on 15/9/2.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXDefaultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLab;

+ (instancetype)defaultCell;

- (void)setTitleLabText;

@end
