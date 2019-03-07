//
//  RHFiltrateFooterView.m
//  MCSchool
//
//  Created by 郭人豪 on 2016/12/24.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHFiltrateFooterView.h"

@interface RHFiltrateFooterView ()

@property (nonatomic, strong) UILabel * lab_line;
@end
@implementation RHFiltrateFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lab_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
//    float height = self.bounds.size.height;
    
//    _lab_line.frame = CGRectMake(15, 0, width - 30, height); //分割线
    _lab_line.frame = CGRectMake(0, 0, width, 10);
}

- (UILabel *)lab_line {
    
    if (!_lab_line) {
        
        _lab_line = [[UILabel alloc] init];
        _lab_line.backgroundColor = COLOUR_Gray_Bg;
    }
    return _lab_line;
}


@end
