//
//  BXChangePasswordController.m
//  HBD
//
//  Created by echo on 15/9/11.
//

#import "BXChangePasswordController.h"
#import "BXLoginViewController.h"
#import "NSString+Other.h"
#import "AppUtils.h"

@interface BXChangePasswordController ()<UITextFieldDelegate,UIAlertViewDelegate>

// 原密码
@property (nonatomic, weak) IBOutlet UITextField *originalPwdTextField;
// 新密码
@property (nonatomic, weak) IBOutlet UITextField *nnewPwdTextField;
// 确认新密码
@property (nonatomic, weak) IBOutlet UITextField *confirmPwdTextField;
// 图片验证码输入框
@property (nonatomic, weak) IBOutlet UITextField *imageVerifyCodeTextfield;
// 图片验证码
@property (nonatomic, weak) IBOutlet UIImageView *imageVerifyCodeView;
// 点击刷新图片
- (IBAction)didClickImageToRefreshImage:(id)sender;

@property (nonatomic, copy) NSString *userNum;

@end

@implementation BXChangePasswordController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userStr = [defaults objectForKey:@"username"];
    self.userNum = userStr;
    
    [self getPictureCheckCode];
}

// 点击刷新图片
- (IBAction)didClickImageToRefreshImage:(id)sender
{
    [self getPictureCheckCode];
}

/** 获取图片验证码 **/
- (void)getPictureCheckCode
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSURL *imageUrl = [self getImageUrl];
    UIImage *image = [self getImageFromUrl:imageUrl];
    
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageVerifyCodeView.image = image;
        });
    });
}

- (UIImage *)getImageFromUrl:(NSURL *)url
{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:url];
    result = [UIImage imageWithData:data];
    return result;
}

////通过转换获取url
- (NSURL *)getImageUrl
{
    NSString *key =  @"CFBundleShortVersionString";
    // 3.2获取软件当前版本号
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *baseUrl = [NSString stringWithFormat:@"%@/p2p/SourcePortal?", BXNETURL];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@service=%@&head={\"sessionId\":\"%@\"}&client={\"plat\":\"ios\",\"version\":\"%@\"}",baseUrl,BXRequestPictureCheckCode,[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"],infoDict[key]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

-(BOOL)isEmpty:(NSString *) str
{
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}
- (IBAction)changePwdBtnClick:(id)sender
{
    if (!self.originalPwdTextField.text.length) {
        [MBProgressHUD showError:@"请输入原密码"];
    }else if (!self.nnewPwdTextField.text.length){
        [MBProgressHUD showError:@"请输入新密码"];
    }
//    else if (self.nnewPwdTextField.text.length < 8){
//        [MBProgressHUD showError:@"新密码长度过短"];
//    }else if (self.nnewPwdTextField.text.length > 16){
//        [MBProgressHUD showError:@"新密码长度过长"];
//    }
    else if ([self isEmpty:self.nnewPwdTextField.text]) {
        [MBProgressHUD showError:@"密码不能含有空白字符"];
    } else if ([self.nnewPwdTextField.text isValidPasswordString] == NO) {
        [MBProgressHUD showError:@"密码必须包含数字和字符，位数8-16位"];
    }
    else if (![self.nnewPwdTextField.text isEqualToString:self.confirmPwdTextField.text]){
        [MBProgressHUD showError:@"两次输入密码不一致"];
    }else if (!self.imageVerifyCodeTextfield.text.length){
        [MBProgressHUD showError:@"请输入图片验证码"];
    }else{
        [self postResetPasswordWithOldPwd:self.originalPwdTextField.text NewPwd:self.nnewPwdTextField.text Code:self.imageVerifyCodeTextfield.text];
    }
}

/* 修改登录密码 */
- (void)postResetPasswordWithOldPwd:(NSString *)oldPwd NewPwd:(NSString *)newPwd Code:(NSString *)imageCode
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestResetPassword;
    info.dataParam = @{@"oldPassword":oldPwd,@"newPassword":newPwd,@"code":imageCode,@"BASE_DEAL":@"1",@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        if (![dict[@"body"][@"resultcode"] intValue]) {
            [self savePWD];
            [self reLogin];
            
        }else{
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }

    } faild:^(NSError *error) {
        
    }];
}

- (void)savePWD
{
    NSString *newPWD = [NSString MD5:self.nnewPwdTextField.text];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newPWD forKey:@"password"];
    [defaults synchronize];
}
/** 修改密码成功重新登录 */
- (void)reLogin
{
    WS(weakSelf)
    [AppUtils alertWithVC:self title:@"修改成功,请重新登录" messageStr:nil enSureBlock:^{
        [weakSelf stepNextPage];
    }];
}
/** 跳转登录页 */
- (void)stepNextPage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.loginStyle = DDLoginStyleChangePwd;
    loginVC.isPresentedWithMyAccount = YES;
    
    BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:Nav animated:YES completion:nil];
}

#pragma mark - viewTouch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.originalPwdTextField resignFirstResponder];
    [self.nnewPwdTextField resignFirstResponder];
    [self.confirmPwdTextField resignFirstResponder];
    [self.imageVerifyCodeTextfield resignFirstResponder];
}

/** 创建BXChangePasswordController */
+ (instancetype)creatVCFromSB
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    BXChangePasswordController *changePwdVC = [sb instantiateViewControllerWithIdentifier:@"BXChangePasswordController"];
    return changePwdVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
