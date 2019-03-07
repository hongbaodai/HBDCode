//
//  RHFiltrateCell.m
//  MCSchool
//
//  Created by 郭人豪 on 2016/12/24.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHFiltrateCell.h"

#define Color_BG           DDRGB(245, 245, 245)
#define Color_Line         DDRGB(240, 240, 240)
#define Color_H1           DDRGB(77, 77, 77)

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
//        _lab_title.backgroundColor = COLOUR_BTN_BLUE;
        _lab_title.textColor = COLOUR_White; //选中颜色
        _imagBackView.image = [UIImage imageNamed:@"seleRed"];

    } else {
        
        _lab_title.layer.borderWidth = 1.0;
        _lab_title.layer.borderColor = COLOUR_BTN_BLUE_TITELCOLOR.CGColor;
//        _lab_title.backgroundColor = [UIColor whiteColor];
        _lab_title.textColor = COLOUR_BTN_BLUE_TITELCOLOR;
        _imagBackView.image = [UIImage imageNamed:@"seleWhite"];
    }
}

#pragma mark - setter and getter

- (UILabel *)lab_title {
    
    if (!_lab_title) {
        
        _lab_title = [[UILabel alloc] init];
        _lab_title.layer.borderColor = COLOUR_BTN_BLUE.CGColor;
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
        _imagBackView.layer.borderColor = COLOUR_BTN_BLUE.CGColor;
//        _imagBackView.layer.cornerRadius = 4.0;
//        _imagBackView.layer.masksToBounds = YES;
//        _imagBackView.textAlignment = NSTextAlignmentCenter;
//        _imagBackView.font = FONT_12;
    }
    return _imagBackView;
}


@end
