//
//  DDRiskPopView.h
//  HBD
//
//  Created by hongbaodai on 2017/12/21.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DDRiskPopViewDelegate <NSObject>

@optional

- (void)didClickNowRiskBtn;

@end


@interface DDRiskPopView : UIView

@property (nonatomic, weak) id<DDRiskPopViewDelegate>delegate;

- (instancetype)initWithImage:(NSString *)image Title:(NSString *)title BtnImg:(NSString *)btnImg;
- (void)show;

@end
