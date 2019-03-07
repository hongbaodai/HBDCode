//
//  ViewPagerController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultTextColor        [UIColor colorWithHexString:@"#F88B8B"]


typedef NS_ENUM(NSUInteger, ViewPagerOption) {
    ViewPagerOptionTabHeight,
    ViewPagerOptionTabOffset,
    ViewPagerOptionTabWidth,
    ViewPagerOptionTabLocation,
    ViewPagerOptionStartFromSecondTab,
    ViewPagerOptionCenterCurrentTab
};

typedef NS_ENUM(NSUInteger, ViewPagerComponent) {
    ViewPagerIndicator,
    ViewPagerTabsView,
    ViewPagerContent,
    ViewPagerSelectedColor
};

@protocol ViewPagerDataSource;
@protocol ViewPagerDelegate;

@interface ViewPagerController : UIViewController

@property id<ViewPagerDataSource> dataSource;
@property id<ViewPagerDelegate> delegate;

#pragma mark ViewPagerOptions
// Tab bar's height, defaults to 49.0
@property CGFloat tabHeight;

//  视图与上下的间隙
@property (nonatomic, assign) CGFloat padding;
// 滚动视图的高度
@property (nonatomic, assign) CGFloat tabsHeight;
// Tab bar's offset from left, defaults to 56.0
@property CGFloat tabOffset;
// Any tab item's width, defaults to 128.0. To-do: make this dynamic
@property CGFloat tabWidth;

// 1.0: Top, 0.0: Bottom, changes tab bar's location in the screen
// Defaults to Top
@property CGFloat tabLocation;

// 1.0: YES, 0.0: NO, defines if view should appear with the second or the first tab
// Defaults to NO //设置起始页是第一页还是第二页
@property NSInteger startFromSecondTab;

// 1.0: YES, 0.0: NO, defines if tabs should be centered, with the given tabWidth
// Defaults to NO
@property CGFloat centerCurrentTab;

#pragma mark Colors
// Colors for several parts
@property UIColor *indicatorColor;
@property UIColor *tabsViewBackgroundColor;
@property UIColor *contentViewBackgroundColor;

@property UIColor *titleSelectedColor;

#pragma mark Methods
// Reload all tabs and contents
- (void)reloadData;

@end

#pragma mark dataSource
@protocol ViewPagerDataSource <NSObject>
//返回多少组
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager;

//设置组显示文字
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index;

@optional
//创建组控制器
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
- (UIView *)viewPager:(ViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index;

@end

#pragma mark delegate
@protocol ViewPagerDelegate <NSObject>

@optional
//如果想要被告知委托对象必须实现此方法时，标签的变化
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index;

//每一次 - reloadData调用时， ViewPager将要求其委托的选项值
//所以你不必从ViewPager本身设置选项
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value;

//ViewPagerIndicator, //滑动条颜色
//ViewPagerTabsView, //滑动导航背景色
//ViewPagerContent  //内容
///设置滑动条颜色
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color;

@end
