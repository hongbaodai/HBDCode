//
//  DDProjectDetailModel.h
//  HBD
//
//  Created by hongbaodai on 2017/11/3.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDProjectDetailModel : NSObject


// 预期年化收益：NHLL
@property (nonatomic, copy) NSString *NHLL;
// 借款期限：HKZQSL
@property (nonatomic, copy) NSString *HKZQSL;
// 目前已投金额：MQYTBJE
@property (nonatomic, copy) NSString *MQYTBJE;
// 借款总额：ZE
@property (nonatomic, copy) NSString *ZE;
// 借款周期单位(月或天)
@property (nonatomic, copy)NSString *HKZQDW;
// 还款方式：HKFS 1:按月付息到期还本 2：到期还本付息 3：等额回款 / 等额本息
@property (nonatomic, copy) NSString *HKFS;
// 计息方式：JXFS
@property (nonatomic, copy) NSString *JXFS;
// 起投金额：QTJE
@property (nonatomic, copy) NSString *QTJE;
// 项目详情：JKMS
@property (nonatomic, copy) NSString *JKMS;
// 资金用途：ZJYT
@property (nonatomic, copy) NSString *ZJYT;
// 投标开始时间：KBSJ
@property (nonatomic, copy) NSString *KBSJ;
// 募集期：TBKFQ
@property (nonatomic, copy) NSString *TBKFQ;
// 还款来源：HKLY
@property (nonatomic, copy) NSString *HKLY;
// 风控措施：FKCS
@property (nonatomic, copy) NSString *FKCS;
// 项目类型：XMLX
@property (nonatomic, copy) NSString *XMLX;
// 出借人条件：TZRTJ
@property (nonatomic, copy) NSString *TZRTJ;
//产品类型
@property (nonatomic, copy) NSString *projectType;
// 开标时间：openDate
@property (nonatomic, copy) NSString *openDate;
// 投标截止时间
@property (nonatomic, copy) NSString *ZBJSSJ;
// 项目评级
@property (nonatomic, copy) NSString *XMPJ;


//借款人ID
@property (nonatomic, copy) NSString *JKZH_ID;
//借款申请ID
@property (nonatomic, copy) NSString *RZSQ_ID;

// SFTYB 1：普通标 3：新手标 2：体验标（预留字段，现在不作处理）
@property (nonatomic, copy) NSString *SFTYB;
// 最大出借金额
@property (nonatomic, copy) NSString *ZDTZJE;

// 平台贴息
@property (nonatomic, copy)NSString *TXY;

// 平台贴息
@property (nonatomic, copy)NSString *TXZ;


// 借款资金运用情况
@property (nonatomic, copy) NSString *UseFunds;
// 借款人经营状况及财务状况
@property (nonatomic, copy) NSString *FinancialSituation;
// 借款人还款能力变化
@property (nonatomic, copy) NSString *RepaymentAbility;
// 借款人逾期情况
@property (nonatomic, copy) NSString *OverdueNumber;
// 借款人涉诉情况
@property (nonatomic, copy) NSString *Representation;
// 借款人受行政处罚情况
@property (nonatomic, copy) NSString *PunishPenalty;
// 风险结果
@property (nonatomic, copy) NSString *RiskResults;







@end
