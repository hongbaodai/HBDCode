//
//  HXTextAndButStyle.h
//  test
//
//  Created by hongbaodai on 2017/12/15.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXTextAndButStyle : NSObject

/** 图文大小 */
@property (nonatomic, assign) CGRect viewFrame;
/** 图文显示语 */
@property (nonatomic, strong) NSString *textStr;
/** 显示颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 按钮图片:假如不传，则没有图片按钮 */
@property (nonatomic, strong) NSString *butImgStr;
/** 文字大小 */
@property (nonatomic, assign) CGFloat textFont;
/** 按钮是否有点击事件YES：没有点击事件，NO：有点击事件 默认是no */
@property (nonatomic, assign) BOOL click;


/** alert富文本显示语 */
@property (nonatomic, strong) NSString *attriteStr;

@end
