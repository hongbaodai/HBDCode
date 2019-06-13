//
//  HXTextAndButModel.m
//
//  Created by hongbaodai on 2017/12/15.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXTextAndButModel.h"
#import "HXTextAndButStyle.h"
#import "HXTextAndButView.h"
#import "DDWebViewVC.h"
#import "AletStrViewController.h"
#import "AlertTextStyle.h"

@interface HXTextAndButModel()
{
    UIViewController *vc;
}

@end

@implementation HXTextAndButModel


+ (void)hxProjectItem:(UIView *)backView strImgViewFrame:(CGRect)viewFrame status:(TextAndImgStatus)status
{
    if (status == TextAndImgStatusRegister) {
        [self Register:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusMoneyUsed) {
        [self MoneyUsed:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusProjectMoney) {
        [self ProjectMoney:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusProjectDescribe) {
        [self ProjectDescribe:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusReimbursementMeansDay) {
        [self ReimbursementMeansDay:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusReimbursementMeansMouth) {
        [self ReimbursementMeansMouth:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusReimbursementAverageCapitalPlusInterest) {
        [self ReimbursementAverageCapitalPlusInterest:backView strImgViewFrame:viewFrame];

    } else if (status == TextAndImgStatusBorrowerInformation) {
        [self BorrowerInformation:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusSourceOfRepayment) {
        [self SourceOfRepayment:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgStatusRiskControl) {
        [self RiskControl:backView strImgViewFrame:viewFrame];
        
    } else if (status == TextAndImgCollectPeriod) {
        [self CollectPeriod:backView strImgViewFrame:viewFrame];
        
    }else if (status == TextAndImgStatusProjectGrade) {
        [self ProjcetGrade:backView strImgViewFrame:viewFrame];
    }
}

+ (void)Register:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"坚决拥护国家政策，用户资金银行存管，平台不碰触用户资金!";
    NSString *alertStr = @"\"网络借贷信息中介机构应当实行自身资金与出借人和借款人资金的隔离管理，并选择符合条件的银行业金融机构作为出借人与借款人的资金存管机构。\"\n\n出自《网络借贷信息中介机构业务活动管理暂行办法》第四章出借人与借款人保护 第二十八条";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 14.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)ProjectMoney:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"项目金额(元)";
    NSString *alertStr = @"\"同一自然人在同一网络借贷信息中介机构平台的借款余额上限不超过人民币20万元；同一法人或其他组织在同一网络借贷信息中介机构平台的借款余额上限不超过人民币100万元\"\n\n出自《网络借贷信息中介机构业务活动管理暂行办法》第十七条";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 11.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum textColor:[UIColor whiteColor]];
}

+ (void)ProjectDescribe:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"项目描述 ";
    NSString *alertStr = @"\"项目基本信息，应当包含项目名称和简介、借款金额、借款期限、借款用途、还款方式、年化利率、起息日、还款来源、还款保障措施\"\n\n出自《网络借贷信息中介机构业务活动信息披露指引》第九条（二）";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 14.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)MoneyUsed:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"资金用途 ";
    NSString *alertStr = @"\"充分披露借款项目信息，信息内容公开透明，符合政策标准\"";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 14.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)BorrowerInformation:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"借款方信息 ";
    NSString *alertStr = @"\"借款人基本信息，应当包含借款人主体性质（自然人、法人或其他组织）、借款人所属行业、借款人收入及负债情况、截至借款前6个月内借款人征信报告中的逾期情况、借款人在其他网络借贷平台借款情况。\"\n\n出自《网络借贷信息中介机构业务活动信息披露指引》第九条（一）";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 12.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)ReimbursementMeansDay:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"还款方式 ";
    NSString *alertStr = @"\"出借预期利息（天标） = 出借金额 * 约定年化利率 * 项目期限（天）/ 365\"\n注：实际收益以系统计算为准";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 12.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)ReimbursementMeansMouth:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"还款方式 ";
    NSString *alertStr = @"\"出借预期利息（月标） = 出借金额 * 约定年化利率 * 项目期限（月）/ 12\"\n注：实际收益以系统计算为准";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 12.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)ReimbursementAverageCapitalPlusInterest:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"还款方式 ";
    NSString *alertStr = @"等额本息：指的是将借款本金和利息总额相加，然后平均分摊到还款期限的每个月中。作为还款人，每个月还给出借人固定金额，但每月还款额中的本金比重逐月递增、利息比重逐月递减。相应出借人每月回款额中本金的比重逐月递增，利息比重是逐月递减。\n注：实际收益以系统计算为准";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 12.0f;

    [self makeAttributeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum arr:[self alertAttri]];
}

