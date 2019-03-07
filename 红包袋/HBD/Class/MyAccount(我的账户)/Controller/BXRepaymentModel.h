//
//  BXRepaymentModel.h
//  
//
//  Created by echo on 16/2/25.
//
//

#import <Foundation/Foundation.h>

@interface BXRepaymentModel : NSObject
// 标ID
@property (nonatomic, copy) NSString *B_ID;
// 还款方式 1:按月付息到期还本 2：到期还本付息 3：等额回款
@property (nonatomic, copy) NSString *HKFS;
// 还款周期数量
@property (nonatomic, copy) NSString *HKZQSL;
// 借款标题
@property (nonatomic, copy) NSString *JKBT;
// 期数
@property (nonatomic, copy) NSString *QS;
// 是否已还款(0代表未还，1代表已还)
@property (nonatomic, copy) NSString *SFYHK;
// 手续费
@property (nonatomic, copy) NSString *SXF;
// 应交罚息
@property (nonatomic, copy) NSString *YFFX;
// 应还本息
@property (nonatomic, copy) NSString *YHBQ;
// 应还滞纳金
@property (nonatomic, copy) NSString *YFYQFY;
// 逾期天数(大于0或者不为空代表逾期)
@property (nonatomic, copy) NSString *YQTS;
@end
