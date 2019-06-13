//
//  DDUpgradeStopView.m
//  HBD
//
//  Created by hongbaodai on 2017/8/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDUpgradeStopView.h"

@implementation DDUpgradeStopView
 
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLab];
        [self addSubview:self.detailLab];
//        [self addSubview:self.cancelBtn];
        [self addSubview:self.upgradeBtn];
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
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
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
    }];
    
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_upgradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_detailLab.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(42);
    }];
}

- (void)cancelBtnClick {
    [self.delegate didClickCancelStopBtn];
}

- (void)upgradeBtnClick {
    [self.delegate didClickUpgradeStopBtn];
}


#pragma mark initUI
- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = kColor_Red_Main;
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.text = @"升级停服公告";
    }
    return _titleLab;
}

- (UILabel *)detailLab {
    if (_detailLab == nil) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = [UIColor darkGrayColor];
        _detailLab.font = [UIFont systemFontOfSize:14];
        _detailLab.numberOfLines = 0;
        _detailLab.text = @"红包袋资金账户体系全面升级！2017年8月22日平台进行银行资金存管系统的上线对接。在此期间暂停线上服务：官方网站、APP均无法进行登录、注册等操作（支持正常浏览）。2017年8月23日，银行存管系统上线后将恢复正常。";
    }
    return _detailLab;
}

-(UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setImage:IMG(@"icon_chax") forState:UIControlStateNormal];
        [_upgradeBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)upgradeBtn {
    if (_upgradeBtn == nil) {
        _upgradeBtn = [[UIButton alloc] init];
        [_upgradeBtn setTitle:@"确定" forState:UIControlStateNormal];
        _upgradeBtn.backgroundColor = kColor_Red_Main;
        _upgradeBtn.layer.cornerRadius = 3;
        _upgradeBtn.layer.masksToBounds = YES;
        [_upgradeBtn addTarget:self action:@selector(upgradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upgradeBtn;
}



@end
