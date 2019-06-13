//
//  HXButton.m
//  HBD
//
//  Created by hongbaodai on 2018/8/1.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "HXButton.h"

@implementation HXButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];

    }
    return self;
}

- (void)setUI
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 22;
    [self setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
    //[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
