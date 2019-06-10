//
//  ExperienceProjectView.h
//  HBD
//
//  Created by 草帽~小子 on 2019/6/5.
//  Copyright © 2019 李先生. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ExperienceTapAction)();

@interface ExperienceProjectView : UIView

@property (nonatomic, strong) UIImageView *tagImgV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *percentLab;
@property (nonatomic, strong) UILabel *ratePerYear;
@property (nonatomic, strong) UILabel *dayTime;
@property (nonatomic, strong) UILabel *deadline;
@property (nonatomic, copy) ExperienceTapAction experienceTapAction;

@end

NS_ASSUME_NONNULL_END
