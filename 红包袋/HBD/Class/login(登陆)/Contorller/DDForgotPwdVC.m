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

@interface DDForgotPwdVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTxf;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTxf;
@property (weak, nonatomic) IBOutlet UITextField *codeTxf;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
@property (weak, nonatomic) IBOutlet HXButton *nextBtn;
// 验证码
@property (nonatomic, copy)NSString *result;

@end

@implementation DDForgotPwdVC


- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = @"";
    
    [self getPictureCheckCode];

    
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.codeImgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImgViewClick)];
    [self.codeImgView addGestureRecognizer:tapGes];
}


/** 图片验证码点击 */
- (void)codeImgViewClick {
    [self getPictureCheckCode];
}

/** 获取验证码点击 */
- (void)codeBtnClick {
    
    if ([self canSubmitGo]) {
        [self postSendFindVerifyCodeWithMobile:self.phoneTxf.text PicCode:self.imgCodeTxf.text];
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



/** 下一步点击 */
- (void)nextBtnClick {
    
    if ([self canSubmitGoNext]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDResetPwdVC" bundle:nil];
        DDResetPwdVC *vc = [sb instantiateInitialViewController];
        vc.phone = self.phoneTxf.text;
        vc.imgCode = self.imgCodeTxf.text;
        vc.code = self.codeTxf.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取验证码读秒
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

/** 获取图片验证码 **/
- (void)getPictureCheckCode
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSURL *imageUrl = [self getImageUrl];
    UIImage *image = [self getImageFromUrl:imageUrl];
    
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.codeImgView.image = image;
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

/** POST获取验证码 **/
- (void)postSendFindVerifyCodeWithMobile:(NSString *)mobile PicCode:(NSString *)picCode
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestSendFindVerifyCode;
    info.dataParam = @{@"mobile":mobile,@"picCode":picCode,@"BASE_DEAL":@"1",@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        
        NSString *result = dict[@"body"][@"resultcode"];
        NSString *errorInfo = dict[@"body"][@"resultinfo"];
        if ([result integerValue] == 0) {
            // 成功
            [MBProgressHUD showSuccess:@"获取成功"];
            // 读秒
            [self startCodeTimeGetcodeBtn:self.codeBtn];
            
            self.result = result;
        } else {
            [MBProgressHUD showError:errorInfo];
        }
    } faild:^(NSError *error) {
        
    }];
}


@end
