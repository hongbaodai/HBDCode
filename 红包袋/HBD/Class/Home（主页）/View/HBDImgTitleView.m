//
//  HBDImgTitleView.m
//  HBD
//
//  Created by 草帽~小子 on 2019/6/6.
//  Copyright © 2019 李先生. All rights reserved.
//

#import "HBDImgTitleView.h"


@implementation HBDImgTitleView

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
    //图片64
    NSArray *arr = @[@"home-one", @"home-two", @"home-three"];
    NSArray *arrT = @[@"央企背景", @"供应链金融", @"安全保障"];
    CGFloat width = SCREEN_WIDTH / 375 * 64;
    CGFloat border = 33;
    CGFloat center = (SCREEN_WIDTH - border * 2 - width * 3) / 2;
    CGFloat wid = SCREEN_WIDTH / 3;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(border + i * (width + center), 14, width, width);
        btn.tag = 1000 + i;
        [self addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(wid * i, btn.bottom + 10, wid, 20)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = COLOR_RGB_BLACK_126_126_126;
        //title.font = [UIFont systemFontOfSize:20];
        title.text = arrT[i];
        [self addSubview:title];
    }
}

- (void)tapAction:(UIButton *)send {
    if (self.imgTleTapAction){
        if (send.tag == 1000){
            self.imgTleTapAction(SelectTapActionTypeCentral);
        }else if (send.tag == 1001){
            self.imgTleTapAction(SelectTapActionTypeFinance);
        }else if (send.tag == 1002){
            self.imgTleTapAction(SelectTapActionTypeSecurity);
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(imgTitleTapAction:)]) {
        if (send.tag == 1000) {
            [self.delegate imgTitleTapAction:SelectTapActionTypeCentral];
        }else if (send.tag == 1001) {
            [self.delegate imgTitleTapAction:SelectTapActionTypeFinance];
        }else if (send.tag == 1002) {
            [self.delegate imgTitleTapAction:SelectTapActionTypeSecurity];
        }
    }
}

@end