+ (NSArray *)alertAttri
{
    AlertTextStyle *style = [AlertTextStyle AlertStyleTextStr:@"等额本息" textColor:kColor_sRGB(239, 185, 72)];

    AlertTextStyle *style2 = [AlertTextStyle AlertStyleTextStr:@"：指的是将借款本金和利息总额相加，然后平均分摊到还款期限的每个月中。作为还款人，每个月还给出借人固定金额，但每月还款额中的本金比重逐月递增、利息比重逐月递减。相应出借人每月回款额中本金的比重逐月递增，利息比重是逐月递减。" textColor:kColor_sRGB(67, 157, 182)];
    AlertTextStyle *style3 = [AlertTextStyle AlertStyleTextStr:@"注：实际收益以系统计算为准" textColor:kColor_sRGB(67, 157, 182)];
    NSArray *arr = [NSArray arrayWithObjects:style, style2,style3, nil];
    return arr;
}

+ (void)SourceOfRepayment:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"还款来源 ";
    NSString *alertStr = @"\"项目基本信息，应当包含项目名称和简介、借款金额、借款期限、借款用途、还款方式、年化利率、起息日、还款来源、还款保障措施\"\n\n出自《网络借贷信息中介机构业务活动信息披露指引》第九条（二）";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 14.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)RiskControl:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"风险控制 ";
    NSString *alertStr = @"\"网络借贷信息中介机构应当在其官方网站上向出借人充分披露借款人基本信息、借款项目基本信息、风险评估及可能产生的风险结果\"              \n\n出自《网络借贷信息中介机构业务活动管理暂行办法》第五章信息披露 第三十条";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 14.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

+ (void)CollectPeriod:(UIView *)backView strImgViewFrame:(CGRect)viewFrame
{
    NSString *str = @"募集期 ";
    NSString *alertStr = @"\"网络借贷信息中介机构应当为单一借款项目设置募集期，最长不超过20个工作日。\"";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 12.0f;
    
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}
/*
 *项目评级，图片+文字
 */
+ (void)ProjcetGrade:(UIView *)backView strImgViewFrame:(CGRect)viewFrame{
    NSString *showStr = @"项目评级";
    NSString *showImg = @"ques";
    NSString *alertImg = @"wapalertshow";
    NSString *alertStr = @"注：内部评级，仅供参考";
    [self projectGrade:showStr showView:backView showImageNamed:showImg showViewFrame:viewFrame alertImageName:alertImg alertString:alertStr];
    
}

+ (void)projectGrade:(NSString *)showStr showView:(UIView *)showView showImageNamed:(NSString *)showImg showViewFrame:(CGRect)showFrame  alertImageName:(NSString *)alertImg alertString:(NSString *)alertStr{
    HXTextAndButStyle *style = [[HXTextAndButStyle alloc] init];
    style.viewFrame = showFrame;
    style.textStr = showStr;
    style.butImgStr = alertImg;
    style.textColor = kColor_sRGB(45, 65, 94);
}


/** alert弹框富文本文字创建UI */
+ (void)makeAttributeUIWith:(NSString *)str backView:(UIView *)backView strImgViewFrame:(CGRect)viewFrame alertStr:(NSString *)alertStr butImgStr:(NSString *)imgStr fontNum:(CGFloat)fontNum arr:(NSArray *)arr
{
    HXTextAndButStyle *style = [[HXTextAndButStyle alloc] init];
    style.viewFrame = viewFrame;
    style.textStr = str;
    style.butImgStr = imgStr; //🚫🚫🚫如果平台合规和风险评估合并一起，则这个需要打开
    style.textFont = fontNum;
    style.textColor = kColor_sRGB(45, 65, 94);

    NSString *alertstr = alertStr;

    HXTextAndButView *view = [HXTextAndButView hxTextAndButViewWithStyle:style];
    view.clickBlock = ^{

        NSString *string = alertstr;

        NSMutableAttributedString *attStr = [self makeTextWithStr:string arr:arr];
        [AletStrViewController creatAlertVCWithAttributedString:attStr sureBlock:nil];
    };

    [backView addSubview:view];
}


/** 普通文字创建UI */
+ (void)makeUIWith:(NSString *)str backView:(UIView *)backView strImgViewFrame:(CGRect)viewFrame alertStr:(NSString *)alertStr butImgStr:(NSString *)imgStr fontNum:(CGFloat)fontNum textColor:(UIColor *)textColor
{
    HXTextAndButStyle *style = [[HXTextAndButStyle alloc] init];
    style.viewFrame = viewFrame;
    style.textStr = str;
    style.butImgStr = imgStr; //🚫🚫🚫如果平台合规和风险评估合并一起，则这个需要打开
    style.textFont = fontNum;
    style.textColor = textColor;

    NSString *alertstr = alertStr;

    HXTextAndButView *view = [HXTextAndButView hxTextAndButViewWithStyle:style];
    view.clickBlock = ^{
        NSString *string = alertstr;
        NSMutableAttributedString *attStr = [self makeAttributWithStr:string];

        [AletStrViewController creatAlertVCWithAttributedString:attStr sureBlock:nil];
    };

    [backView addSubview:view];
}

