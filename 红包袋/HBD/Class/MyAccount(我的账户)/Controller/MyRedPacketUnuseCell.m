
//  MyRedPacketUnuseCell.m
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//

#import "MyRedPacketUnuseCell.h"
#import "NSDate+Setting.h"

#define kLabel1Layout (108.0 / 375.0) * (SCREEN_WIDTH)

@interface MyRedPacketUnuseCell()
{
    RedType redtype;
    RedPackeType redpacketype;
    BXCouponModel *models;
}

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
/**
 红包金额
 */
@property (weak, nonatomic) IBOutlet UILabel *redMoneyLabel;

/**
 30元出借红包距上的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabel1TopConstaint;

/**
 30元出借红包距左的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabel1LeadingConstraint;

/**
 30元出借红包高度的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabel1HeightConstraint;

/**
 30元出借红包
 */
@property (weak, nonatomic) IBOutlet UILabel *desTop1Label;

/**
 不可叠加使用据左的
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabel2LeadingConstraint;

/**
 不可叠加使用据上的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLable2TopConstraint;

/**
 不可叠加使用的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabel2HeightConstraint;

/**
 不可叠加使用
 */
@property (weak, nonatomic) IBOutlet UILabel *desTop2Label;

/**
 起投期限限制
 */
@property (weak, nonatomic) IBOutlet UILabel *desTop3Label;

/**
 立即使用按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *ImmediateUseBut;

/**
 单笔出借满500元可用
 */
@property (weak, nonatomic) IBOutlet UILabel *rightDesLabel;

