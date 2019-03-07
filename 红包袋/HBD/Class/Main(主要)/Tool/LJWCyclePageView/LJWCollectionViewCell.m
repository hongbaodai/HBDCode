//
//  LJWCollectionViewCell.m
//  CycleCollectionViewTest
//
//  Created by ljw on 15/3/28.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "LJWCollectionViewCell.h"

@implementation LJWCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

- (void)setMyContentView:(UIView *)myContentView
{
    
    [_myContentView removeFromSuperview];
    
    _myContentView = myContentView;
    
    _myContentView.frame = self.bounds;
    
    [self addSubview:_myContentView];
    
}

@end
