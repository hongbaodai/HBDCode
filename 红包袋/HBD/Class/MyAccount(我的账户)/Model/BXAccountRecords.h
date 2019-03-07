//
//  BXAccountRecords.h
//  HBD
//
//  Created by echo on 15/8/4.
// 流水模型

#import <Foundation/Foundation.h>

@interface BXAccountRecords : NSObject

//流水号
@property (nonatomic, copy) NSString *ZJLS_ID;
//项目名称
@property (nonatomic, copy) NSString *JKBT;
//资金变化
@property (nonatomic, copy) NSString *JYJE;
//资金来往类型
@property (nonatomic, copy) NSString *ZJLWLX;
//时间日期
@property (nonatomic, copy) NSString *JYFSSJ;
//交易类型
@property (nonatomic, copy) NSString *mtype;
//标ID
@property (nonatomic, copy) NSString *B_ID;



@end
