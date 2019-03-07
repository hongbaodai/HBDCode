//
//  HXRefresh.h
//  test
//
//  Created by hongbaodai on 2017/8/3.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HeaderBlock) (void);
typedef void (^FooterBlock) (void);

@interface HXRefresh : NSObject


/**
 设置头部的刷新:无动画

 @param viewController Target
 @param tableView tableView
 @param action @selector
 */
+ (void)setHeaderRefresnWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView headerAction:(SEL)action;

/** 设置头部的刷新 -带block */
+ (void)setHeaderRefresnWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView headerBlock:(HeaderBlock)headerBlcok;

/**
 设置头部和尾部刷新：无动画

 @param viewController Target
 @param tableView tableView
 @param headerAction 头部方法
 @param footerAction 尾部方法
 */
+ (void)setHeaderAndFooterRefreshWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView headerAction:(SEL)headerAction footerAction:(SEL)footerAction;

/**
 只设置footer加载：无动画

 @param viewController Target
 @param tableView tableView
 @param footerAction 尾部方法
 */
+ (void)setFooterRefreshWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView footerAction:(SEL)footerAction;

/** 只设置footer加载：无动画-block */
+ (void)setFooterRefreshWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView footerBlock:(FooterBlock)footerBlock;


@end
