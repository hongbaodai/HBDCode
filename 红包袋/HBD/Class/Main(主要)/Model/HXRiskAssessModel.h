//
//  HXRiskAssessModel.h
//  HBD
//
//  Created by hongbaodai on 2017/12/21.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDRiskAssessViewController.h"

@interface HXRiskAssessModel : NSObject

// 创建HXRiskAssessModel
+ (instancetype)shareRiskModel;

// 创建DDRiskAssessViewController控制器
- (DDRiskAssessViewController *)creaAssessVC;

@end
