//
//  BXDefaultCell.m
//  HBD
//
//  Created by echo on 15/9/2.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import "BXDefaultCell.h"

@implementation BXDefaultCell

+ (instancetype)defaultCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXDefaultCell" owner:self options:nil] lastObject];
}

- (void)setTitleLabText{
    self.titleLab.text = @"加载中..";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
