//
//  MYAlertView.h
//  zl
//
//  Created by a on 15/9/21.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYAlertView;
@protocol MYALertviewDelegate<NSObject>
@required
-(void)myAlertView:(MYAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index;
@end
@interface MYAlertView : UIView
@property (nonatomic, strong)UITextField  *inputTF;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (weak,nonatomic) id<MYALertviewDelegate> delegate;

// 标题加俩按钮（提示橙色,左灰色取消,右蓝色确定）
-(instancetype)initWithTitle:(NSString *) title CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;

// 标题文本俩按钮 (黑色标题，灰色单行文本,左灰色取消，右蓝色确定)
-(instancetype)initWithTitle:(NSString *) title text:(NSString *)text CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;

// 标题多行文本单按钮 (蓝色标题，灰色多行文本，中间蓝色确定按钮)
-(instancetype)initWithblueTitle:(NSString *) title text:(NSArray *)textArr OkButton:(NSString *)okButton;

// 标题加输入框俩按钮 (黑色标题,输入框，左蓝色确定，右白色取消)
-(instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancelBtn:(NSString *)cancelBtn okBtn:(NSString *)okBtn;

// 标题多行文本俩按钮 (黑色标题，多行深灰色文本，左蓝色确定，右白色取消)
-(instancetype)initWithTitle:(NSString *)title text:(NSArray *)textArr cancelButton:(NSString *)cancelButton okButton:(NSString *)okButton;

- (void)show;

@end
