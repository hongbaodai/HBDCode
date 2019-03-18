//
//  HXTextAndButModel.h
//
//  Created by hongbaodai on 2017/12/15.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TapTextsBlock)(NSString *str);

typedef NS_ENUM(NSUInteger) {
    TextAndImgStatusRegister,                                       // 注册成功页面：逛一逛
    TextAndImgStatusProjectMoney,                                   // 出借详情页面：项目金额 + 问号
    TextAndImgStatusProjectDescribe,                                // 出借详情页面：项目描述 + 问号
    TextAndImgStatusMoneyUsed,                                      // 出借详情页面：资金用途 + 问号
    TextAndImgStatusBorrowerInformation,                            // 出借详情页面：借款方信息 + 问号
    TextAndImgStatusReimbursementMeansDay,                          // 出借详情页面：还款方式 + 问号：天
    TextAndImgStatusReimbursementMeansMouth,                        // 出借详情页面：还款方式 + 问号：月
    TextAndImgStatusReimbursementAverageCapitalPlusInterest,        // 出借详情页面：还款方式 + 问号：等额本息
    TextAndImgStatusSourceOfRepayment,                              // 出借详情页面：还款来源 + 问号
    TextAndImgStatusRiskControl,                                    // 出借详情页面：风险控制 + 问号
    TextAndImgStatusContract,                                       // 出借确认页面：合同、协议 + 问号
    TextAndImgCollectPeriod,                                        // 出借详情页面：募集期 + 问号
    TextAndImgStatusProjectGrade                                    //项目评级
}TextAndImgStatus;

@interface HXTextAndButModel : NSObject

@property (nonatomic, copy) TapTextsBlock tapBlock;

/**
 出借详情页，项目金额+问号
 
 @param backView 父视图
 @param viewFrame 图文混排viewframe
 */
+ (void)hxProjectItem:(UIView *)backView strImgViewFrame:(CGRect)viewFrame status:(TextAndImgStatus)status;

/**
 富文本点击事件创建

 @param backView 父视图
 @param viewFrame 图文混排viewframe
 */

- (instancetype)initWithProjectTapAction:(UIView *)backView strImgViewFrame:(CGRect)viewFrame tag:(NSInteger)te;

@end
