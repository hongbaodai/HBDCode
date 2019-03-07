//
//  BXInviteFriendsCell.h
//  HBD
//
//  Created by echo on 15/9/7.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXInviteFriendsListModel.h"


@interface BXInviteFriendsCell : UITableViewCell

//被邀请人名称
@property (nonatomic, weak) IBOutlet UILabel *inviteenicenameLab;
//被邀请时间
@property (nonatomic, weak) IBOutlet UILabel *inviteeregdateLab;
//邀请奖励
@property (nonatomic, weak) IBOutlet UILabel *inviteemoneyLab;

@property (weak, nonatomic) IBOutlet UILabel *inviteCountLab;


- (void)fillInWithInviteFriendsListModel:(BXInviteFriendsListModel *)element;

@end
