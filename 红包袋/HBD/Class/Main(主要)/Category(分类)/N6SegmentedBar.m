//
//  N6SegmentedBar.m
//  Demo-ios-androidtabbar
//
//  Created by Guo Yu on 14-10-21.
//  Copyright (c) 2014年 non6. All rights reserved.
//

#import "N6SegmentedBar.h"

//#define kSegmentedBarHeight     38.0f
//#define kBottomLineHeight       2.0f
#define kBottomLineWidth        64.0f
#define kSideLineWidth          1.0f
#define kSideLineHeight         24.f
//#define kButtonHeight           (kSegmentedBarHeight - kBottomLineHeight)
#define kMinimalButtonWidth     76.0f

#define kDefaultTitleColor      UIColorFromRGBValue(0x999999)
#define kDefaultSelectedTitleColor  UIColorFromRGBValue(0x454545)
//#define kDefaultSelectedTitleColor  UIColorFromRGBDecValue(56,188,117)

#define kDefaultTitleFont       [UIFont systemFontOfSize:14]

@interface N6SegmentedBarScrollView : UIScrollView
@end
@implementation N6SegmentedBarScrollView
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}
@end

@implementation N6SegmentedBar {
    CGFloat buttonWidth_;
    N6SegmentedBarScrollView *barScrollView_;
    NSMutableArray *itemButtons_;
    NSMutableArray *itemSideLineViews_;
    UIView *itemBottomLineView_;
}


#pragma mark - Override
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        [self sharedInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self sharedInit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect vBounds = self.bounds;
    
    if (vBounds.size.width < kMinimalButtonWidth * 2 || vBounds.size.height < self.titleBarHeight) {
        return;
    }
    
    if (!CGRectEqualToRect(vBounds, barScrollView_.frame)) {
        barScrollView_.frame = vBounds;
        [self layoutBarScrollView];
    }
}


#pragma mark - Private
- (void)sharedInit {
    CGRect vBounds = self.bounds;
    barScrollView_ = [[N6SegmentedBarScrollView alloc]initWithFrame:vBounds];
    barScrollView_.backgroundColor = [UIColor clearColor];
    barScrollView_.userInteractionEnabled = YES;
    barScrollView_.showsHorizontalScrollIndicator = NO;
    barScrollView_.showsVerticalScrollIndicator = NO;
    barScrollView_.scrollsToTop = NO;
    [self addSubview:barScrollView_];
}

