//
//  ExperienceProjectView.m
//  HBD
//
//  Created by 草帽~小子 on 2019/6/5.
//  Copyright © 2019 李先生. All rights reserved.
//

#import "ExperienceProjectView.h"
#import "HBDGradientTapView.h"

@interface ExperienceProjectView ()

@property (nonatomic, strong) HBDGradientTapView *gradientTapView;

@end

@implementation ExperienceProjectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpViews];
}

- (void)setUpViews {
    [self addSubview:self.tagImgV];
    [self addSubview:self.titleLab];
    [self addSubview:self.percentLab];
    [self addSubview:self.ratePerYear];
    [self addSubview:self.dayTime];
    [self addSubview:self.deadline];
    [self addSubview:self.gradientTapView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //图片等比缩放69x52
    CGFloat width = SCREEN_WIDTH / 375 * 69;
    CGFloat height = width * 52 / 69;
    
    [self.tagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.mas_equalTo(width);
        make.size.mas_equalTo(CGSizeMake(self.width - width * 2, 16));
    }];
    
    [self.percentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.mas_equalTo(height);
        make.size.mas_equalTo(CGSizeMake(self.width / 2, 40));
    }];

    [self.ratePerYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.percentLab.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.width / 2, 13));
    }];

    [self.dayTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.width / 2);
        make.top.mas_equalTo(height);
        make.size.mas_equalTo(CGSizeMake(self.width / 2, 40));
    }];

    [self.deadline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.width / 2);
        make.top.equalTo(self.dayTime.mas_bottom);
        make.width.mas_equalTo(CGSizeMake(self.width / 2, 13));
    }];

    [self.gradientTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.right.equalTo(self).offset(-17);
        make.bottom.equalTo(self).offset(-15);
        make.height.mas_equalTo(44);
    }];
}

#pragma getter

- (UIImageView *)tagImgV {
    if (_tagImgV == nil) {
        _tagImgV = [[UIImageView alloc] init];
        _tagImgV.image = [UIImage imageNamed:@"xinshouzhuanxiang"];
    }
    return _tagImgV;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_15;
        _titleLab.textColor = COLOR_RGB_BLACK_45_65_94;
        _titleLab.text = @"体验标";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)percentLab {
    if (_percentLab == nil) {
        _percentLab = [[UILabel alloc] init];
        _percentLab.font = FONT_30;
        _percentLab.textColor = COLOR_RGB_RED_231_56_61;
        _percentLab.text = @"8.8%";
        _percentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _percentLab;
}

- (UILabel *)ratePerYear {
    if (_ratePerYear == nil) {
        _ratePerYear = [[UILabel alloc] init];
        _ratePerYear.font = FONT_12;
        _ratePerYear.textColor = COLOR_RGB_BLACK_126_126_126;
        _ratePerYear.text = @"约定年化利率";
        _ratePerYear.textAlignment = NSTextAlignmentCenter;
    }
    return _ratePerYear;
}

- (UILabel *)dayTime {
    if (_dayTime == nil) {
        _dayTime = [[UILabel alloc] init];
        NSString *string = @"1/3/7/天";
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
        [attribute addAttribute:NSFontAttributeName value:FONT_18 range:NSMakeRange(0, string.length - 1)];
        [attribute addAttribute:NSFontAttributeName value:FONT_14 range:NSMakeRange(string.length - 1, 1)];
        _dayTime.attributedText = attribute;
        _dayTime.textAlignment = NSTextAlignmentCenter;
    }
    return _dayTime;
}

- (UILabel *)deadline {
    if (_deadline == nil) {
        _deadline = [[UILabel alloc] init];
        _deadline.font = FONT_12;
        _deadline.textColor = COLOR_RGB_BLACK_126_126_126;
        _deadline.text = @"出借期限";
        _deadline.textAlignment = NSTextAlignmentCenter;
    }
    return _deadline;
}

- (HBDGradientTapView *)gradientTapView {
    if (_gradientTapView == nil) {
        _gradientTapView = [[HBDGradientTapView alloc] init];
        _gradientTapView.backgroundColor = [UIColor redColor];
        __weak typeof(self) weakSelf = self;
        _gradientTapView.gradientTapAction = ^{
            if (weakSelf.experienceTapAction) {
                weakSelf.experienceTapAction();
            }
        };
    }
    return _gradientTapView;
}

@end
