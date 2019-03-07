//
//  DDAccountBank.h
//  HBD
//
//  Created by hongbaodai on 2017/8/9.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAccountBank : NSObject

@property (nonatomic, copy) NSString *CJSJ;
@property (nonatomic, copy) NSString *CZSJ;
@property (nonatomic, copy) NSString *HFYHDM;
@property (nonatomic, copy) NSString *SFKJK;
@property (nonatomic, copy) NSString *KHHMC;
@property (nonatomic, copy) NSString *SFMRTX;
@property (nonatomic, copy) NSString *SSQD;
/**
 银行简称
 */
@property (nonatomic, copy) NSString *YHBM;
/**
 银行卡号
 */
@property (nonatomic, copy) NSString *YHKH;
@property (nonatomic, copy) NSString *YHK_ID;
@property (nonatomic, copy) NSString *YHXM;
@property (nonatomic, copy) NSString *ZH_ID;

@end
