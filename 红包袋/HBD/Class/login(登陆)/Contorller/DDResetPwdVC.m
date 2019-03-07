//
//  DDResetPwdVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/16.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
// 重置密码

#import "DDResetPwdVC.h"

@interface DDResetPwdVC ()

@property (weak, nonatomic) IBOutlet UITextField *newpwdTxf;
@property (weak, nonatomic) IBOutlet HXButton *resetBtn;

@end

@implementation DDResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = @"";

    [self.resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)resetBtnClick {
    
    if ([self canSubmitGo]) {
        [self postChangePasswordWithMobile:_phone Password:self.newpwdTxf.text PicCode:_imgCode VerifyCode:_code];
    }
    
}

- (BOOL)canSubmitGo {
    
    if (!self.newpwdTxf.text.length) {
        [MBProgressHUD showError:@"请输入新密码"];
        return NO;
    }
    if ([self.newpwdTxf.text isValidPasswordString] == NO){
        [MBProgressHUD showError:@"密码必须包含数字和字符，位数8-16位"];
        return NO;
    }

    if ([self isEmpty:self.newpwdTxf.text]
               &&[self isEmpty:self.newpwdTxf.text]) {
        [MBProgressHUD showError:@"密码不能含有空白字符"];
        return NO;
    }
    
    return YES;
}

-(BOOL)isEmpty:(NSString *) str
{
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    } else {
        return NO; //反之
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -- post
- (void)postChangePasswordWithMobile:(NSString *)mobile Password:(NSString *)password PicCode:(NSString *)picCode VerifyCode:(NSString *)verifyCode
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestChangePassword;
    info.dataParam = @{@"mobile":mobile,@"password":password,@"picCode":picCode,@"verifycode":verifyCode,@"BASE_DEAL":@"1",@"vobankIdTemp":@""};
    
    WS(weakSelf);
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        
        NSString *result = dict[@"body"][@"resultcode"];
        NSString *errorInfo = dict[@"body"][@"resultinfo"];
        
        if ([result integerValue] == 0) {
            // 成功
            [MBProgressHUD showSuccess:@"密码修改成功"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:weakSelf.newpwdTxf.text forKey:@"password"];
            [defaults synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:errorInfo];
        }
    } faild:^(NSError *error) {
    }];
}

@end
