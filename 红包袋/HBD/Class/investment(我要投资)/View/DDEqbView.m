//
//  DDEqbView.m
//  HBD
//
//  Created by hongbaodai on 2017/12/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#define eqbviewW         307
#define eqbviewH         372

#import "DDEqbView.h"
#import "Masonry.h"

@interface DDEqbView()

@property (strong,nonatomic)UIView * coverview;
@property (strong,nonatomic)UIView * popview;
@property (nonatomic, strong) UIImageView *imgview;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIButton *cancleBtn;

@end

@implementation DDEqbView
{
    UIViewController *vc;
}

- (instancetype)initWithTarget:(UIViewController *)target
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        
        [self setUpCoverView];
        
        [self.popview addSubview:self.imgview];
        [self.popview addSubview:self.label1];
        [self.popview addSubview:self.label2];
        [self.popview addSubview:self.openBtn];
        [self.coverview addSubview:self.cancleBtn];
        
        [self show];
    }
    return self;
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
    
    self.popview = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 - 202, eqbviewW, eqbviewH)];
    self.popview.backgroundColor = [UIColor whiteColor];
    self.popview.layer.cornerRadius = 8;
    self.popview.layer.masksToBounds = YES;
    [self.coverview addSubview:self.popview];
    
    UIView *upview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.popview.width_, 162)];
    upview.backgroundColor = DDRGB(229, 246, 253);
    [self.popview addSubview:upview];
    
}


// 重写这个方法,视图基于自动布局的
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// 苹果推荐 约束、增加和修改 放在此方法中
- (void)updateConstraints {
    [super updateConstraints];

    [_imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popview).offset(33);
        make.centerX.mas_equalTo(self.popview);
        make.width.mas_equalTo(208);
        make.height.mas_equalTo(31);
    }];

    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgview.mas_bottom).offset(33);
        make.centerX.mas_equalTo(self.popview);
    }];

    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label1.mas_bottom).offset(74);
        make.centerX.mas_equalTo(self.popview);
        make.width.mas_equalTo(226);
    }];

    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label2.mas_bottom).offset(66);
        make.left.mas_equalTo(self.popview).offset(10);
        make.right.mas_equalTo(self.popview).offset(-10);
        make.height.mas_equalTo(42);
    }];

    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.popview).offset(eqbviewH +27);
        make.centerX.mas_equalTo(self.popview);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
}




- (UIImageView *)imgview {
    if (_imgview == nil) {
        _imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 208, 31)];
        _imgview.centerX_ = self.popview.centerX_;
        _imgview.image = [UIImage imageNamed:@"loan_eqb"];
    }
    return _imgview;
}

- (UILabel *)label1 {
    if (_label1 == nil) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"积极响应国家政策，保障电子合同的合法性。";
        _label1.font = FONT_14;
        _label1.textColor = COLOUR_BTN_BLUE_TITELCOLOR;
    }
    return _label1;
}

- (UILabel *)label2 {
    if (_label2 == nil) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"请开通电子签章账户，开通后您的实名认证信息将作为电子合同签署人。";
        _label2.font = FONT_14;
        _label2.numberOfLines = 2;
        _label2.textColor = COLOUR_BTN_BLUE_TITELCOLOR;
    }
    return _label2;
}

- (UIButton *)openBtn {
    if (_openBtn == nil) {
        _openBtn = [[UIButton alloc] init];
        [_openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        [_openBtn setBackgroundColor:COLOUR_BTN_BLUE_NEW];
        [_openBtn addTarget:self action:@selector(nowOpenBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _openBtn.layer.cornerRadius = 4;
        _openBtn.layer.masksToBounds = YES;
    }
    return _openBtn;
}

- (UIButton *)cancleBtn {
    if (_cancleBtn == nil) {
        _cancleBtn = [[UIButton alloc] init];
        [_cancleBtn setImage:IMG(@"loan_eqbX") forState:UIControlStateNormal];
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
    
    [self.delegate didClickNowOpenBtn];
    [self cancelBtnClick];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
