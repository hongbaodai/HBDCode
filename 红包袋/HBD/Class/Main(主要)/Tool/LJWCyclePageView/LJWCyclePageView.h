//
//  LJWCyclePageView.h
//  CycleCollectionViewTest
//
//  Created by ljw on 15/3/28.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LJWPageControlPosition)
{
    LJWPageControlPositionDefault = 0,
    LJWPageControlPositionLeft,
    LJWPageControlPositionRight,
    LJWPageControlPositionCenter,
};

@class LJWCyclePageView;
@protocol LJWCyclePageViewDelegate <NSObject>

@required;

- (NSInteger)numberOfItems;

- (UIView *)ljwCyclePageView:(LJWCyclePageView *)ljwCyclePageView viewForIndex:(NSInteger)index;

@optional;
- (void)ljwCyclePageView:(LJWCyclePageView *)ljwCyclePageView didSelectedView:(UIView *)view atIndex:(NSInteger)index;

@end

@interface LJWCyclePageView : UIView

/**
 *  cell总数
 */
@property (nonatomic, assign, readonly) NSInteger numberOfItems;

/**
 *  代理
 */
@property (nonatomic, weak) id<LJWCyclePageViewDelegate> delegate;

/**
 *  是否自动滚
 */
@property (nonatomic, assign, setter=autoCycle:) BOOL autoCycle;

/**
 *  pageControl位置
 */
@property (nonatomic, assign, setter=setPageControlPosition:) LJWPageControlPosition pageControlPosition;

/**
 *  pageControl
 */
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

/**
 *  当前index
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/**
 *  初始化
 *
 *  @param frame    frame
 *  @param delegate 代理
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LJWCyclePageViewDelegate>)delegate;

/**
 *  滚到第几个cell
 *
 *  @param index    下表
 *  @param animated 是否动画
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  开始自动滚
 */
- (void)startAutoCycle;

/**
 *  暂停自动滚
 */
- (void)pauseAutoCycle;

/**
 *  重新加载数据
 */
- (void)reloadData;

@end
