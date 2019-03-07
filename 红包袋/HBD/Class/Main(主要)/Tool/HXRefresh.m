//  HXRefresh.m
//  test
//
//  Created by hongbaodai on 2017/8/3.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXRefresh.h"
#import "HXRefreshGitHeader.h"

@implementation HXRefresh

/** 设置头部的刷新 */
+ (void)setHeaderRefresnWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView headerAction:(SEL)action
{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:viewController refreshingAction:action];
    UIEdgeInsets dge = tableView.separatorInset;
    dge.top = 0;
    tableView.separatorInset = dge;
    tableView.mj_header = header;
   
    /*加载动态图，把上面的注掉，下面的打开即可
    HXRefreshGitHeader *header = [HXRefreshGitHeader headerWithRefreshingTarget:viewController refreshingAction:action];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;
    */
}

/** 设置头部的刷新 */
+ (void)setHeaderRefresnWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView headerBlock:(HeaderBlock)headerBlcok
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        headerBlcok();
    }];
    UIEdgeInsets dge = tableView.separatorInset;
    dge.top = 0;
    tableView.separatorInset = dge;
    tableView.mj_header = header;
    
    /*加载动态图，把上面的注掉，下面的打开即可
    HXRefreshGitHeader *header = [HXRefreshGitHeader headerWithRefreshingBlock:^{
        headerBlcok();
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;
    */
}

/** 设置头部和尾部刷新：无动画 */
+ (void)setHeaderAndFooterRefreshWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView headerAction:(SEL)headerAction footerAction:(SEL)footerAction
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:viewController refreshingAction:headerAction];
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:viewController refreshingAction:footerAction];
    UIEdgeInsets dge = tableView.separatorInset;
    dge.top = 0;
    tableView.separatorInset = dge;
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    tableView.mj_header = header;
    tableView.mj_footer = footer;

    /*加载动态图，把上面头部的注掉，下面打开
    HXRefreshGitHeader *header = [HXRefreshGitHeader headerWithRefreshingTarget:viewController refreshingAction:headerAction];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;
     */
}

/** 只设置footer加载：无动画 */
+ (void)setFooterRefreshWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView footerAction:(SEL)footerAction
{
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:viewController refreshingAction:footerAction];
    
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    tableView.mj_footer = footer;

}

/** 只设置footer加载：无动画-block */
+ (void)setFooterRefreshWithVC:(UIViewController *)viewController tableView:(UITableView *)tableView footerBlock:(FooterBlock)footerBlock
{
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        footerBlock();
    }];
    
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    tableView.mj_footer = footer;

}



@end
