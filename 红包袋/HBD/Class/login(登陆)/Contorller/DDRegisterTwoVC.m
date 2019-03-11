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
//#import "NSString+Other.h"

@interface DDRegisterTwoVC ()

@property (weak, nonatomic) IBOutlet UITextField *codeTxf;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwdTxf;
@property (weak, nonatomic) IBOutlet UIButton *eyesBtn;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTxf;
@property (weak, nonatomic) IBOutlet HXButton *sureBtn;
@property (weak, nonatomic) IBOutlet MPCheckboxButton *readXyBtn;
@property (weak, nonatomic) IBOutlet UIButton *zcxyBtn;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTxf;
@property (weak, nonatomic) IBOutlet UIImageView *imgCodeImgView;
@property (weak, nonatomic) IBOutlet UIButton *imgCodeBtn;


@end

@implementation DDRegisterTwoVC
{
    NSString *verifyToken_;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewUIS];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self imgCodeBtnClick];
}

- (void)initViewUIS {
    
    [self.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.eyesBtn addTarget:self action:@selector(eyesBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.zcxyBtn addTarget:self action:@selector(zcxyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.imgCodeBtn addTarget:self action:@selector(imgCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _eyesBtn.selected = NO;
    _passwdTxf.secureTextEntry = YES;

}

/** 点击眼睛 */
- (void)eyesBtnClick {
    
    if (_eyesBtn.selected == YES) {
        _eyesBtn.selected = NO;
        _passwdTxf.secureTextEntry = YES;
        [_eyesBtn setImage:[UIImage imageNamed:@"l_eyesClose"] forState:UIControlStateNormal];
        
    } else if (_eyesBtn.selected == NO){
        _eyesBtn.selected = YES;
        _passwdTxf.secureTextEntry = NO;
        [_eyesBtn setImage:[UIImage imageNamed:@"l_eyes"] forState:UIControlStateNormal];
    }
  
}

/** 点击获取验证码 */
- (void)codeBtnClick {
    if (!self.imgCodeTxf.text.length){
        [MBProgressHUD showError:@"请输入图形验证码"];
        return;
    }
    [self postSendMessageCodeWithMobile:self.phoneNum PicCode:self.imgCodeTxf.text];
}

/** 点击领取红包 */
- (void)sureBtnClick {
    
    if ([self canSubmitGo]) {

        [self postRegisterWithMobile:self.phoneNum password:self.passwdTxf.text PicCode:self.imgCodeTxf.text CdKey:self.inviteCodeTxf.text PhoneCode:self.codeTxf.text];
    }
    
}

- (BOOL)canSubmitGo {
    
    if (!_imgCodeTxf.text.length) {
        [MBProgressHUD showError:@"请输入图形验证码"];
        return NO;
    }
    if (!_codeTxf.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return NO;
    }
    if (!_passwdTxf.text.length) {
        [MBProgressHUD showError:@"请输入密码"];
        return NO;
    }

    if ([self isEmpty:_passwdTxf.text]) {
        [MBProgressHUD showError:@"密码不能含有空白字符"];
        return NO;
    }

    if ([_passwdTxf.text isValidPasswordString] == NO) {
        [MBProgressHUD showError:@"密码必须包含数字和字符，位数8-16位"];
        return NO;
    }

    if (!self.readXyBtn.selected) {
        [MBProgressHUD showError:@"《请先同意红包袋用户协议》、《隐私政策》"];
        return NO;
    }
    return YES;
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


- (void)setNavgationColorNormalr {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 导航栏变蓝
    [self.navigationController.navigationBar setBackgroundImage:[AppUtils imageWithColor:COLOUR_BTN_BLUE] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
// 隐私政策
- (IBAction)privacyPoliclAction:(UIButton *)sender {
[self setNavgationColorNormalr];
//    HXWebVC *webVC = [[HXWebVC alloc]init];
//    webVC.title = @"隐私政策";
//
//    webVC.urlStr = [NSString stringWithFormat:@"%@/iosSecuity",DDNEWWEBURL];
//    [self.navigationController pushViewController:webVC animated:YES];

    DDWebViewVC * vc = [[DDWebViewVC alloc] init];
    vc.navTitle = @"隐私政策";
    vc.webType = HHYinSiZC;

    [self.navigationController pushViewController:vc animated:YES];
}

/** 点击用户协议 */
- (void)zcxyBtnClick {
    
    [self setNavgationColorNormalr];
        
   //
    DDWebViewVC * vc = [[DDWebViewVC alloc] init];
    vc.navTitle = @"红包袋用户协议";
    vc.webType = DDWebTypeYHXY;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 点击刷新图片
- (void)imgCodeBtnClick
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
            self.imgCodeImgView.image = image;
        });
        
    });
    
}
////通过转换获取url
- (NSURL *)getImageUrl
{
    NSString *key =  @"CFBundleShortVersionString";
    
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *baseUrl = [NSString stringWithFormat:@"%@/p2p/SourcePortal?", BXNETURL];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@service=%@&head={\"sessionId\":\"%@\"}&client={\"plat\":\"ios\",\"version\":\"%@\"}",baseUrl,BXRequestPictureCheckCode,[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"],infoDict[key]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

- (UIImage *)getImageFromUrl:(NSURL *)url
{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:url];
    result = [UIImage imageWithData:data];
    return result;
}



#pragma mark - 获取验证码读秒
-(void)startCodeTimeGetcodeBtn:(UIButton *)getcodeBtn
{
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
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
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
    info.dataParam = @{@"mobilePhone":mobile,@"picCode":picCode,@"BASE_DEAL":@"1",@"vobankIdTemp":@"",@"from":@"M"};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        
        NSString *result = dict[@"body"][@"resultcode"];
        NSString *errorInfo = dict[@"body"][@"resultinfo"];
        if ([result integerValue] == 0) {
            // 读秒
            [self startCodeTimeGetcodeBtn:self.codeBtn];
            // 成功
            [MBProgressHUD showSuccess:@"获取成功"];
//            self.result = result;
        } else {
            [MBProgressHUD showError:errorInfo];
        }
        
    } faild:^(NSError *error) {
        
    }];
}



/** 注册 **/
- (void)postRegisterWithMobile:(NSString *)mobile password:(NSString *)password PicCode:(NSString *)picCode CdKey:(NSString *)cdKey PhoneCode:(NSString *)phoneCode
{
    //    phoneCode 为手机验证码，从功能要后台添加相应参数，暂时未处理
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestRegister;
    cdKey = cdKey.length ? cdKey : @"";
    info.dataParam = @{@"mobilePhone":mobile,@"password":password,@"picCode":picCode,@"cdKey":cdKey,@"roles":@"1",@"verifycode":phoneCode,@"BASE_DEAL":@"1",@"vobankIdTemp":@""};
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
            [self postLoginWithUserName:self.phoneNum password:self.passwdTxf.text];
          
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
- (void)postLoginWithUserName:(NSString *)userName password:(NSString *)password
{
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

@end
