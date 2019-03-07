//
//  BXDebentureViewModel.h
//  HBD
//
//  Created by hongbaodai on 2017/10/9.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

typedef NS_ENUM(NSUInteger, DDSetStyle) {
    DDSetStyleYHCG,             // 银行存管
    DDSetStyleYHKGL,            // 银行卡管理
    DDSetStyleYHYLSJH,          // 银行预留手机号
    DDSetStyleJYMM,             // 交易密码
    DDSetStyleVIP,               // vip
};

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id respose);
typedef void (^FailBlock)(NSError *);

@interface BXDebentureViewModel : NSObject

@property (nonatomic, copy) SuccessBlock succesBlo;
@property (nonatomic, copy) SuccessBlock succesBlindCardBlo;

@property (nonatomic, copy) FailBlock failBlo;


/** 获取用户绑卡信息 */
+ (void)postUserBankCardInfoWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock;
/** 修改银行手机号 */
- (void)postAmendPhoneNumWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock;
/** 修改交易密码 */
- (void)postChangeTransPwdWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock;
/** 绑定银行卡 */
- (void)postBlindCardWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock;

@end
