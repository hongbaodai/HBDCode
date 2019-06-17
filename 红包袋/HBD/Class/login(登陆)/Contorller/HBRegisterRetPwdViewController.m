//
//  HBRegisterRetPwdViewController.m
//  HBD
//
//  Created by 草帽~小子 on 2019/6/11.
//  Copyright © 2019 李先生. All rights reserved.
//

#import "HBRegisterRetPwdViewController.h"
#import "DDRegisterSuccessVC.h"

@interface HBRegisterSetPwdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) UITextField *passwordTextF;
@property (nonatomic, strong) UITextField *investTextF;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation HBRegisterSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViews];
}

- (void)setUpViews {
    //112x31
    CGFloat h = SCREEN_WIDTH / 375 * 31;
    CGFloat w = h / 31 * 112;
    self.topImgV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - w) / 2, 17, w, h)];
    self.topImgV.image = [UIImage imageNamed:@"logoImageView"];
    [self.view addSubview:self.topImgV];
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(10, self.topImgV.bottom + 50, SCREEN_WIDTH - 20, 98)];
    [self.view addSubview:back];
    
    self.passwordTextF = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, back.width, 29)];
    self.passwordTextF.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextF.secureTextEntry = YES;
    self.passwordTextF.placeholder = @"请设置密码，长度在6-8位";
    self.passwordTextF.clearsOnBeginEditing = YES;
    self.passwordTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextF.delegate = self;
    [back addSubview:self.passwordTextF];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, back.width, 1)];
    line1.backgroundColor = kColor_Line_Gray;
    [back addSubview:line1];
    
    self.investTextF = [[UITextField alloc] initWithFrame:CGRectMake(0, line1.bottom + 10, back.width, 29)];
    self.investTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.investTextF.placeholder = @"邀请码或邀请人手机号（选填）";
    self.investTextF.clearsOnBeginEditing = YES;
    self.investTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.investTextF.delegate = self;
    [back addSubview:self.investTextF];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 97, back.width, 1)];
    line2.backgroundColor = kColor_Line_Gray;
    [back addSubview:line2];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.frame = CGRectMake(10, back.bottom + 70, SCREEN_WIDTH - 20, 40);
    self.nextBtn.layer.cornerRadius = 20;
    self.nextBtn.layer.masksToBounds= YES;
    [self.view addSubview:self.nextBtn];
    [self.nextBtn setTitle:@"领取新手豪礼" forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextBtnAciotn:) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.nextBtn.bounds;
    layer.colors = @[(__bridge id)kColor_Red_Main.CGColor, (__bridge id)kColor_Red_Light.CGColor];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    [self.nextBtn.layer addSublayer:layer];
}

- (void)nextBtnAciotn:(UIButton *)send{
    if ([self canSubmitGo]) {
        [self postRegisterWithMobile:self.phoneNumString password:self.passwordTextF.text PicCode:self.imgVerifyCode CdKey:self.investTextF.text PhoneCode:self.verifyCode];
    }
}

- (BOOL)canSubmitGo {
    if (!self.phoneNumString) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return NO;
    } else if (![self.phoneNumString n6_isMobile]){
        // 请输入正确手机号
        [MBProgressHUD showError:@"请输入正确手机号"];
        return NO;
    } else if (!self.imgVerifyCode){
        // 请输入图形验证码
        [MBProgressHUD showError:@"请输入图形验证码"];
        return NO;
    }
    if (!self.verifyCode) {
        [MBProgressHUD showError:@"请输入验证码"];
        return NO;
    }
    if (!self.passwordTextF.text.length) {
        [MBProgressHUD showError:@"请输入密码"];
        return NO;
    }
    return YES;
}

/** 注册 **/
- (void)postRegisterWithMobile:(NSString *)mobile password:(NSString *)password PicCode:(NSString *)picCode CdKey:(NSString *)cdKey PhoneCode:(NSString *)phoneCode{
    //phoneCode 为手机验证码，从功能要后台添加相应参数，暂时未处理
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestRegister;
    cdKey = cdKey.length ? cdKey : @"";
    info.dataParam =@{@"mobilePhone":mobile,
                      @"password":password,
                      @"picCode":picCode,
                      @"cdKey":cdKey,
                      @"roles":@"1",
                      @"verifycode":phoneCode,
                      @"BASE_DEAL":@"1",
                      @"vobankIdTemp":@""};
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        NSString *result = dict[@"body"][@"resultcode"];
        NSString *errorInfo = dict[@"body"][@"resultinfo"];
        if ([result integerValue] == 0) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"注册成功"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = dict[@"body"][@"userId"];
            [defaults setObject:userId forKey:@"userId"];
            //注册成功，保存登录状态
            [self postLoginWithUserName:self.phoneNumString password:self.passwordTextF.text];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDRegisterSuccessVC" bundle:nil];
            DDRegisterSuccessVC *vc = [sb instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorInfo];
        }
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

/* post登录 */
- (void)postLoginWithUserName:(NSString *)userName password:(NSString *)password{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"userName":userName,@"password":password};
    info.serviceString = BXRequestLogin;
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:
     ^(id responseObject) {
         NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
         if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:@(1) forKey:DDKeyLoginState];
             [LLLockPassword saveLockPassword:@""];
             [defaults setObject:userName forKey:@"username"];
             [defaults setObject:[NSString encodeByMd5AndSalt:password] forKey:@"password"];
             [defaults setObject:dict[@"body"][@"_U"] forKey:@"userId"];
             [defaults setObject:dict[@"body"][@"_T"] forKey:@"_T"];
             [defaults setObject:dict[@"body"][@"roles"] forKey:@"roles"];
             [defaults setObject:dict[@"body"][@"usergroup"] forKey:@"usergroup"];
             [defaults setObject:dict[@"body"][@"mobile"] forKey:@"phoneNumber"];
             [defaults setObject:dict[@"body"][@"khfs"] forKey:@"khfs"];
             [defaults setObject:dict[@"body"][@"TS"] forKey:@"TS"];
             [defaults setObject:dict[@"body"][@"QP"] forKey:@"QP"];
             if (dict[@"body"][@"vipFlag"] == nil) {    //是不是vip
                 [defaults setObject:@"0" forKey:DDUserVipState];
             } else {
                 [defaults setObject:dict[@"body"][@"vipFlag"] forKey:DDUserVipState];
             }
             if (dict[@"body"][@"sessionId"]) {
                 [defaults setObject:dict[@"body"][@"sessionId"] forKey:@"sessionId"];
             }
             [defaults synchronize];
         }
     }faild:^(NSError *error) {
         
     }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.passwordTextF == textField) {
        if ([self.passwordTextF.text length] < 6 || [self.passwordTextF.text length] > 8) {
            [self.passwordTextF.text substringToIndex:8];
            return NO;
        }
    }
    if (self.investTextF == textField) {
        if ([toBeString length] > 11) {
            [self.investTextF.text substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

@end
