//
//  LADAccoutModel.h
//  HBD
//
//  Created by hongbaodai on 2018/4/4.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
// 银行限额列表信息model
#import <Foundation/Foundation.h>

@interface LADAccoutModel : NSObject
// 图片
@property (nonatomic, copy) NSString *XETP_APP;
// 图片
@property (nonatomic, copy) NSString *XETP_PC;
// 50万
@property (nonatomic, copy) NSString *MRXE;
// Y
@property (nonatomic, copy) NSString *SFXS;
// 中国农业银行
@property (nonatomic, copy) NSString *YHMC;
// 图片
@property (nonatomic, copy) NSString *YHTB;
// 5000元
@property (nonatomic, copy) NSString *DBXE;
// ABOC
@property (nonatomic, copy) NSString *YHDM;
// 单笔5000元，日累计2万
@property (nonatomic, copy) NSString *ZJTGXE;
// 95599
@property (nonatomic, copy) NSString *KFDH;
@end
