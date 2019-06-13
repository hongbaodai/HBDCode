//
//  DDChooseHbCell.m
//  HBD
//
//  Created by hongbaodai on 2017/11/1.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDChooseHbCell.h"
#import "NSDate+Setting.h"

@implementation DDChooseHbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)fillWithCouponModel:(BXCouponModel *)model{
    
    if (model.MZ) {
        
        if ([model.YHQLB integerValue] == 1) { // 红包改为返现券
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%g",model.MZ]];
            self.amountLab.attributedText = str;
            
        }else{ //现金红
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%g",model.MZ]];
            self.amountLab.attributedText = str;
        }
        
        self.titleLab.text = [NSString stringWithFormat:@"¥%g返现券", model.MZ];
    }
    
    if ([model.QTQX isEqualToString:@"0"]) {
        self.limitLab.text = [NSString stringWithFormat:@"无起投期限限制"];
    } else {
        self.limitLab.text = [NSString stringWithFormat:@"起投期限：%@个月", model.QTQX];
    }
    
    if (model.SYTJ) {
        
        if ([model.YHQLB integerValue] == 1) { // 红包
            NSString *SYTJ = [NSString stringWithFormat:@"%d",[model.SYTJ intValue]];
            self.detailLab.text = [NSString stringWithFormat:@"单笔满%@元可用",SYTJ];
            
        }else{ // 现金红包
            self.detailLab.text = @"所有项目可投";
        }
    }
    
    if (model.KSRQ && model.JZRQ) {
        NSString *KSRQ = [NSDate formmatDateStr:model.KSRQ];
        NSString *JZRQ = [NSDate formmatDateStr:model.JZRQ];
        self.dateLab.text = [NSString stringWithFormat:@"%@—%@",KSRQ,JZRQ];
    }
    
    //勾选按钮
    self.useBtn.userInteractionEnabled = NO;
    if (model.selectState){
        _selectState = YES;
        [self.useBtn setTitle:@"已选择" forState:UIControlStateNormal];
        [self.useBtn setTitleColor:kColor_Red_Main forState:UIControlStateNormal];
        [self.useBtn setBackgroundColor:kColor_White];
        self.hbBackImg.image = IMG(@"RedPacketUnuse");
        
    }else{
        _selectState = NO;
        [self.useBtn setTitle:@"立即选择" forState:UIControlStateNormal];
        [self.useBtn setTitleColor:kColor_Red_Main forState:UIControlStateNormal];
        [self.useBtn setBackgroundColor:kColor_White];
        self.hbBackImg.image = IMG(@"RedPacketUnuse");
    }
    
}


@end
