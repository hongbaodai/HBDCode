
//  InvestHeaderView.m
//  HBD
//
//  Created by hongbaodai on 2018/4/8.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "InvestHeaderView.h"

@implementation InvestHeaderView

+ (instancetype)investHeaderView {
    
    InvestHeaderView *InfoView = [[[NSBundle mainBundle] loadNibNamed:@"InvestHeaderView" owner:self options:nil] lastObject];
    return InfoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
