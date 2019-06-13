//
//  DDInvestRcdView.m
//  HBD
//
//  Created by hongbaodai on 2017/12/8.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
// 出借记录状态view

#import "DDInvestRcdView.h"

@interface DDInvestRcdView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@end

@implementation DDInvestRcdView
{
    BOOL ISLOGIN;
}

- (instancetype)initWithFrame:(CGRect)frame isLogin:(BOOL)isLogin{
    if ([super initWithFrame:frame]) {
        
        ISLOGIN = isLogin;
        self.backgroundColor = [UIColor whiteColor];
  
        [self addSubview:self.imgView];
        if (!isLogin) {
            [self addSubview:self.button];
        }
        [self addSubview:self.label];
        
    }
    return self;
}

// 重写这个方法,视图基于自动布局的
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// 苹果推荐 约束、增加和修改 放在此方法中
- (void)updateConstraints {
    [super updateConstraints];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(130);
        make.width.mas_equalTo(160);
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgView.mas_bottom).offset(20);
        if (ISLOGIN) {
            make.centerX.mas_equalTo(_imgView.mas_centerX).offset(0);
        } else {
            make.centerX.mas_equalTo(_imgView.mas_centerX).offset(20);
        }
        
        
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_label.mas_left).offset(3);
        make.centerY.mas_equalTo(_label.mas_centerY);
    }];
    
}


- (void) buttonClick {
    
    if (self.investRcdBlock) {
        self.investRcdBlock();
    }
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        
        if (ISLOGIN) {
            _imgView.image = IMG(@"loan_ylogin");
        } else {
            _imgView.image = IMG(@"loan_nlogin");
        }
    }
    return _imgView;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"登录" forState:UIControlStateNormal];
        [_button setTitleColor:kColor_Red_Main forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = kColor_Title_Blue;
        _label.font = FONT_16;
        if (ISLOGIN) {
            _label.text = @"出借此项目用户可查看出借记录";
        } else {
            _label.text = @"  后可查看出借记录";
        }
        
    }
    return _label;
}

@end
