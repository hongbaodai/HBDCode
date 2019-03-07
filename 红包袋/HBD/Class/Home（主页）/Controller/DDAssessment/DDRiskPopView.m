//
//  DDRiskPopView.m
//  HBD
//
//  Created by hongbaodai on 2017/12/21.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#define eqbviewW          601
#define eqbviewH          283

#import "DDRiskPopView.h"
#import "Masonry.h"

@interface DDRiskPopView ()


@property (strong,nonatomic)UIView * coverview;
@property (strong,nonatomic)UIView * popview;
@property (nonatomic, strong) UIImageView *imgview;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) HXButton *openBtn;
@property (nonatomic, strong) UIButton *cancleBtn;

@end


@implementation DDRiskPopView
{
    NSString *image_;
    NSString *title_;
    NSString *btnImg_;
}

- (instancetype)initWithImage:(NSString *)image Title:(NSString *)title BtnImg:(NSString *)btnImg
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        
        image_ = image;
        title_ = title;
        btnImg_ = btnImg;

        [self setUpCoverView];
        [self.popview addSubview:self.imgview];
        [self.popview addSubview:self.label1];
        [self.popview addSubview:self.openBtn];
        [self.coverview addSubview:self.cancleBtn];

        if ([btnImg isEqualToString:@"risk_bt-sy"]) {
            [self textAttri];
        }

        [self show];
    }
    return self;
}

- (void)textAttri {
    NSString *str = [NSString stringWithFormat:@"恭喜您获得%@返现券",title_];

    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];

    NSDictionary *dic = @{NSForegroundColorAttributeName : COLOUR_BTN_BLUE_NEW, NSFontAttributeName:[UIFont systemFontOfSize:27.0f]};

    NSRange rage = [str rangeOfString:title_];
    [attri setAttributes:dic range:NSMakeRange(rage.location, title_.length)];
    _label1.attributedText = attri;
}

- (void)show
{
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.popview snapToPoint:self.center];
    sanp.damping = 0.7;
    [self.window addSubview:self.popview];
}

- (void)setUpCoverView{
    
    self.coverview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.coverview.backgroundColor = [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:0.55];
    [self addSubview:self.coverview];
    
    self.popview = [[UIView alloc] initWithFrame:CGRectMake(33, SCREEN_HEIGHT/2 - 202, SCREEN_WIDTH-60, eqbviewH)];
    self.popview.centerY_ = self.coverview.centerY_-25;
    self.popview.backgroundColor = [UIColor whiteColor];
    self.popview.layer.cornerRadius = 5;
    self.popview.layer.masksToBounds = YES;
    [self.coverview addSubview:self.popview];
    
}


// 重写这个方法,视图基于自动布局的
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// 苹果推荐 约束、增加和修改 放在此方法中
- (void)updateConstraints {
    [super updateConstraints];
    
    [_imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popview).offset(35);
        make.centerX.mas_equalTo(self.popview);
        make.width.mas_equalTo(308);
        make.height.mas_equalTo(107);
    }];
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popview).offset(155);
        make.centerX.mas_equalTo(self.popview);
    }];
    
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label1.mas_bottom).offset(27);
        make.centerX.mas_equalTo(self.popview);
        make.width.mas_equalTo(279);
        make.height.mas_equalTo(44);
    }];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.popview).offset(eqbviewH +15);
        make.top.mas_equalTo(self.popview).offset( -30);
//        make.centerX.mas_equalTo(self.popview);
        make.trailing.mas_equalTo(self.popview).offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
}




- (UIImageView *)imgview {
    if (_imgview == nil) {
        _imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 208, 55)];
        _imgview.centerX_ = self.popview.centerX_;
        _imgview.contentMode = UIViewContentModeCenter;
//        _imgview.backgroundColor = [UIColor cyanColor];
//        risk_bi   risk_lipn
//        _imgview.image = [UIImage imageNamed:@"risk_bi"];
        _imgview.image = [UIImage imageNamed:image_];
    }
    return _imgview;
}

- (UILabel *)label1 {
    if (_label1 == nil) {
        _label1 = [[UILabel alloc] init];
//        _label1.text = @"完成风险承受能力评估，才能出借哦";
        _label1.text = title_;
        _label1.font = FONT_15;
        _label1.textColor = [UIColor colorWithHexString:@"#7d7d7d"];
    }
    return _label1;
}

- (HXButton *)openBtn {
    if (_openBtn == nil) {
        _openBtn = [[HXButton alloc] init];
//        [_openBtn setTitle:@"立即评估" forState:UIControlStateNormal];
//        [_openBtn setBackgroundColor:COLOUR_BTN_BLUE_NEW];
//        risk_bt-pg  risk_bt-sy
//        [_openBtn setBackgroundImage:IMG(@"risk_bt-pg") forState:UIControlStateNormal];
        [_openBtn setBackgroundImage:IMG(btnImg_) forState:UIControlStateNormal];
        _openBtn.titleLabel.font = FONT_16;
//        _openBtn.layer.cornerRadius = 22;
//        [_openBtn setTitle:@"立即使用" forState:UIControlStateNormal];

        _openBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_openBtn addTarget:self action:@selector(nowOpenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

- (UIButton *)cancleBtn {
    if (_cancleBtn == nil) {
        _cancleBtn = [[UIButton alloc] init];
        [_cancleBtn setImage:IMG(@"cans") forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (void)cancelBtnClick {
    
    self.alpha = 0.0;
    [self.popview removeFromSuperview];
    [self.coverview removeFromSuperview];
    
}

- (void)nowOpenBtnClick {
    
    [self.delegate didClickNowRiskBtn];
    [self cancelBtnClick];
 
}



@end
