//
//  ViewPagerController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// Tab高
#define kDefaultTabHeight 34.0
// Offset of the second and further tabs' from left
#define kDefaultTabOffset 44.0
// 每个Tab的宽
#define kDefaultTabWidth ([UIScreen mainScreen].bounds.size.width-100)/4
// 1.0: Top, 0.0: Bottom //??????????
#define kDefaultTabLocation 1.0
// 默认选中那个Tab
#define kDefaultStartTab 0
// 默认tab与上下的间隙
#define kDefaultPadding 0
// 1.0: YES, 0.0: NO //????????
#define kDefaultCenterCurrentTab 1
//
#define kPageViewTag 34
// Tab滑动条颜色
#define kDefaultIndicatorColor [UIColor redColor]
//#define kDefaultIndicatorColor [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
// Tab背景色
#define kDefaultTabsViewBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:0.1]
// Tab 背景大View的颜色
#define kDefaultContentViewBackgroundColor [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:0.75]
// 标题默认字体


#import "ViewPagerController.h"
@class TabView;

//---@interface------- DDTitleView --------------
@interface DDTitleView : UIView

@end

@implementation DDTitleView

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setFrame:(CGRect)frame { //navTitleView

     if (@available(iOS 11.0, *)) {
         [super setFrame:CGRectMake(0, 0, SCREEN_WIDTH-65*2, 44)];

//         [super setFrame:CGRectMake(0, 0, SCREEN_WIDTH-40*2, 44)];
     } else {
         self.center = CGPointMake(self.superview.center.x, self.superview.height_/2);
         [super setFrame:CGRectMake(85, 0, SCREEN_WIDTH-65*2, 44)];

//         [super setFrame:CGRectMake(85, 0, SCREEN_WIDTH-40*2, 44)];
     }
}

@end

//---@interface------- TabView --------------
@interface TabView : UIView
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic) UIColor *titleSelectedColor;

@end

@implementation TabView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    // Update view as state changed
    [self setNeedsDisplay];
}

//绘图
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    
//    // 竖线
//    bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
//    [bezierPath addLineToPoint:CGPointMake(0.0 , kDefaultTabHeight)];
//    [[[UIColor blackColor] colorWithAlphaComponent:0.15] setStroke];//线颜色
//    [bezierPath setLineWidth:1.0];//线粗
//    [bezierPath stroke];
    
//    // 下划线
//    bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:CGPointMake(0.0, rect.size.height)];
//    [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
//    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
//    [bezierPath setLineWidth:1.0];
//    [bezierPath stroke];
    
    // 选中line
    if (self.selected) {
        
        bezierPath = [UIBezierPath bezierPath];
        
        [bezierPath moveToPoint:CGPointMake(20, rect.size.height -1)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width-25, rect.size.height- 1)];
        [bezierPath setLineWidth:3.0];
        [self.indicatorColor setStroke];
        [bezierPath stroke];
        //??????
        UILabel *label = self.subviews[0];
        label.textColor = self.titleSelectedColor;
    }
}
@end


//---@interface----- ViewPagerController --------------
@interface ViewPagerController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;
//
//@property UIScrollView *tabsView;
@property UIView *tabsView;
//
@property UIView *contentView;

@property NSMutableArray *tabs;
@property NSMutableArray *contents;

@property NSUInteger tabCount;
@property (getter = isAnimatingToTab, assign) BOOL animatingToTab;

@property (nonatomic, assign) NSUInteger activeTabIndex;

@end

@implementation ViewPagerController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark 标题点击事件
- (void)handleTapGesture:(id)sender {
    
    self.animatingToTab = YES;
    
    // Get the desired page's index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    UIView *tabView = tapGestureRecognizer.view;
    __block NSUInteger index = [_tabs indexOfObject:tabView];
    
    // Get the desired viewController
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    // __weak pageViewController to be used in blocks to prevent retaining strong reference to self
    __weak UIPageViewController *weakPageViewController = self.pageViewController;
    __weak ViewPagerController *weakSelf = self;

    if (index < self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             // Set the current page again to obtain synchronisation between tabs and content
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionReverse
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    } else if (index > self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             // Set the current page again to obtain synchronisation between tabs and content
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    }
    
    // Set activeTabIndex
    self.activeTabIndex = index;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // Re-align tabs if needed 重新校准Tabs如果需要
    self.activeTabIndex = self.activeTabIndex;
}

