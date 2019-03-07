//
//  LDAccountView.h
//  HBD
//
//  Created by hongbaodai on 2018/4/4.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBlock)(void);

@interface LDAccountView : UIView

@property (nonatomic, copy) SureBlock sureBlock;

@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;

@property (nonatomic, strong) NSArray *dataArr;

+ (instancetype)createLDAccountViewWithFrame:(CGRect)frame;

@end
