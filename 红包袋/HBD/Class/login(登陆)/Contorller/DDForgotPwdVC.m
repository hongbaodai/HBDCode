//
//  DDForgotPwdVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/13.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//  找回密码

#import "DDForgotPwdVC.h"
#import "JKCountDownButton.h"
#import "DDResetPwdVC.h"

@interface DDForgotPwdVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTxf;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTxf;//图片验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTxf;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;//图片验证
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
@property (weak, nonatomic) IBOutlet HXButton *nextBtn;
//语音
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (nonatomic, assign) BOOL voiceBtnHasSelected;//用来判断是否点击了语音验证

@end

@implementation DDForgotPwdVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.phoneTxf.delegate = self;
    self.imgCodeTxf.delegate = self;
    self.codeTxf.delegate = self;
    
    [self.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.voiceBtn.userInteractionEnabled = NO;
    [self.voiceBtn addTarget:self action:@selector(voiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getPictureCheckCode];
    [self.codeImgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImgViewClick)];
    [self.codeImgView addGestureRecognizer:tapGes];
}

/** 图片验证码点击 */
- (void)codeImgViewClick {
    [self getPictureCheckCode];
}

- (void)voiceBtn:(UIButton *)send {
    //弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"红包包将给您电话播报6位数验证码，请注意接听" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.voiceBtnHasSelected = YES;
        self.voiceBtn.userInteractionEnabled = NO;
        [self.voiceBtn setTitle:@"请注意接听电话播报6位验证码" forState:UIControlStateNormal];
        [self.voiceBtn setTitleColor:kColor_sRGB(74, 74, 74) forState:UIControlStateNormal];
        if ([self canSubmitGo]) {
            [self postSendFindVerifyCodeWithMobile:self.phoneTxf.text PicCode:self.imgCodeTxf.text];
        }
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

/** 获取验证码点击 */
- (void)codeBtnClick {
    if ([self canSubmitGo]) {
        [self postSendFindVerifyCodeWithMobile:self.phoneTxf.text PicCode:self.imgCodeTxf.text];
    }
}

/** 下一步点击 */
- (void)nextBtnClick {
    if ([self canSubmitGoNext]) {
        [self nextStep];
    }
    
}
- (BOOL)canSubmitGo {
    if (!self.phoneTxf.text.length) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return NO;
    } else if (![self.phoneTxf.text n6_isMobile]){
        // 请输入正确手机号
        [MBProgressHUD showError:@"请输入正确手机号"];
        return NO;
    } else if (!self.imgCodeTxf.text.length){
        // 请输入图形验证码
        [MBProgressHUD showError:@"请输入图形验证码"];
        return NO;
    }
    return YES;
}

- (BOOL)canSubmitGoNext {
    
    if (!self.phoneTxf.text.length) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return NO;
    }
    if (![self.phoneTxf.text n6_isMobile]){
        [MBProgressHUD showError:@"请输入正确手机号"];
        return NO;
    }
    if (!self.imgCodeTxf.text.length){
        [MBProgressHUD showError:@"请输入图形验证码"];
        return NO;
    }
    if (!self.codeTxf.text.length) {
        [MBProgressHUD showError:@"请输入验证码"];
        return NO;
    }

    return YES;
}

// 获取验证码读秒
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
                self.voiceBtnHasSelected = NO;
                self.voiceBtn.userInteractionEnabled = NO;
                [self.voiceBtn setTitle:@"" forState:UIControlStateNormal];
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

/** 获取图片验证码 **/
- (void)getPictureCheckCode{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *imageUrl = [self getImageUrl];
            UIImage *image = [self getImageFromUrl:imageUrl];
            self.codeImgView.image = image;
        });
    });
}

- (UIImage *)getImageFromUrl:(NSURL *)url{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:url];
    result = [UIImage imageWithData:data];
    return result;
}

//通过转换获取url
- (NSURL *)getImageUrl{
    NSString *key =  @"CFBundleShortVersionString";
    // 3.2获取软件当前版本号
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *baseUrl = [NSString stringWithFormat:@"%@/p2p/SourcePortal?", BXNETURL];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@service=%@&head={\"sessionId\":\"%@\"}&client={\"plat\":\"ios\",\"version\":\"%@\"}",baseUrl,BXRequestPictureCheckCode,[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"],infoDict[key]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

/** POST获取验证码 **/
- (void)postSendFindVerifyCodeWithMobile:(NSString *)mobile PicCode:(NSString *)picCode{
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestSendFindVerifyCode;
    info.dataParam = @{@"mobile":mobile,
                       @"picCode":picCode,
                       @"BASE_DEAL":@"1",
                       @"vobankIdTemp":@""};
    if (self.voiceBtnHasSelected) {
        info.dataParam = @{@"mobile":mobile,
                           @"picCode":picCode,
                           @"voice":@(2),
                           @"BASE_DEAL":@"1",
                           @"vobankIdTemp":@""};
    }
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        NSString *result = dict[@"body"][@"resultcode"];
        NSString *errorInfo = dict[@"body"][@"resultinfo"];
        if ([result integerValue] == 0) {
            // 成功
            [MBProgressHUD showSuccess:@"获取成功"];
            // 读秒
            if (self.voiceBtnHasSelected == NO) {
                [self startCodeTimeGetcodeBtn:self.codeBtn];
                self.voiceBtn.userInteractionEnabled = YES;
                [self.voiceBtn setTitle:@"短信收不到？点此获取语音验证码" forState:UIControlStateNormal];
                [self.voiceBtn setTitleColor:kColor_sRGB(231, 56, 61) forState:UIControlStateNormal];
            }
        } else {
            [MBProgressHUD showError:errorInfo];
        }
    } faild:^(NSError *error) {
        
    }];
}

- (void)nextStep {
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc] init];
    info.serviceString = HBCheckFindMobileAndCode_OPEN;
    info.dataParam = @{@"picCode":self.imgCodeTxf.text,
                       @"verifyCode":self.codeTxf.text,
                       @"mobile":self.phoneTxf.text,
                       @"roles":@"1"};
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *resultCode = dic[@"body"][@"resultcode"];
        if ([resultCode integerValue] == 0) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDResetPwdVC" bundle:nil];
            DDResetPwdVC *vc = [sb instantiateInitialViewController];
            vc.phone = self.phoneTxf.text;
            vc.imgCode = self.imgCodeTxf.text;
            vc.code = self.codeTxf.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [MBProgressHUD showError:dic[@"body"][@"resultinfo"]];
        }
    } faild:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.phoneTxf == textField){  //判断是否时我们想要限定的那个输入框
        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
            self.phoneTxf.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    if (self.imgCodeTxf == textField) {
        if ([toBeString length] > 4) {
            self.imgCodeTxf.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    if (self.codeTxf == textField) {
        if ([toBeString length] > 6) {
            self.codeTxf.text = [toBeString substringToIndex:6];
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
