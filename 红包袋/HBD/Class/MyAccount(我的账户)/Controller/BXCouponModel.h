//
//  BXCouponModel.h
//  HBD
//
//  Created by echo on 16/5/25.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXCouponModel : NSObject

// 标名称
@property (nonatomic, copy) NSString *BMC;
// 标ID
@property (nonatomic, copy) NSString *B_ID;
// 规则详情
@property (nonatomic, copy) NSString *GZXQ;
// 活动名称
@property (nonatomic, copy) NSString *HDMC;
// 获取日期
@property (nonatomic, copy) NSString *HQRQ;
// 角标显示
@property (nonatomic, copy) NSString *JBXS;
// 借款金额
@property (nonatomic, copy) NSString *JCJE;
// 加息天数
@property (nonatomic, copy) NSString *JXTS;
// 截止日期
@property (nonatomic, copy) NSString *JZRQ;
// 转换后的截止日期
@property (nonatomic, copy) NSString *DDJZRQ;
// 开始日期
@property (nonatomic, copy) NSString *KSRQ;
// 可投项目组（1，所有项目，2，可用券的标）
@property (nonatomic, copy) NSString *KTXMZ;
// 面值（KBLX=1 是金额，KBLX=2 是加息）
@property (nonatomic, assign) double MZ;
// 券号
@property (nonatomic, copy) NSString *QH;
// 使用日期
@property (nonatomic, copy) NSString *SYRQ;
// 使用条件
@property (nonatomic, copy) NSString *SYTJ;
// 红包类别（1：红包，2：加息劵（暂未使用），3：现金红包）
@property (nonatomic, copy) NSString *YHQLB;
// 红包ID
@property (nonatomic, copy) NSString *YHQ_ID;
// 起投上限
@property (nonatomic, copy) NSString *QTQX;
// 起投上限
@property (nonatomic, assign) NSInteger QTQXINT;
// 是否可叠加 0 不能，1可以
@property (nonatomic, copy) NSString *SFDJSY;
//记录选中状态
@property(assign,nonatomic)BOOL selectState;

@property(assign,nonatomic) CGFloat inputMoney;

//是否可以被点击
@property (nonatomic,assign) BOOL isCanSelected;

@end
