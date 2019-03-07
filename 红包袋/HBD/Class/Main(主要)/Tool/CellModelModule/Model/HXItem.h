//
//  HXItem.h
//  test
//
//  Created by hongbaodai on 2017/11/13.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UITableViewCell;

typedef void (^optionBlock)(NSIndexPath *index);

@interface HXItem : NSObject

/**
 图标
 */
@property (nonatomic, copy) NSString *img;
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 标题大小
 */
@property (nonatomic, assign) UIFont *titleFont;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subTitle;

/**
 *  子标题大小
 */
@property (nonatomic, assign) UIFont *subTitleFont;
/**
 *  提醒数字
 */
@property (nonatomic, copy) NSString *badgeValue;
/**
 目标控制器
 */
@property (nonatomic, assign) Class destVC;
/**
 cell样式
 */
@property (nonatomic, assign) NSInteger styleCell;

/**
 做点击操作等
 */
@property (nonatomic, copy) optionBlock option;

/**
 实例初始化HXItem

 @param img 图片
 @param title 名称
 @return HXItem对象
 */
- (instancetype)initWithImg:(NSString *)img title:(NSString *)title;

/**
 类初始化HXItem

 @param title title
 @return HXItem对象
 */
+ (instancetype)itemWithTitle:(NSString *)title;

@end
