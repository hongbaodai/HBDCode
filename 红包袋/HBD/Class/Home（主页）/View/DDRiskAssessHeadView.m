//
//  DDRiskAssessHeadView.m
//  HBD
//
//  Created by hongbaodai on 2017/5/11.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDRiskAssessHeadView.h"

@interface DDRiskAssessHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *headLAbel;

@end

@implementation DDRiskAssessHeadView

- (void)drawRect:(CGRect)rect
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"为响应国家相关政策要求，引导出借人树立正确出借观念。本问卷将综合评估您的风险承受能力，帮助您控制风险，从而理性出借。请您如实填写本问卷。\n本问卷涉及内容仅供红包袋平台评估出借者风险承受能力，平台将履行保密义务。"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [att length])];
    self.headLAbel.attributedText = att;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

@end
