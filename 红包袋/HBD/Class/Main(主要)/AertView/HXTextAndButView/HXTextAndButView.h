//
//  HXTextAndButView.h
//  test
//
//  Created by hongbaodai on 2017/12/15.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXTextAndButStyle.h"

typedef void(^ClickBlock)(void);

typedef void(^TapTextBlock)(NSString *str);

@interface HXTextAndButView : UIView

/**
 普通文字后面加的按钮点击事件
 */
@property (nonatomic, copy) ClickBlock clickBlock;

/**
 富文本：可点击文字点击事件（合同）
 */
@property (nonatomic, copy) TapTextBlock tapTextBlock;

/**
 普通文字 + 后面随意加按钮

 @param style style
 @return HXTextAndButView
 */
+ (instancetype)hxTextAndButViewWithStyle:(HXTextAndButStyle *)style;

/**
 富文本:可点击事件（合同类）+ 后面随意加按钮

 @param style style
 @param dataArr 可点击文字集合
 @return HXTextAndButView
 */
+ (instancetype)hxTextAndButViewWithStyle:(HXTextAndButStyle *)style dataArr:(NSArray *)dataArr;

@end
