//
//  BXInviteFriendsCell.m
//  HBD
//
//  Created by echo on 15/9/7.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#define BXTypeFont [UIFont systemFontOfSize:15]

#import "BXInviteFriendsCell.h"

@implementation BXInviteFriendsCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)fillInWithInviteFriendsListModel:(BXInviteFriendsListModel *)element{
    
    
    if (element.JJHYS) {
        self.inviteCountLab.text = element.JJHYS;
    } else {
        self.inviteCountLab.text = @"0";
    }
    
    // 昵称
    if (element.BYQZNC) {
        self.inviteenicenameLab.text = element.BYQZNC;
    }
    // 邀请时间
    NSString *tradeTime = [element.BYQZZCSJ stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    NSDate *date = [formatter dateFromString:tradeTime];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:date];
    self.inviteeregdateLab.text = time.length == 0 ? tradeTime :time;
    
//    NSString *timeStr = element.BYQZZCSJ.length >= 10 ? [element.BYQZZCSJ substringToIndex:10] : element.BYQZZCSJ;
//    self.inviteeregdateLab.text = timeStr;
    // 奖励金额
    NSInteger ele = [element.YQJLHB intValue];
    NSString *inviteMoney = [NSString stringWithFormat:@"%ld元返现券",(long)ele];
    if (ele == 0 ) {
        self.inviteemoneyLab.text = [NSString stringWithFormat:@"-"];
    } else {
        self.inviteemoneyLab.text = inviteMoney;
    }
    self.inviteenicenameLab.font = [UIFont systemFontOfSize:12];
    self.inviteeregdateLab.font = [UIFont systemFontOfSize:12];
    self.inviteemoneyLab.font = [UIFont systemFontOfSize:12];
    self.inviteCountLab.font = [UIFont systemFontOfSize:12];
    self.inviteenicenameLab.textColor = [UIColor colorWithHex:@"#666666"];
    self.inviteeregdateLab.textColor = [UIColor colorWithHex:@"#666666"];
    self.inviteemoneyLab.textColor = [UIColor colorWithHex:@"#666666"];
    self.inviteCountLab.textColor = [UIColor colorWithHex:@"#666666"];
}

@end
