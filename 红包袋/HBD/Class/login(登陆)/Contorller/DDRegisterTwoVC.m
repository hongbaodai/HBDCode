//
//  DDRegisterTwoVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/13.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDRegisterTwoVC.h"
#import "JKCountDownButton.h"
#import "BXReminderPageController.h"
#import "DDWebViewVC.h"
#import "DDRegisterSuccessVC.h"
#import "HXWebVC.h"
#import "HXAlertAccount.h"
#import "HBRegisterRetPwdViewController.h"

@interface DDRegisterTwoVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *codeTxf;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
@property (weak, nonatomic) IBOutlet HXButton *sureBtn;
@property (weak, nonatomic) IBOutlet MPCheckboxButton *readXyBtn;
@property (weak, nonatomic) IBOutlet UIButton *zcxyBtn;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTxf;
@property (weak, nonatomic) IBOutlet UIImageView *imgCodeImgView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (nonatomic, assign) BOOL voiceBtnHasSelected;

@end

@implementation DDRegisterTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViewUIS];
    
    [self getPictureCheckCode];
    self.imgCodeImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPictureCheckCode)];
    [self.imgCodeImgView addGestureRecognizer:tap];
}

- (void)initViewUIS {
    [self.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.zcxyBtn addTarget:self action:@selector(zcxyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.voiceBtn.userInteractionEnabled = NO;
    [self.voiceBtn addTarget:self action:@selector(voiceBtn:) forControlEvents:UIControlEventTouchUpInside];
}
/** 点击获取验证码 */
- (void)codeBtnClick {
    if (!self.phoneNum.text.length) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return ;
    } else if (![self.phoneNum.text n6_isMobile]){
        // 请输入正确手机号
        [MBProgressHUD showError:@"请输入正确手机号"];
        return ;
    }
    [self postSendMessageCodeWithMobile:self.phoneNum.text PicCode:self.imgCodeTxf.text];
}

//* 点击领取红包
- (void)sureBtnClick {
    HBRegisterSetPwdViewController *set = [[HBRegisterSetPwdViewController alloc] init];
    set.phoneNumString = self.phoneNum.text;
    set.imgVerifyCode = self.imgCodeTxf.text;
    set.verifyCode = self.codeTxf.text;
    [self.navigationController pushViewController:set animated:YES];
    if ([self canSubmitGo]) {
        [self postRegisterWithMobilePhoneNum:self.phoneNum.text imgVerifyCode:self.imgCodeTxf.text verifyCode:self.codeTxf.text];
    }
}

- (void)voiceBtn:(UIButton *)send {
    //弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"红包包将给您电话播报6位数验证码，请注意接听" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.voiceBtnHasSelected = YES;
        self.voiceBtn.userInteractionEnabled = NO;
        [self.voiceBtn setTitle:@"请注意接听电话播报6位验证码" forState:UIControlStateNormal];
        [self.voiceBtn setTitleColor:kColor_sRGB(74, 74, 74) forState:UIControlStateNormal];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIColor *gray = [UIColor grayColor];
    [sure setValue:gray forKey:@"titleTextColor"];
    [cancel setValue:gray forKey:@"titleTextColor"];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)canSubmitGo {
    
    if (!self.phoneNum.text.length) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return NO;
    } else if (![self.phoneNum.text n6_isMobile]){
        // 请输入正确手机号
        [MBProgressHUD showError:@"请输入正确手机号"];
        return NO;
    } else if (!self.imgCodeTxf.text.length){
        // 请输入图形验证码
        [MBProgressHUD showError:@"请输入图形验证码"];
        return NO;
    }
    if (!self.codeTxf.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return NO;
    }
    if (!self.readXyBtn.selected) {
        [MBProgressHUD showError:@"《请先同意红包袋用户协议》、《隐私政策》"];
        return NO;
    }
    return YES;
}

