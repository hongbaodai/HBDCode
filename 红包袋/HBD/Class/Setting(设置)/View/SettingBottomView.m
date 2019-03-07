//
//  SettingBottomView.m
//  HBD
//
//  Created by hongbaodai on 2018/1/29.
//

#import "SettingBottomView.h"

@implementation SettingBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    
    HXButton *but = [[HXButton alloc] initWithFrame:CGRectMake(8, 32, SCREEN_WIDTH - 8 * 2, 44)];
    [but setTitle:@"安全退出" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [but addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:but];
    [self addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)quitAction:(UIButton *)but
{
    if (self.quitBlock) {
        self.quitBlock();
    }
}

@end
