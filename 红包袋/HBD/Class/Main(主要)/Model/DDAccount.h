//
//  DDAccount.h
//  HBD
//
//  Created by hongbaodai on 16/8/17.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDAccountBank.h"
#import "DDAccountUser.h"


@interface DDAccount : NSObject<NSCopying>


//*  */
@property (nonatomic, copy) NSString *QP;
//*  */
@property (nonatomic, copy) NSString *TS;
//* 时效标识 */
@property (nonatomic, copy) NSString *_T;
//* 用户ID */
@property (nonatomic, copy) NSString *_U;
//*  */
@property (nonatomic, copy) NSString *cash;
//* 开户方式 */
@property (nonatomic, copy) NSString *khfs;
//* 手机号 */
//@property (nonatomic, copy) NSString *mobile;
//* 昵称 */
@property (nonatomic, copy) NSString *nickName;
//*  */
@property (nonatomic, copy) NSString *resultcode;
//* 用户角色 */
@property (nonatomic, copy) NSString *roles;
//* 32位UUID，用于图片验证码 */
@property (nonatomic, copy) NSString *sessionId;
//* 权限 */
@property (nonatomic, copy) NSString *usergroup;
//*  */
@property (nonatomic, copy) NSString *wdxxbs;
//* 会员 */
@property (nonatomic, copy) NSString *vipFlag;
//* 会员到期时间 */
@property (nonatomic, copy) NSString *SXSJ;
//* e签宝 */
@property (nonatomic, copy) NSString *signAccount;


/** 银行预留手机号 */
@property (nonatomic, copy) NSString *bankPhoneNum;

@property (nonatomic, strong) DDAccountBank *bankcardBind;

@property (nonatomic, strong) DDAccountUser *currUser;

@property (nonatomic, copy) NSString *levelDesc;

@property (nonatomic, copy) NSString *levelName;

@property (nonatomic, copy) NSString *cardFlag;



//==============new=======================

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *activated;
@property (nonatomic, copy) NSString *vipFailureTime;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *token;


// 单例
singletonInterface(DDAccount);

/** 归档 */
- (void)encodeAccout;

/** 解档 */
- (instancetype)coderAccout;

@end
