//
//  BXRedPackHeaderModel.h
//  HBD
//
//  Created by echo on 15/9/6.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXRedPackHeaderModel : NSObject

//累计红包
//@property (nonatomic, copy) NSString *totalredPacket;
//可用红包
@property (nonatomic, copy) NSString *KYHB;
//冻结红包
@property (nonatomic, copy) NSString *DJHB;
//已用红包
@property (nonatomic, copy) NSString *YXHHB;

@end