#pragma mark - Setter/Getter
- (void)setActiveTabIndex:(NSUInteger)activeTabIndex {
    
    TabView *lastView = [_tabs objectAtIndex:_activeTabIndex];
    UILabel *lastTitle = [lastView.subviews objectAtIndex:0];
    //    NSLog(@"%@",lastView.subviews);
    lastTitle.textColor = kDefaultTextColor;
    
    TabView *activeTabView;
    
    // Set to-be-inactive tab unselected
    activeTabView = [self tabViewAtIndex:self.activeTabIndex];
    activeTabView.selected = NO;
    
    // Set to-be-active tab selected
    activeTabView = [self tabViewAtIndex:activeTabIndex];
    activeTabView.selected = YES;
    
    // Set current activeTabIndex
    _activeTabIndex = activeTabIndex;
    
    // Inform delegate about the change
    if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex];
    }
    
    // Bring tab to active position
    // Position the tab in center if centerCurrentTab option provided as YES
    
    UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
    CGRect frame = tabView.frame;
    
    if (self.centerCurrentTab) {
        
        frame.origin.x += (frame.size.width / 2);
        frame.origin.x -= _tabsView.frame.size.width / 2;
        frame.size.width = _tabsView.frame.size.width;
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        
//        if ((frame.origin.x + frame.size.width) > _tabsView.contentSize.width) {
//            frame.origin.x = (_tabsView.contentSize.width - _tabsView.frame.size.width);
//        }
    } else {
        
        frame.origin.x -= self.tabOffset;
        frame.size.width = self.tabsView.frame.size.width;
    }
    
//    [_tabsView scrollRectToVisible:frame animated:YES];
}

#pragma mark - 默认设置
- (void)defaultSettings {
    // Default set
    _tabHeight = kDefaultTabHeight;
    _tabOffset = kDefaultTabOffset;
    _tabWidth = kDefaultTabWidth;
    _tabsHeight = kDefaultTabHeight;
    _tabLocation = kDefaultTabLocation;
    _padding = kDefaultPadding;
    
    _startFromSecondTab = kDefaultStartTab;
    _centerCurrentTab = kDefaultCenterCurrentTab;
    
    // Default colors
    _indicatorColor = [UIColor redColor];
    _tabsViewBackgroundColor = kDefaultTabsViewBackgroundColor;
    _contentViewBackgroundColor = kDefaultContentViewBackgroundColor;
    
    // pageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    //设置一些转发事件劫持滚动视图
    self.origPageScrollViewDelegate = ((UIScrollView*)[_pageViewController.view.subviews objectAtIndex:0]).delegate;
    [((UIScrollView*)[_pageViewController.view.subviews objectAtIndex:0]) setDelegate:self];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    self.animatingToTab = NO;
}

#pragma mark - reloadData
- (void)reloadData {
    
    // Get settings if provided
    if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)]) {
        _tabHeight = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabHeight withDefault:kDefaultTabHeight];
        
        _tabOffset = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabOffset withDefault:kDefaultTabOffset];
        
        
        _tabWidth = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabWidth withDefault:kDefaultTabWidth];
        
        _tabLocation = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabLocation withDefault:kDefaultTabLocation];
        
        _startFromSecondTab = [self.delegate viewPager:self valueForOption:ViewPagerOptionStartFromSecondTab withDefault:kDefaultStartTab];
        
        _centerCurrentTab = [self.delegate viewPager:self valueForOption:ViewPagerOptionCenterCurrentTab withDefault:kDefaultCenterCurrentTab];
    }
    
    // 颜色
    if ([self.delegate respondsToSelector:@selector(viewPager:colorForComponent:withDefault:)]) {
        //下划线
        _indicatorColor = [self.delegate viewPager:self colorForComponent:ViewPagerIndicator withDefault:kDefaultIndicatorColor];
        
        _tabsViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerTabsView withDefault:kDefaultTabsViewBackgroundColor];
        
        _contentViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerContent withDefault:kDefaultContentViewBackgroundColor];
        //标题
        _titleSelectedColor = [self.delegate viewPager:self colorForComponent:ViewPagerSelectedColor withDefault:nil];
        
    }
    
    // Empty tabs and contents
    [_tabs removeAllObjects];
    [_contents removeAllObjects];
    
    _tabCount = [self.dataSource numberOfTabsForViewPager:self];
    
    // Populate arrays with [NSNull null];
    _tabs = [NSMutableArray arrayWithCapacity:_tabCount];
    for (int i = 0; i < _tabCount; i++) {
        [_tabs addObject:[NSNull null]];
    }
    
    _contents = [NSMutableArray arrayWithCapacity:_tabCount];
    for (int i = 0; i < _tabCount; i++) {
        [_contents addObject:[NSNull null]];
    }
    
    //  DDTitleView
    DDTitleView *titleView = [[DDTitleView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    
   //  tabsView
    _tabsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleView.width_, titleView.height_)];