/**
 有效期：时间
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomDateLabel;

/**
 注册奖励
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;

@end

@implementation MyRedPacketUnuseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
}
/** 创建我的红包 */
+ (instancetype)myRedPacketUnuseCell:(UITableView *)tableView
{
    static NSString *idenfier = @"MyRedPacketUnuseCell";
    MyRedPacketUnuseCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPacketUnuseCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
/** 需要判断是现金红包还是普通红包-再处理. */
- (void)makeCellWithType:(RedType)type model:(BXCouponModel *)model
{
    models = model;
    redtype = type;
    redpacketype = [model.YHQLB integerValue];
    
    if (redpacketype == RedPackeTypeCash) { // 现金红包
        [self makeCashRedType:type];
        [self makeCashModel:model type:type];
    } else { // 普通红包和加息券，已跟产品确认
        [self makeNormalRedWithType:type];
        [self makeNomolModel:model type:type];
    }
}

#pragma mark - Model赋值
/** 普通红包的赋值 */
- (void)makeNomolModel:(BXCouponModel *)model type:(RedType)type
{
    if (type == RedTypeUsed) {
        self.desTop2Label.text = model.BMC;
        
        self.desTop1Label.text = [NSString stringWithFormat:@"返现券编号：%@",model.QH];

        NSString *SYRQ = [NSDate formmatDateStr:model.SYRQ];
        self.bottomDateLabel.text = [NSString stringWithFormat:@"%@使用",SYRQ];
    } else {
        
        // 是否可叠加 0 不能，1可以
        self.desTop2Label.text = @"";
//        if ([model.SFDJSY isEqualToString:@"1"]) {
//            self.desTop2Label.text = [NSString stringWithFormat:@"可叠加使用"];
//        } else {
//            self.desTop2Label.text = [NSString stringWithFormat:@"不可叠加使用"];
//        }
        // ¥50元出借红包
        self.desTop1Label.text = [NSString stringWithFormat:@"¥%g返现券",model.MZ];
        
        NSString *KSRQ = [NSDate formmatDateStr:model.KSRQ];
        NSString *JZRQ = [NSDate formmatDateStr:model.JZRQ];
        self.bottomDateLabel.text = [NSString stringWithFormat:@"%@至%@有效",KSRQ,JZRQ];
    }
    // 起投上限
    if ([model.QTQX isEqualToString:@"0"]) {
        
        self.desTop3Label.text = [NSString stringWithFormat:@"无起投期限限制"];
    } else {
        self.desTop3Label.text = [NSString stringWithFormat:@"起投期限：%@个月",model.QTQX];
    }
    
    self.redMoneyLabel.text = [NSString stringWithFormat:@"%g",model.MZ];

    // 来源
    self.bottomLeftLabel.text = [NSString stringWithFormat:@"%@",model.HDMC];
    
    NSString *SYTJ = [NSString stringWithFormat:@"%g",[model.SYTJ doubleValue]];
    self.rightDesLabel.text = [NSString stringWithFormat:@"单笔出借满%@元可用",SYTJ];
}

/** 现金红包赋值 */
- (void)makeCashModel:(BXCouponModel *)model type:(RedType)type
{
    NSString *KSRQ = [NSDate formmatDateStr:model.KSRQ];
    NSString *JZRQ = [NSDate formmatDateStr:model.JZRQ];
    self.bottomDateLabel.text = [NSString stringWithFormat:@"%@至%@有效",KSRQ,JZRQ];
    if (type == RedTypeUsed) {
        NSString *useTime = [NSDate formmatDateStr:model.SYRQ];
        self.bottomDateLabel.text = [NSString stringWithFormat:@"%@使用",useTime];
    }
    self.bottomLeftLabel.text = [NSString stringWithFormat:@"%@",model.HDMC];
    self.desTop1Label.text = [NSString stringWithFormat:@"现金券编号：%@",model.QH];
    self.bottomLeftLabel.text = [NSString stringWithFormat:@"%@",model.HDMC];
    // 来源
    self.redMoneyLabel.text = [NSString stringWithFormat:@"%g",model.MZ];
}

#pragma mark - UI更新
- (void)makeUIWithTop{
    self.layoutLabel1LeadingConstraint.constant = kLabel1Layout;
    self.layoutLabel1TopConstaint.constant = 19.0f;
    self.layoutLabel1HeightConstraint.constant = 16.0f;

    self.desTop1Label.font = [UIFont systemFontOfSize:13.0f];
    self.desTop2Label.font = [UIFont systemFontOfSize:10.0f];
    self.rightDesLabel.hidden = NO;
    self.desTop3Label.hidden = NO;
}

/** 普通红包颜色样式 */
- (void)makeNormalRedWithType:(RedType)type
{
    switch (type) {
        case RedTypeUnuse:
            [self makeUIWithTop];
            [self.ImmediateUseBut setTitleColor:kColor_Red_Main forState:UIControlStateNormal];
            [self.ImmediateUseBut setTitle:@"立即使用" forState:UIControlStateNormal];
            self.ImmediateUseBut.enabled = YES;
            self.backImageView.image = [UIImage imageNamed:@"RedPacketUnuse"];
            [self bottomUnuseLabel];
            break;
        case RedTypeUsed:
            self.layoutLabel1TopConstaint.constant = 12.0f;
            self.layoutLabel1LeadingConstraint.constant = kLabel1Layout;
            self.layoutLabel1HeightConstraint.constant = 13.0f;
            self.layoutLable2TopConstraint.constant = 18.0f;
            self.layoutLabel2HeightConstraint.constant = 13.0f;
            
            self.desTop1Label.font = [UIFont systemFontOfSize:11.0f];
            self.desTop2Label.font = [UIFont systemFontOfSize:10.0f];
            self.rightDesLabel.hidden = YES;
            self.desTop3Label.hidden = YES;
            [self.ImmediateUseBut setTitle:@"已使用" forState:UIControlStateNormal];
            self.backImageView.image = [UIImage imageNamed:@"RedPacketUsed"];
            [self makeUIWithRightBottom];
            break;
        case RedTypeOutOfDate:
            
            [self makeUIWithTop];
            [self makeUIWithRightBottom];
            
            [self.ImmediateUseBut setTitle:@"已过期" forState:UIControlStateNormal];
            self.backImageView.image = [UIImage imageNamed:@"RedPacketUsed"];

            break;
        default:
            break;
    }
}

- (void)makeUIWithRightBottom{
    self.ImmediateUseBut.backgroundColor = kColor_sRGB(170, 189, 196);
    [self.ImmediateUseBut setTitleColor:kColor_sRGB(204, 216, 220) forState:UIControlStateNormal];
    self.ImmediateUseBut.enabled = NO;
    [self bottomUsedLabel];
}

- (void)bottomUnuseLabel{
    self.ImmediateUseBut.backgroundColor = [UIColor whiteColor];
    self.bottomLeftLabel.textColor = kColor_Title_Blue;
    self.bottomDateLabel.textColor = kColor_Title_Blue;
}

- (void)bottomUsedLabel{
    self.bottomLeftLabel.textColor = kColor_sRGB(203, 216, 220);
    self.bottomDateLabel.textColor = kColor_sRGB(203, 216, 220);
}

/** 现金红包 */
- (void)makeCashRedType:(RedType)redType{
    self.layoutLabel1TopConstaint.constant = 12.0f;
    self.layoutLabel1LeadingConstraint.constant = kLabel1Layout;
    self.layoutLabel1HeightConstraint.constant = 13.0f;

    self.layoutLabel2LeadingConstraint.constant = 36.0f;
    self.layoutLable2TopConstraint.constant = 24.0f;
    self.layoutLabel2HeightConstraint.constant = 16.0f;

    self.desTop2Label.text = @"现金券";
    self.desTop2Label.font = [UIFont systemFontOfSize:16.0f];

    self.desTop3Label.hidden = YES;
    self.rightDesLabel.hidden = YES;
    
    switch (redType) {
        case RedTypeUnuse:
            [self bottomUnuseLabel];
            
            [self.ImmediateUseBut setTitleColor:kColor_Orange_Dark forState:UIControlStateNormal];
            [self.ImmediateUseBut setTitle:@"转为现金" forState:UIControlStateNormal];
            self.ImmediateUseBut.enabled = YES;
            self.backImageView.image = [UIImage imageNamed:@"RedCashUnuse"];

            break;
        case RedTypeUsed:
            [self makeUIImmediateBut];
            [self.ImmediateUseBut setTitle:@"已使用" forState:UIControlStateNormal];
            self.ImmediateUseBut.enabled = NO;
            self.backImageView.image = [UIImage imageNamed:@"RedPacketUsed"];

            break;
        case RedTypeOutOfDate:
            
            [self makeUIImmediateBut];
            [self.ImmediateUseBut setTitle:@"已过期" forState:UIControlStateNormal];
            self.ImmediateUseBut.enabled = NO;
            self.backImageView.image = [UIImage imageNamed:@"RedPacketUsed"];

        default:
            break;
    }
}

- (void)makeUIImmediateBut
{
    [self.ImmediateUseBut setTitleColor:kColor_sRGB(204, 216, 220) forState:UIControlStateNormal];
    self.ImmediateUseBut.backgroundColor = kColor_sRGB(170, 189, 196);
    [self bottomUsedLabel];
}
/** 按钮处理：立即使用和提现 */
- (IBAction)ImmediateUseAction:(UIButton *)sender
{
    if (self.cashUseBlock) {
        self.cashUseBlock(redpacketype, models);;
    }
}

@end
