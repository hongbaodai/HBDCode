//
//  BXUIWebRequsetManager.h
//  HBD
//
//  Created by echo on 15/8/10.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>
@class BXBorrowerDetails;
@class BXVocher;

typedef enum {
    MPPayTypeHKBank,       //海口农商银行
    MPPayTypeLDYS           //联动优势
} MPPayType;

@interface BXWebRequesetInfo : NSObject

#pragma 联动字段

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *charset;
@property (nonatomic, copy) NSString *com_amt_type;
@property (nonatomic, copy) NSString *mer_date;
@property (nonatomic, copy) NSString *mer_id;
@property (nonatomic, copy) NSString *notify_url;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *res_format;
@property (nonatomic, copy) NSString *ret_url;
@property (nonatomic, copy) NSString *service;
//@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *sign_type;
@property (nonatomic, copy) NSString *sourceV;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *card_id;
@property (nonatomic, copy) NSString *identity_code;
@property (nonatomic, copy) NSString *identity_type;
@property (nonatomic, copy) NSString *is_open_fastPayment;
@property (nonatomic, copy) NSString *apply_notify_flag;
@property (nonatomic, copy) NSString *serv_type;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *trans_action;
@property (nonatomic, copy) NSString *partic_user_id;
@property (nonatomic, copy) NSString *partic_acc_type;
@property (nonatomic, copy) NSString *partic_type;
@property (nonatomic, copy) NSString *gate_id;




#pragma 海口联合农村商业银行字段

@property (nonatomic, copy) NSString *reqData;
@property (nonatomic, copy) NSString *platformNo;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *keySerial;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *requestNo;

@end





@interface BXUIWebRequsetManager : NSObject

@property (nonatomic, strong) BXWebRequesetInfo  *info;
@property (nonatomic, assign) MPPayType *payType;

+ (instancetype)defaultManager;

//根据条件获取webView的URL
- (NSMutableURLRequest *)requestWithPayType:(MPPayType )payType PayObject:(BXWebRequesetInfo *)info;
//拼接参数
-(NSString *)splicingParametersWithWebRequesetInfo:(BXWebRequesetInfo *)info PayType:(MPPayType )payType;

@end
