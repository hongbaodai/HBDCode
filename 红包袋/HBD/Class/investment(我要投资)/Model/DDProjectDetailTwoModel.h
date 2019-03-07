//
//  DDProjectDetailTwoModel.h
//  HBD
//
//  Created by hongbaodai on 2017/11/3.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDProjectDetailTwoModel : NSObject

// 客户类型：KHLX（1-个人 2-企业）
@property (nonatomic, copy) NSString *KHLX;
//-----个人用户字段信息---------------
// 借款人：HKMC
@property (nonatomic, copy) NSString *HKMC;
// 性别：XB（0-男 1-女）
@property (nonatomic, copy) NSString *XB;
// 最高学历：XL（0-大专及以下；1-本科；2-硕士及以上）
@property (nonatomic, copy) NSString *XL;
// 婚姻状况：HYZK（0-已婚；1-未婚；2-离异）
@property (nonatomic, copy) NSString *HYZK;
// 年龄：根据出生日期计算（出生日期：CSRQ）
@property (nonatomic, copy) NSString *CSRQ;
// 工作城市：沿用PC端的逻辑，解析字段GZCS（1. place=GZCS.split(','); 2. (place[0]?place[0] +'，' : '') + (place[1] || '')）
@property (nonatomic, copy) NSString *GZCS;
// 有无房产：YWFC（Y-有；N-无）
@property (nonatomic, copy) NSString *YWFC;
// 有无车产：YWCC（Y-有；N-无）
@property (nonatomic, copy) NSString *YWCC;
// 有无房贷：YWFD（Y-有；N-无）
@property (nonatomic, copy) NSString *YWFD;
// 有无车贷：YWCD（Y-有；N-无）
@property (nonatomic, copy) NSString *YWCD;
// 家庭净资产：JTJZC（0-50万以下；1-50~100万；2-100~200万；3-200~400万；4-400~600万；5-600万以上）
@property (nonatomic, copy) NSString *JTJZC;


//-----企业用户字段信息---------------
// 借款企业：KHMC
@property (nonatomic, copy) NSString *KHMC;
// 项目地区：XMDQ
@property (nonatomic, copy) NSString *XMDQ;
// 成立时间：CLSJ
@property (nonatomic, copy) NSString *CLSJ;
// 注册资本：ZCZB
@property (nonatomic, copy) NSString *ZCZB;
// 所属行业：SSHY（数字代码）
@property (nonatomic, copy) NSString *SSHY;
// 员工人数：YGRS（0:10人以内 1:10~20人 2:20~50人 3:50~100人 4:100~200人 5:200~500人 6:500人以上）
@property (nonatomic, copy) NSString *YGRS;
// 经营状态：JYZK
@property (nonatomic, copy) NSString *JYZK;
// 企业年收入：QYNSR（数字代码）
@property (nonatomic, copy) NSString *QYNSR;
// 客户评级：KHPJ（A,A-,B,B-,C,D）
@property (nonatomic, copy) NSString *KHPJ;


// 累计借款总额：totalPermittedAmount
@property (nonatomic, copy) NSString *totalPermittedAmount;
// 待还本息：totalToRepayAmount
@property (nonatomic, copy) NSString *totalToRepayAmount;
// 逾期未还：yqwh
@property (nonatomic, copy) NSString *yqwh;
// 逾期已还：yqyh
@property (nonatomic, copy) NSString *yqyh;


@end
