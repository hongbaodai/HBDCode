//
//  N6SegmentedBar.h
//  Demo-ios-androidtabbar
//
//  Created by Guo Yu on 14-10-21.
//  Copyright (c) 2014年 non6. All rights reserved.
//

#import <UIKit/UIKit.h>

@class N6SegmentedBar;

@protocol N6SegmentedBarDelegate <NSObject>

@optional

-(void) segmentedBar:(N6SegmentedBar*)segmentedBar didSelectedAtIndex:(NSInteger)index;

@end

@interface N6SegmentedBar : UIView

@property (nonatomic, weak) id<N6SegmentedBarDelegate> delegate;
@property (nonatomic, copy) NSArray *itemTitles;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat titleBarHeight;

//+ (CGFloat)defaultBarHeight;

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

@end
