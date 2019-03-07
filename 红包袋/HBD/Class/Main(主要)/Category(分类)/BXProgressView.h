//
//  BXProgressView.h
//  sinvo
//
//  Created by 李先生 on 15/4/1.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXProgressView : UIView

/** 进度数值 */
@property (nonatomic, assign) CGFloat progressViewLab;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end
