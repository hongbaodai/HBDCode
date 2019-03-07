//
//  DDStatusModel.h
//  HBD
//
//  Created by hongbaodai on 16/12/29.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDUserModel.h"

@interface DDStatusModel : NSObject

@property (nonatomic, copy) NSString *iosid;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) DDUserModel *json;
@end
