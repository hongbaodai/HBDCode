//
//  HBDImmediateTapGradientView.h
//  HBD
//
//  Created by 草帽~小子 on 2019/6/5.
//  Copyright © 2019 李先生. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GradientTapAction)(void);

@interface HBDGradientTapView : UIView

@property (nonatomic, strong) UILabel *projectStatuLab;
//@property (nonatomic, strong) UIFont *font;
//@property (nonatomic, strong) NSArray<UIColor *> *colorsArr;

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, copy) GradientTapAction gradientTapAction;

- (void)timeStart;
- (void)timeFinish;

@end

NS_ASSUME_NONNULL_END
