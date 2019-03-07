//
//  DDRiskAssessVC.h
//  HBD
//
//  Created by hongbaodai on 17/5/5.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol DDRiskJSExport <JSExport>

/** 跳转评估结果 */
- (void)pushRiskAssessVc:(NSString *)scorestr;

/**  */
- (void)pushTextVc;

@end


@interface DDRiskAssessVC : UIViewController <UIWebViewDelegate, DDRiskJSExport>

@property (weak, nonatomic) IBOutlet UIWebView *webVIew;
@property (strong, nonatomic) JSContext *context;




@end