/** 普通文字创建UI */
+ (void)makeUIWith:(NSString *)str backView:(UIView *)backView strImgViewFrame:(CGRect)viewFrame alertStr:(NSString *)alertStr butImgStr:(NSString *)imgStr fontNum:(CGFloat)fontNum
{
    [self makeUIWith:str backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum textColor:kColor_sRGB(45, 65, 94)];
}
// 这个以后都改成下面的方法 :弹框里面富文本的颜色
+ (NSMutableAttributedString *)makeAttributWithStr:(NSString *)str
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:@"出自"];
    if (range.length != 0) {
        [attStr addAttribute:NSForegroundColorAttributeName value:kColor_Title_Gray range:NSMakeRange(0, str.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:kColor_Orange_Dark range:NSMakeRange(0, range.location)];
    } else {
        [attStr addAttribute:NSForegroundColorAttributeName value:kColor_Orange_Dark range:NSMakeRange(0, str.length)];
    }
    return attStr;
}

// 自定义富文本文字
+ (NSMutableAttributedString *)makeTextWithStr:(NSString *)str arr:(NSArray *)arr
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];

    for (int i = 0; i < arr.count; i ++) {
        AlertTextStyle *style = arr[i];

        NSString *str1 = style.textStr;
        UIColor *color1 = style.textColor;

        NSRange range = [str rangeOfString:str1];
        if (range.length != 0) {
            [attStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(range.location, range.length)];
        } else {
            [attStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, str1.length)];
        }
    }
    return attStr;
}


/** 富文本点击事件创建 */
- (instancetype)initWithProjectTapAction:(UIView *)backView strImgViewFrame:(CGRect)viewFrame tag:(NSInteger)te
{
    self = [[HXTextAndButModel alloc] init];
    [self Contract:backView strImgViewFrame:viewFrame tag:te];
    return self;
}
- (void)Contract:(UIView *)backView strImgViewFrame:(CGRect)viewFrame tag:(NSInteger)teger
{
    NSArray *arr = [[NSArray alloc] init];
    if (teger == 5) {
        arr = @[@"《风险告知书》",@"《借款合同》",@"《平台服务协议》",@"《网络借贷平台禁止性行为》",@"《网络借贷风险提示》",@"《授权书》"];
    }else{
        arr = @[@"《风险告知书》",@"《借款合同》",@"《平台服务协议》",@"《网络借贷平台禁止性行为》",@"《网络借贷风险提示》"];
    }
    NSString *alertStr = @"“依据法律法规及合同约定为出借人与借款人提供直接借贷信息的采集整理、甄别筛选、网上发布，以及资信评估、借贷撮合、借款咨询、在线争议解决等相关服务”\n\n出自《网络借贷信息中介机构业务活动管理暂行办法》第三章业务规则与风险管理（一）";
    NSString *imgStr = @"ques";
    CGFloat fontNum = 12.0f;
    
    [self makeUIWithArr:arr backView:backView strImgViewFrame:viewFrame alertStr:alertStr butImgStr:imgStr fontNum:fontNum];
}

/** 富文本点击事件创建UI */
- (void)makeUIWithArr:(NSArray *)arr backView:(UIView *)backView strImgViewFrame:(CGRect)viewFrame alertStr:(NSString *)alertStr butImgStr:(NSString *)imgStr fontNum:(CGFloat)fontNum
{
    HXTextAndButStyle *style = [[HXTextAndButStyle alloc] init];
    style.viewFrame = viewFrame;
    style.textStr = alertStr;  // 在这个富文本状态点击下，这个属性就没有作用
    style.butImgStr = imgStr; //🚫🚫🚫如果平台合规和风险评估合并一起，则这个需要打开
    style.textFont = fontNum;
    style.textColor = kColor_Orange_Dark;
    
    NSString *alertstr = alertStr;
    
    HXTextAndButView *view = [HXTextAndButView hxTextAndButViewWithStyle:style dataArr:arr];
    view.clickBlock = ^{
        NSString *string = alertstr;
        NSMutableAttributedString *attStr = [[self class] makeAttributWithStr:string];
        [AletStrViewController creatAlertVCWithAttributedString:attStr sureBlock:nil];

    };
    WS(weakSelf);
    // 《风险告知书》《借款合同》《平台服务协议》
    view.tapTextBlock = ^(NSString *str) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(str);
        }
    };
    [backView addSubview:view];
}









@end
