//
//  DDWebViewVC.h
//  HBD
//
//  Created by hongbaodai on 17/3/23.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

typedef enum {
    DDWebTypeYHXY,            // 红包袋用户协议
    DDWebTypeWLJDFXTS,        // 网络借贷风险提示
    DDWebTypeWLJDJZXXW,       // 网络借贷禁止性行为
    DDWebTypeFXGZS,           // 风险告知书
    DDWebTypePTFWXY,          // 平台服务协议
    DDWebTypeJKHT,             // 借款合同
    DDWebTypeXSZY,              // 新手指引
    DDWebTypeYangQi,            // 央企背景
    DDWebTypeGongYingLian,      // 供应链金融
    DDWebTypeAQBZ,              // 安全保障
    DDWebTypeHOMEAQBZ,          // 首页安全保障
    DDWebTypeXSZX,               // 新手专享
    DDWebTypeYQHYGZXQ,             // 邀请好友规则详情
    HHYinSiZC,                     // 隐私政策
    DDWebTypeDDSQS              //电子授权书

} DDWebType;


#import <UIKit/UIKit.h>


@interface DDWebViewVC : BaseNormolViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *weburlStr;
@property (nonatomic, assign) DDWebType webType;
@property (nonatomic, copy) NSString *jixiType;

@end