//    _tabsView.center = titleView.center;
//    _tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabsView.backgroundColor = [UIColor clearColor];
//    _tabsView.showsHorizontalScrollIndicator = NO;
//    _tabsView.showsVerticalScrollIndicator = NO;
//    _tabsView.userInteractionEnabled = NO;
//    _tabsView.multipleTouchEnabled = NO;
 // ps:测试说不让滚动scrollview换成view了
    
    [titleView insertSubview:_tabsView atIndex:0];
    self.navigationItem.titleView = titleView;

   
    
    // 添加_tabsView的item
    CGFloat contentSizeWidth = 0;
    for (int i = 0; i < _tabCount; i++) {
        
        UIView *tabView = [self tabViewAtIndex:i];
        
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = self.tabWidth;
        tabView.frame = frame;
        [_tabsView addSubview:tabView];
        
        contentSizeWidth += tabView.frame.size.width;
        tabView.userInteractionEnabled = YES;
        tabView.multipleTouchEnabled = YES;
        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
    }
    
//    _tabsView.contentSize = CGSizeMake(contentSizeWidth, self.tabsHeight);
    
    // Add contentView
    _contentView = [self.view viewWithTag:kPageViewTag];
    
    if (!_contentView) {
        
        _contentView = _pageViewController.view;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = self.contentViewBackgroundColor;
        _contentView.bounds = self.view.bounds;
        _contentView.tag = kPageViewTag;
        
        [self.view insertSubview:_contentView atIndex:0];
    }
    
    // Set first viewController
    UIViewController *viewController;
//#warning 起始页的设置
//    if (self.startFromSecondTab) {
//        viewController = [self viewControllerAtIndex:1];
//    } else {
//        viewController = [self viewControllerAtIndex:0];
//    }
    if (!self.startFromSecondTab) {
        self.startFromSecondTab = 0;
    }
    viewController = [self viewControllerAtIndex:self.startFromSecondTab];
    
    if (viewController == nil) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
    }
    [_pageViewController setViewControllers:@[viewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    // Set activeTabIndex
    self.activeTabIndex = self.startFromSecondTab;
    
    
}


- (TabView *)tabViewAtIndex:(NSUInteger)index {
    
    if (index >= _tabCount) {
        return nil;
    }
    
    if ([[_tabs objectAtIndex:index] isEqual:[NSNull null]]) {

        // Get view from dataSource
        UIView *tabViewContent = [self.dataSource viewPager:self viewForTabAtIndex:index];
        
        // Create TabView and subview the content        
        TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tabWidth, self.tabsHeight)];
        [tabView addSubview:tabViewContent];
        [tabView setClipsToBounds:YES];
        [tabView setIndicatorColor:self.indicatorColor];
        [tabView setTitleSelectedColor:self.titleSelectedColor];
        tabViewContent.center = tabView.center;
        
        // Replace the null object with tabView
        [_tabs replaceObjectAtIndex:index withObject:tabView];
    }
    
    return [_tabs objectAtIndex:index];
}
- (NSUInteger)indexForTabView:(UIView *)tabView {
    
    return [_tabs indexOfObject:tabView];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= _tabCount) {
        return nil;
    }
    
    if ([[_contents objectAtIndex:index] isEqual:[NSNull null]]) {
        
        UIViewController *viewController;
        
        if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)]) {
            viewController = [self.dataSource viewPager:self contentViewControllerForTabAtIndex:index];
        } else if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewForTabAtIndex:)]) {
            
            UIView *view = [self.dataSource viewPager:self contentViewForTabAtIndex:index];
            
            // Adjust view's bounds to match the pageView's bounds
            UIView *pageView = [self.view viewWithTag:kPageViewTag];
            view.frame = pageView.bounds;
            
            viewController = [UIViewController new];
            viewController.view = view;
        } else {
            viewController = [[UIViewController alloc] init];
            viewController.view = [[UIView alloc] init];
        }
        
        [_contents replaceObjectAtIndex:index withObject:viewController];
    }
    
    return [_contents objectAtIndex:index];
}
- (NSUInteger)indexForViewController:(UIViewController *)viewController {
    
    return [_contents indexOfObject:viewController];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexForViewController:viewController];
    index++;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexForViewController:viewController];
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    self.activeTabIndex = [self indexForViewController:viewController];
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.origPageScrollViewDelegate scrollViewDidScroll:scrollView];
    }
    
    if (![self isAnimatingToTab]) {
        UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
        
        // Get the related tab view position
        CGRect frame = tabView.frame;
        
        CGFloat movedRatio = (scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
        frame.origin.x += movedRatio * frame.size.width;
        
        if (self.centerCurrentTab) {
            
            frame.origin.x += (frame.size.width / 2);
            frame.origin.x -= _tabsView.frame.size.width / 2;
            frame.size.width = _tabsView.frame.size.width;
            
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
            }
            
//            if ((frame.origin.x + frame.size.width) > _tabsView.contentSize.width) {
//                frame.origin.x = (_tabsView.contentSize.width - _tabsView.frame.size.width);
//            }
        } else {
            
            frame.origin.x -= self.tabOffset;
            frame.size.width = self.tabsView.frame.size.width;
        }
        
//        [_tabsView scrollRectToVisible:frame animated:NO];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.origPageScrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.origPageScrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return NO;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.origPageScrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate, Managing Zooming
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.origPageScrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.origPageScrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling Animations
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end
