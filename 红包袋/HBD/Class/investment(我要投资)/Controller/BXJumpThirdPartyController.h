//
//  BXJumpThirdPartyController.h
//  sinvo
//
//  Created by 李先生 on 15/4/14.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//  网页加载页

#import "ViewController.h"
#import "BXUIWebRequsetManager.h"
#import "NJKWebViewProgress.h"
#import <WebKit/WebKit.h>

@class BXPayObject;
@protocol PayThirdPartyProtocol <NSObject>
@optional

- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number;

@end

@interface BXJumpThirdPartyController : BaseNormolViewController<UIWebViewDelegate,NJKWebViewProgressDelegate, WKUIDelegate>

@property (nonatomic, assign) MPPayType payType;
@property (nonatomic, strong) BXPayObject *payObject;
@property (nonatomic, strong) BXWebRequesetInfo  *info;

@property (nonatomic, weak) id<PayThirdPartyProtocol> payDelegate;

@end
