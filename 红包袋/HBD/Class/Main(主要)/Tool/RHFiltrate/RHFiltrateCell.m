//
//  RHFiltrateCell.m
//  MCSchool
//
//  Created by 郭人豪 on 2016/12/24.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHFiltrateCell.h"
@interface RHFiltrateCell ()

@property (nonatomic, strong) UILabel * lab_title;
@property (nonatomic, strong) UIImageView * imagBackView;

@end
@implementation RHFiltrateCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imagBackView];
        [self addSubview:self.lab_title];
    }
    return self;
}

#pragma mark - layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    _imagBackView.frame = self.bounds;
    _lab_title.frame = self.bounds;
}

#pragma mark - config cell

- (void)configCellWithData:(NSDictionary *)dic {
    
    _lab_title.text = dic[@"title"];
    if ([dic[@"isSelected"] boolValue]) {
        _lab_title.layer.borderWidth = 0.0;
        _lab_title.textColor = kColor_White; //选中颜色
        _imagBackView.image = [UIImage imageNamed:@"seleRed"];

    } else {
        _lab_title.layer.borderWidth = 1.0;
        _lab_title.layer.borderColor = kColor_Title_Blue.CGColor;
        _lab_title.textColor = kColor_Title_Blue;
        _imagBackView.image = [UIImage imageNamed:@"seleWhite"];
    }
}

#pragma mark - setter and getter

- (UILabel *)lab_title {
    
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] init];
        _lab_title.layer.borderColor = kColor_Red_Main.CGColor;
        _lab_title.layer.cornerRadius = 4.0;
        _lab_title.layer.masksToBounds = YES;
        _lab_title.textAlignment = NSTextAlignmentCenter;
        _lab_title.font = FONT_12;
    }
    return _lab_title;
}

- (UIImageView *)imagBackView {

    if (!_imagBackView) {
        _imagBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _imagBackView.layer.borderColor = kColor_Red_Main.CGColor;
    }
    return _imagBackView;
}


@end
