//
//  DDInvitePopView.h
//  HBD
//
//  Created by hongbaodai on 2017/11/7.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDInvitePopDelegate <NSObject>

- (void)didClickSeeDetail;

@end

@interface DDInvitePopView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hbViewH;

@property (nonatomic, weak) id<DDInvitePopDelegate>delegate;

+ (instancetype)instanceInviteFriendPopView;

@end
