//
//  HXLabelArrowItem.h
//  test
//
//  Created by hongbaodai on 2017/11/22.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXItem.h"
#import <UIKit/UIKit.h>

@interface HXLabelArrowItem : HXItem
// 文字+ 图片格式

/**
 *  accessoryView：文本：text
 */
@property (nonatomic, copy) NSString *text;

/**
 *  accessoryView：图片：图片名
 */
@property (nonatomic, copy) NSString *arrowImageStr;

@end