// 隐私政策
- (IBAction)privacyPoliclAction:(UIButton *)sender {
    [self setNavgationColorNormalr];
    DDWebViewVC * vc = [[DDWebViewVC alloc] init];
    vc.navTitle = @"隐私政策";
    vc.webType = HHYinSiZC;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 点击用户协议 */
- (void)zcxyBtnClick {
    [self setNavgationColorNormalr];
    DDWebViewVC * vc = [[DDWebViewVC alloc] init];
    vc.navTitle = @"红包袋用户协议";
    vc.webType = DDWebTypeYHXY;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setNavgationColorNormalr {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBackgroundImage:[AppUtils imageWithColor:kColor_Red_Main] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


#pragma mark -- 点击刷新图片
/** 获取图片验证码 **/
- (void)getPictureCheckCode{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *imageUrl = [self getImageUrl];
            UIImage *image = [self getImageFromUrl:imageUrl];
            self.imgCodeImgView.image = image;
        });
    });
}
////通过转换获取url
- (NSURL *)getImageUrl{
    NSString *key =  @"CFBundleShortVersionString";
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *baseUrl = [NSString stringWithFormat:@"%@/p2p/SourcePortal?", BXNETURL];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@service=%@&head={\"sessionId\":\"%@\"}&client={\"plat\":\"ios\",\"version\":\"%@\"}",baseUrl,BXRequestPictureCheckCode,[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"],infoDict[key]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

- (UIImage *)getImageFromUrl:(NSURL *)url{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:url];
    result = [UIImage imageWithData:data];
    return result;
}

#pragma mark - 获取验证码读秒
-(void)startCodeTimeGetcodeBtn:(UIButton *)getcodeBtn{
    //倒计时时间
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                getcodeBtn.userInteractionEnabled = YES;
                //倒计时结束改变语音按钮状态
                [self.voiceBtn setTitle:@"" forState:UIControlStateNormal];
                self.voiceBtn.userInteractionEnabled = NO;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [getcodeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                getcodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - POST
/** POST获取手机验证码 **/
- (void)postSendMessageCodeWithMobile:(NSString *)mobile PicCode:(NSString *)picCode
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestRegisterVerifyCode;
    info.dataParam = @{@"mobilePhone":mobile,
                       @"picCode":picCode,
                       @"BASE_DEAL":@"1",
                       @"vobankIdTemp":@"",
                       @"from":@"M"};
    if (self.voiceBtnHasSelected) {
        info.dataParam = @{@"mobilePhone":mobile,
                           @"picCode":picCode,
                           @"voice":@(2),
                           @"BASE_DEAL":@"1",
                           @"vobankIdTemp":@"",
                           @"from":@"M"};
    }
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        NSString *result = dict[@"body"][@"resultcode"];
        NSString *errorInfo = dict[@"body"][@"resultinfo"];
        if ([result integerValue] == 0) {
            // 读秒
            [self startCodeTimeGetcodeBtn:self.codeBtn];
            [MBProgressHUD showSuccess:@"获取成功"];
            self.voiceBtn.userInteractionEnabled = YES;
            [self.voiceBtn setTitle:@"短信收不到？点此获取语音验证码" forState:UIControlStateNormal];
            [self.voiceBtn setTitleColor:kColor_sRGB(231, 56, 61) forState:UIControlStateNormal];
        } else {
            [MBProgressHUD showError:errorInfo];
        }
    } faild:^(NSError *error) {
    }];
}

/** 注册下一步 **/

- (void)postRegisterWithMobilePhoneNum:(NSString *)num imgVerifyCode:(NSString *)imgCode  verifyCode:(NSString *)verifyCode{
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = HBCheckMobileAndCode_OPEN;
    info.dataParam = @{@"mobilePhone":num,
                       @"picCode":imgCode,
                       @"verifycode":verifyCode,
                       @"roles":@"1",
                       };
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        NSString *result = dict[@"body"][@"resultcode"];
        NSString *errorInfo = dict[@"body"][@"resultinfo"];
        
        NSLog(@"----------%@", dict);
        if ([result integerValue] == 0) {
            HBRegisterSetPwdViewController *set = [[HBRegisterSetPwdViewController alloc] init];
            set.phoneNumString = self.phoneNum.text;
            set.imgVerifyCode = self.imgCodeTxf.text;
            set.verifyCode = self.codeTxf.text;
            [self.navigationController pushViewController:set animated:YES];
           
        } else {
            [MBProgressHUD showError:errorInfo];
        }
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

///* post登录 */
//- (void)postLoginWithUserName:(NSString *)userName password:(NSString *)password
//{
//    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
//    info.dataParam = @{@"userName":userName,@"password":password};
//    info.serviceString = BXRequestLogin;
//
//    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:
//     ^(id responseObject) {
//
//         NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
//         if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
//
//             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//             [defaults setObject:@(1) forKey:DDKeyLoginState];
//             [LLLockPassword saveLockPassword:@""];
//             [defaults setObject:userName forKey:@"username"];
//             [defaults setObject:[NSString encodeByMd5AndSalt:password] forKey:@"password"];
//             [defaults setObject:dict[@"body"][@"_U"] forKey:@"userId"];
//             [defaults setObject:dict[@"body"][@"_T"] forKey:@"_T"];
//             [defaults setObject:dict[@"body"][@"roles"] forKey:@"roles"];
//             [defaults setObject:dict[@"body"][@"usergroup"] forKey:@"usergroup"];
//             [defaults setObject:dict[@"body"][@"mobile"] forKey:@"phoneNumber"];
//             [defaults setObject:dict[@"body"][@"khfs"] forKey:@"khfs"];
//             [defaults setObject:dict[@"body"][@"TS"] forKey:@"TS"];
//             [defaults setObject:dict[@"body"][@"QP"] forKey:@"QP"];
//             if (dict[@"body"][@"vipFlag"] == nil) {    //是不是vip
//                 [defaults setObject:@"0" forKey:DDUserVipState];
//             } else {
//                 [defaults setObject:dict[@"body"][@"vipFlag"] forKey:DDUserVipState];
//             }
//             if (dict[@"body"][@"sessionId"]) {
//                 [defaults setObject:dict[@"body"][@"sessionId"] forKey:@"sessionId"];
//             }
//
//             [defaults synchronize];
//
//         }
//
//     }faild:^(NSError *error) {
//
//     }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
