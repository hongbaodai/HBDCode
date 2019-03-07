//
//  BXMessageCenterController.h
//  
//
//  Created by echo on 16/2/23.
//
//  消息中心列表

#import <UIKit/UIKit.h>
#import "BXMessageCell.h"
#import "BaseNormolViewController.h"

@interface BXMessageCenterController : BaseNormolViewController

/**
 初始化BXMessageCenterController

 @param status StatusType
 @return BXMessageCenterController
 */
- (instancetype)initWithMessageCenterController:(StatusType)status;

@end
