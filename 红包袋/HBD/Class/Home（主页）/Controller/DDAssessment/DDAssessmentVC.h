//
//  DDAssessmentVC.h
//  HBD
//
//  Created by hongbaodai on 17/5/5.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNormolViewController.h"

@interface DDAssessmentVC : BaseNormolViewController

@property (nonatomic, assign) NSInteger pathScore;
/**
 创建DDAssessmentVC
 
 @return DDAssessmentVC
 */
+ (instancetype)creatVCFromStroyboard;

/**
 风险评估数据
 */
@property (nonatomic, strong) NSDictionary *dic;

@end
