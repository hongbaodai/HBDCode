//
//  DDInvitePopView.m
//  HBD
//
//  Created by hongbaodai on 2017/11/7.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvitePopView.h"
#import "UILabel+YBAttributeTextTapAction.h"


@implementation DDInvitePopView

+ (instancetype)instanceInviteFriendPopView
{
    DDInvitePopView *popView = [[[NSBundle mainBundle] loadNibNamed:@"DDInvitePopView" owner:self options:nil] lastObject];
    popView.layer.cornerRadius = 6;
    popView.layer.masksToBounds = YES;
    return popView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (IS_IPHONE5) {
        self.hbViewH.constant = 80;
    }
    
    [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [self addCanClickLabel]; //下次活动可能会用点击事件
}

- (void)addCanClickLabel {
    
    //需要点击的字符不同
    NSString *labeltext = @"奖励升级：您可获得每位好友（熊大宝）出借额的0.5%-2%预期年化收益的奖励；熊大宝每成功邀请一位好友（您的熊二宝），您都将额外获得一个5元的返现券。了解详情>";
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:labeltext];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, labeltext.length)]; //字号
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(labeltext.length-5, 5)]; //点击的文字
    
    self.detailLab.attributedText = attributedString2;
    
    [self.detailLab yb_addAttributeTapActionWithStrings:@[@"了解详情>"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        
        [self.delegate didClickSeeDetail];
    }];
    //设置是否有点击效果，默认是YES
    self.detailLab.enabledTapEffect = NO;
}

- (void)closeBtnClick {
    
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
