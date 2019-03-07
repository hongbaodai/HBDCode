//
//  BXSharePageView.h
//  ump_xxx1.0
//
//  Created by echo on 16/3/16.
//  Copyright © 2016年 李先生. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePageViewProtocol <NSObject>
@optional
// 点击微信好友
- (void)didClickWXHYBtn;
// 点击微信朋友圈
- (void)didClickWXPYQBtn;
// 点击取消按钮
- (void)didClickCancelShareBtn;
@end

@interface BXSharePageView : UIView

+ (instancetype)sharePageView;
@property (nonatomic, weak) id<SharePageViewProtocol> SharePageDelegate;
// 点击微信好友
- (IBAction)didClickWXHYBtn:(id)sender;
// 点击微信朋友圈
- (IBAction)didClickWXPYQBtn:(id)sender;
// 点击取消按钮
- (IBAction)didClickCancelBtn:(id)sender;

@end
