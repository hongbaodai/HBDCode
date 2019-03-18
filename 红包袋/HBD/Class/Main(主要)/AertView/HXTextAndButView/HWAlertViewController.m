//
//  HWAlertViewController.m
//  HBD
//
//  Created by 草帽~小子 on 2019/3/14.
//  Copyright © 2019 李先生. All rights reserved.
//

#import "HWAlertViewController.h"
#import "CHUtil.h"
@interface HWAlertViewController ()

@property (nonatomic, strong) UIView *backGroundV;
@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) UILabel *remindLab;
@property (nonatomic, strong) UIButton *clickBtn;

@end

@implementation HWAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [self configSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)configSubViews {
    //图片540x680
    CGFloat width = SCREEN_WIDTH / 375 * 540 / 2;
    CGFloat height = width / 540 * 680;
    
    self.backGroundV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 30, height + 14 + 10 + 40)];
    self.backGroundV.backgroundColor = [UIColor whiteColor];
    self.backGroundV.layer.cornerRadius = 10;
    self.backGroundV.layer.masksToBounds = YES;
    self.backGroundV.center = self.view.center;
    [self.view addSubview:self.backGroundV];
    
    self.topImgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.backGroundV.width - width) / 2, 0, width, height)];
    self.topImgV.image = [UIImage imageNamed:@"wapalertshow"];
    [self.backGroundV addSubview:self.topImgV];
    
    self.remindLab = [[UILabel alloc] initWithFrame:CGRectMake(self.topImgV.left, self.topImgV.bottom, width, 14)];
    self.remindLab.text = @"注：内部评级，仅供参考";
    self.remindLab.font = [UIFont systemFontOfSize:14];
    self.remindLab.textColor = [CHUtil colorWithHexString:COLOUR_GRAY];
    self.remindLab.textAlignment = NSTextAlignmentLeft;
    [self.backGroundV addSubview:self.remindLab];

    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickBtn.frame = CGRectMake(0, self.remindLab.bottom + 10, self.backGroundV.width, 40);
    self.clickBtn.layer.cornerRadius = 10;
    self.clickBtn.layer.masksToBounds = YES;
    self.clickBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.clickBtn.layer.borderWidth = 1;
    [self.backGroundV addSubview:self.clickBtn];
    [self.clickBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [self.clickBtn setTitleColor:[CHUtil colorWithHexString:COLOUR_GRAY] forState:UIControlStateNormal];
    self.clickBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickBtnAction:(UIButton *)button {
    if (self.clickBtnBlock) {
        self.clickBtnBlock();
    }
}


@end
