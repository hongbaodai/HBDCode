//
//  DDActivityWebController.h
//  HBD

//  Created by hongbaodai on 16/12/30.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

typedef enum {
    DDUIWebTypeESQS                 // e签宝授权书 （条件多了以后可以枚举）
} DDUIWebType;

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol DDJSExport <JSExport>

/** 弹出登录界面 */
- (void)pushLoginVc;
/** 跳转出借页面 */
- (void)pushInvestVc;
/** 跳转邀请好友页面 */
- (void)pushFriendVc;
/** 跳转设置页面 */
- (void)pushAccountSettingVc;
/** 弹出注册界面 */
- (void)pushRegistrationVc;
/*调用微信分享按钮*/
- (void)addWebShare;
/*用来判断哪个web页面点击*/
- (void)webViewClickMark;

@end


@interface DDActivityWebController : BaseNormolViewController <UIWebViewDelegate, DDJSExport>

@property (nonatomic, copy) NSString *webUrlStr;
@property (nonatomic, strong) NSURL *webUrl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
// 分享title
@property (nonatomic, copy) NSString *webTitleStr;
// 分享图片
@property (nonatomic, copy) NSString *imgUrlStr;
// 分享detail
@property (nonatomic, copy) NSString *webDetailStr;

@property (nonatomic, strong) UIImage *webImg;

@property (strong, nonatomic) JSContext *context;

@end
