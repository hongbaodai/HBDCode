//
//  LDAccountEQianBaoView.h
//  HBD
//
//  Created by hongbaodai on 2018/7/3.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBlock)(void);
typedef void(^ProtoBlock)(void);

@interface LDAccountEQianBaoView : UIView


@property (nonatomic, copy) SureBlock sureBlock;
@property (nonatomic, copy) ProtoBlock protoBlock;


@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;


+ (instancetype)createLDAccountViewWithFrame:(CGRect)frame;

@end
