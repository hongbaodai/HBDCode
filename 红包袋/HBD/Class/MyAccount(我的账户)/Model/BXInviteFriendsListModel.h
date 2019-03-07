//
//  BXInviteFriendsListModel.h
//  HBD
//
//  Created by echo on 15/9/7.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  邀请好友列表模型

#import <Foundation/Foundation.h>

@interface BXInviteFriendsListModel : NSObject

//被邀请人昵称
@property (nonatomic, copy) NSString *BYQZNC;
//被邀请人时间
@property (nonatomic, copy) NSString *BYQZZCSJ;
//邀请收益
@property (nonatomic, copy) NSString *YQJLHB;

//间接邀请好友的个数
@property (nonatomic, copy) NSString *JJHYS;

@end