- (void)layoutBarScrollView {
    NSUInteger count = _itemTitles.count;
    if (count < 1) {
        return;
    }
    
    if (nil == self.titleColor) {
        self.titleColor = kDefaultTitleColor;
    }
    if (nil == self.titleSelectedColor) {
        self.titleSelectedColor = kDefaultSelectedTitleColor;
    }
    if (nil == self.titleFont) {
        self.titleFont = kDefaultTitleFont;
    }
    
    barScrollView_.frame = self.bounds;
    
    CGRect rect = barScrollView_.frame;
    CGFloat wantedWidth = kMinimalButtonWidth * count + kSideLineWidth * (count - 1);
    if (wantedWidth > rect.size.width) {
        buttonWidth_ = kMinimalButtonWidth;
        barScrollView_.contentSize = CGSizeMake(wantedWidth, rect.size.height);
    } else {
        barScrollView_.contentSize = rect.size;
        buttonWidth_ = (rect.size.width - kSideLineWidth * (count - 1)) / count;
    }
    
    if (itemButtons_ == nil) {
        itemButtons_ = [NSMutableArray new];
        for (int i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [itemButtons_ addObject:button];
        }
    }
    
    for (int i = 0; i < count; i++) {
        CGFloat interval = (i > 0) ? kSideLineWidth : 0.0f;
        CGRect buttonRect = CGRectMake((buttonWidth_ + interval) * i, 0, buttonWidth_, self.titleBarHeight - 2);
        UIButton *button = itemButtons_[i];
        button.frame = buttonRect;
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        button.titleLabel.font = self.titleFont;
        [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [button setTitle:_itemTitles[i] forState:UIControlStateNormal];
        if (nil == button.superview) {
            [barScrollView_ addSubview:button];
        }
    }
    
    if (count > 1) {
        if (itemSideLineViews_ == nil) {
            itemSideLineViews_ = [NSMutableArray new];
            for (int i = 0; i < count - 1; i++) {
                UIView *sideLineView = [[UIView alloc]initWithFrame:CGRectZero];
                [itemSideLineViews_ addObject:sideLineView];
            }
        }
        
        for (int i = 0; i < count - 1; i++) {
            CGFloat x = (i == 0) ? buttonWidth_ : (buttonWidth_ + (buttonWidth_ + kSideLineWidth) * i);
            CGRect sideLineRect = CGRectMake(x, (rect.size.height - kSideLineHeight) / 2.0f, kSideLineWidth, kSideLineHeight);
            UIView *sideLineView = itemSideLineViews_[i];
            sideLineView.frame = sideLineRect;
            sideLineView.backgroundColor = UIColorFromRGBValue(0xcccccc);
            sideLineView.userInteractionEnabled = NO;
            if (nil == sideLineView.superview) {
                [barScrollView_ addSubview:sideLineView];
            }
        }
    }
    
    if (itemBottomLineView_ == nil) {
        itemBottomLineView_ = [[UIView alloc]initWithFrame:CGRectZero];
        [barScrollView_ addSubview:itemBottomLineView_];
    }
    itemBottomLineView_.backgroundColor = self.titleSelectedColor;
    
    [self setSelectedIndex:_selectedIndex animated:NO];
}

#pragma mark - IBAction
- (IBAction)onButtonPressed:(UIButton*)button {
    [self setSelectedIndex:button.tag animated:YES];
}


#pragma mark - Public
//+ (CGFloat)defaultBarHeight {
//    return N6SegmentedBar.titleBarHeight;
//}

- (void)setItemTitles:(NSArray *)itemTitles {
    if (_itemTitles) {
        for (UIView *subView in [barScrollView_ subviews]) {
            [subView removeFromSuperview];
        }
        itemButtons_ = nil;
        itemSideLineViews_ = nil;
        itemBottomLineView_ = nil;
        _itemTitles = nil;
        _selectedIndex = 0;
    }
    if (itemTitles || itemTitles.count > 0) {
        _itemTitles = [itemTitles copy];
        [self layoutBarScrollView];
    }
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if ( selectedIndex < 0 || selectedIndex >= self.itemTitles.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    UIButton *button = itemButtons_[_selectedIndex];
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    for (UIButton *subButton in itemButtons_) {
        if (subButton != button) {
            subButton.selected = NO;
        }
    }
    
    CGRect sRect = barScrollView_.frame;
    CGRect sBounds = barScrollView_.bounds;
    
    CGFloat interval = (button.tag > 0) ? kSideLineWidth : 0.0f;
    CGFloat bottomLineX = (buttonWidth_ - kBottomLineWidth) / 2.0f;
    CGRect bottomLineRect = CGRectMake((buttonWidth_ + interval) * button.tag + bottomLineX,
                                       sRect.size.height - 2,
                                       kBottomLineWidth, 2);
    if (animated) {
        [UIView animateWithDuration:0.20f
                         animations:^{
                             itemBottomLineView_.frame = bottomLineRect;
                         }
                         completion:^(BOOL finished) {
                             if ([self.delegate respondsToSelector:@selector(segmentedBar:didSelectedAtIndex:)]) {
                                 [self.delegate segmentedBar:self didSelectedAtIndex:button.tag];
                             }
                         }];
    } else {
        itemBottomLineView_.frame = bottomLineRect;
        if ([self.delegate respondsToSelector:@selector(segmentedBar:didSelectedAtIndex:)]) {
            [self.delegate segmentedBar:self didSelectedAtIndex:button.tag];
        }
    }
    
    CGRect bRect = button.frame;
    if (!CGRectContainsRect(sBounds, button.frame)) {
        if (sBounds.origin.x > bRect.origin.x) {
            [barScrollView_ setContentOffset:CGPointMake(bRect.origin.x, 0.0f)
                                    animated:animated];
        } else {
            CGPoint offset = sBounds.origin;
            offset.x += CGRectGetMaxX(bRect) - CGRectGetMaxX(sBounds);
            [barScrollView_ setContentOffset:offset
                                    animated:animated];
        }
    }
}
//
//- (void)dealloc
//{
//    self.delegate = nil;
//}

@end
