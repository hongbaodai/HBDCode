//
//  MPCheckboxButton.m
//  mobip2p
//
//  Created by Guo Yu on 14/10/30.
//  Copyright (c) 2014年 zkbc. All rights reserved.
//

#import "MPCheckboxButton.h"

@implementation MPCheckboxButton

+ (void)initialize {
    if (self == [MPCheckboxButton self]) {
        [[self appearance]setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        [[self appearance]setImage:[UIImage imageNamed:@"tickSelect"] forState:UIControlStateSelected];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTarget:self action:@selector(onPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onPressed:(MPCheckboxButton*)checkboxButton {
    self.selected = !self.selected;
}

@end
