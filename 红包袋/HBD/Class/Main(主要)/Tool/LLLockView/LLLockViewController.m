//
//  LLLockViewController.m
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockViewController.h"
#import "LLLockIndicator.h"
#import "BXLoginViewController.h"
#import "DDInviteFriendVc.h"
#import "DDActivityWebController.h"

#define kTipColorNormal [UIColor whiteColor]
#define kTipColorError [UIColor colorWithHexString:COLOUR_YELLOW]

@interface LLLockViewController ()<LoginVCDelegate,UIAlertViewDelegate,CAAnimationDelegate>
{
    int nRetryTimesRemain; // 剩余几次输入机会
}

@property (weak, nonatomic) IBOutlet UIImageView *preSnapImageView; // 上一界面截图
@property (weak, nonatomic) IBOutlet UIImageView *currentSnapImageView; // 当前界面截图
@property (weak, nonatomic) IBOutlet UILabel *titleLable;       // 标题
@property (nonatomic, strong) IBOutlet LLLockIndicator* indecator; // 九点指示图
@property (nonatomic, strong) IBOutlet LLLockView* lockview; // 触摸田字控件
@property (strong, nonatomic) IBOutlet UILabel *tipLable;   // 提示语
//@property (strong, nonatomic) IBOutlet UIButton *tipButton; // 重设/(取消)的提示按钮
@property (weak, nonatomic) IBOutlet UIButton *leftBtn; //忘记手势密码
@property (weak, nonatomic) IBOutlet UIButton *rightBtn; //登录其他账户

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopSpace; //标题对上距离

@property (nonatomic, strong) NSString* savedPassword; // 本地存储的密码
@property (nonatomic, strong) NSString* passwordOld; // 旧密码
@property (nonatomic, strong) NSString* passwordNew; // 新密码
@property (nonatomic, strong) NSString* passwordconfirm; // 确认密码
@property (nonatomic, strong) NSString* tip1; // 三步提示语
@property (nonatomic, strong) NSString* tip2;
@property (nonatomic, strong) NSString* tip3;

@end


@implementation LLLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isHidenButton = NO;
        _isFromChangePwd = NO;
        _isFromForeground = NO;
    }
    return self;
}

- (id)initWithType:(LLLockViewType)type{
    self = [super init];
    if (self) {
        _nLockViewType = type;

    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self changeType];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"ISLOCKVC"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hascloselock" object:nil];
}

#pragma mark - life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"ISLOCKVC"];
    // 初始化返回按钮
    self.indecator.backgroundColor = [UIColor clearColor];
    self.lockview.backgroundColor = [UIColor clearColor];
    [self titleTopSpaceWithModel];
    
    self.lockview.delegate = self;
    if (_isFromChangePwd == YES) {
        [self makeBackBtn];
    }
    if (_nLockViewType == LLLockViewTypeCreate) {
        self.titleLable.hidden = YES;
        self.leftBtn.hidden = YES;
        self.leftBtn.userInteractionEnabled = NO;
        self.rightBtn.hidden = YES;
        self.rightBtn.userInteractionEnabled = NO;
    }
    
    if (_nLockViewType == LLLockViewTypeCheck) {
        if (_isFromForeground == YES) {
            [self authenTouchID];
        }else{
            [self authenTouchID];
        }
    }
}

/**  添加手势方法 */
- (void)authenTouchID
{
    LAContext *context = [LAContext new];
    NSError *error;
    
    //如果不设置的话,默认是”Enter Password”.如果该属性设置为@“”(空字符串),该按钮会被隐藏
    context.localizedFallbackTitle = @"";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:BXTouchIDEnabe] isEqual:@"yes"]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"通过验证指纹解锁红包袋"  // 提示文字
                              reply:^(BOOL success, NSError *error) {
                                  if (success) {
                                      //指纹验证成功
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self hide];
                                          DDLog(@"----指纹验证成功----");
                                      });
                                      
                                  }else{
                                      switch (error.code) {
                                          case LAErrorAuthenticationFailed:
                                          {
                                              //指纹错误，手机震动一下
                                              AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                              //指纹验证失败
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  WS(weakSelf);

                                                  weakSelf.tipLable.text = @"指纹解锁失败，请使用手势密码解锁";
                                                  
                                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                  [defaults setObject:@"no" forKey:BXTouchIDEnabe];
                                                  [defaults synchronize];
                                                  
                                                  DDLog(@"----指纹验证失败----");
                                              });
                                              
                                          }
                                          case LAErrorSystemCancel:
                                          {
                                              
                                              //切换到其他APP，系统取消验证Touch ID
                                              DDLog(@"----切换到其他APP，系统取消验证Touch ID----");
                                              break;
                                          }
                                          case LAErrorUserCancel:
                                          {
                                              
                                              //用户取消验证Touch ID，切换主线程处理
                                              DDLog(@"----用户取消验证Touch ID，切换主线程处理----");
                                              break;
                                          }
                                          case LAErrorUserFallback:
                                          {
                                              //用户选择输入密码，切换主线程处理
                                              DDLog(@"----用户选择输入密码，切换主线程处理----");
                                              break;
                                          }
                                          default:
                                          {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  //其他情况，切换主线程处理
                                                  DDLog(@"---其他情况，切换主线程处理-----");
                                              }];
                                              break;
                                          }
                                      }
                                  }
                              }];
            
        }
    }
    
}

- (void)titleTopSpaceWithModel
{
    if (SCREEN_SIZE.height == 480) {
        self.titleTopSpace.constant = 30;
    } else if (SCREEN_SIZE.height == 568){
        self.titleTopSpace.constant = 40;
    } else if (SCREEN_SIZE.height == 667){
        self.titleTopSpace.constant = 50;
    } else {
        self.titleTopSpace.constant = 60;
    }
}

// 自定义返回按钮
- (void)makeBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 100, 40);
    backBtn.center = CGPointMake(SCREEN_SIZE.width / 2, SCREEN_SIZE.height - 48.5 );
    [backBtn setTitle:@"暂不修改" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doFanHui) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftBtn.hidden = YES;
    self.leftBtn.userInteractionEnabled = NO;
    self.rightBtn.hidden = YES;
    self.rightBtn.userInteractionEnabled = NO;
    // 隐藏标题
    self.titleLable.hidden = YES;
    [self.view addSubview:backBtn];
}

// 点击忘记密码按钮
- (IBAction)didLeftBtnClick:(id)sender
{
    WS(weakSelf);
    [AppUtils alertWithVC:self  title:nil messageStr:@"忘记手势密码，请重新登录。" enSureStr:@"重新登录" cancelStr:@"取消" enSureBlock:^{
        [weakSelf showTabBarViewWithdataType:LLLockViewTypeNext];
    } cancelBlock:^{
        
    }];
}

// 点击使用其他账号登录按钮
- (IBAction)didRightBtnclick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.isPresentedWithMyAccount = 0;
    loginVC.isPresentedWithLockVC = 1;
    loginVC.LoginDelegate = self;
    BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:Nav animated:YES completion:nil];
}

// 代理方法，是否刷新状态
-(void)refreshVCType:(BOOL)refresh
{
    if (refresh == 1) {
        _nLockViewType = LLLockViewTypeCreate;
        [self.indecator setPasswordString:@""];
        [_tipLable setTextColor:kTipColorNormal];
        self.titleLable.hidden = YES;
        self.leftBtn.hidden = YES;
        self.leftBtn.userInteractionEnabled = NO;
        self.rightBtn.hidden = YES;
        self.rightBtn.userInteractionEnabled = NO;
        [self changeType];
    }
}

- (void)doFanHui
{
    [self  dismiss];
}

// 改变手势锁页面类型
- (void)changeType{
#ifdef LLLockAnimationOn
    [self capturePreSnap];
#endif
    
    // 初始化内容
    switch (_nLockViewType) {
            // 每次进入
        case LLLockViewTypeCheck:{
            _tipLable.text = @"请输入手势密码";
        }
            break;
        case LLLockViewTypeCreate:
        {
            if (_isHidenButton == YES) {
                _tipLable.text = @"绘制手势密码";
            }else{
                _tipLable.text = @"绘制手势密码";
            }
        }
            break;
            
        case LLLockViewTypeModify:{
            _tipLable.text = @"请输入原有密码";
        }
            break;
        case LLLockViewTypeClean:
        default:{
            _tipLable.text = @"请输入密码以清除密码";
        }
    }
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"RetryTimes"])
    {
        NSString *str = [NSString stringWithFormat:@"%d",LLLockRetryTimes];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"RetryTimes"];
        // 尝试机会
        nRetryTimesRemain = LLLockRetryTimes;
    }
    else
    {
        int times = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RetryTimes"] intValue];
        
        // 尝试机会
        nRetryTimesRemain = times;
    }
    self.passwordOld = @"";
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    
    // 本地保存的手势密码
    self.savedPassword = [LLLockPassword loadLockPassword];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString*)string
{
    // 验证密码正确
    if ([string isEqualToString:self.savedPassword]) {
        
        nRetryTimesRemain = LLLockRetryTimes;
        
        if (_nLockViewType == LLLockViewTypeModify) { // 验证旧密码
            
            self.passwordOld = string; // 设置旧密码，说明是在修改
            
            [self setTip:@"请输入新的密码"]; // 这里和下面的delegate不一致，有空重构
            
        } else if (_nLockViewType == LLLockViewTypeClean) { // 清除密码
            
            [LLLockPassword saveLockPassword:nil];
            [self hide];
            
            [self showAlert:self.tip2];
            
        } else { // 验证成功
            
            [self setTip:@"手势正确，登录成功"];
            self.lockview.userInteractionEnabled = NO;
            self.leftBtn.enabled = NO; //防止验证成功点击蓝屏bug
            self.rightBtn.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hide];
            });
            
        }
        
    }
    // 验证密码错误
    else if (string.length > 0) {
        
        int times = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RetryTimes"] intValue];
        
        // 尝试机会
        nRetryTimesRemain = times;
        nRetryTimesRemain--;
        
        NSString *str = [NSString stringWithFormat:@"%d",nRetryTimesRemain];
        
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"RetryTimes"];
        
        if (nRetryTimesRemain > 0) {
            [self setErrorTip:[NSString stringWithFormat:@"密码错误，您还可以输入%d次", nRetryTimesRemain]
                    errorPswd:string];
            
        } else {
            [self setErrorTip:[NSString stringWithFormat:@"密码错误，您还可以输入0次"]
                    errorPswd:string];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您已经连续5次输错手势密码，手势锁已关闭，请重新登录。" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    } else {
        NSAssert(YES, @"意外情况");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showTabBarViewWithdataType:LLLockViewTypeNext];
    }
}

- (void)createPassword:(NSString*)string
{
    // 输入密码
    if ([self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        
        if (string.length > 3) {
            self.passwordNew = string;
            [self setTip:self.tip2];
        }else{
            [self setErrorTip:@"至少连接4个点，请重新绘制" errorPswd:string];
        }
        
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        self.passwordconfirm = string;
        if ([self.passwordNew isEqualToString:self.passwordconfirm]){
            // 成功
            [LLLockPassword saveLockPassword:string];
            [self setTip:self.tip3];
            self.lockview.userInteractionEnabled = NO;
            
            if (_isFromChangePwd == YES) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.GestureDelegate respondsToSelector:@selector(gestureVCPopVCWithType:)]) {
                        [self.GestureDelegate gestureVCPopVCWithType:@"修改密码成功"];
                    }
                    [self hide];
                });
            }else{
                // 验证touchID是否可用
                LAContext *context = [LAContext new];
                NSError *error;
                //如果不设置的话,默认是”Enter Password”.如果该属性设置为@“”(空字符串),该按钮会被隐藏
                context.localizedFallbackTitle = @"";
                if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
                    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                            localizedReason:@"通过验证开启指纹解锁"  // 提示文字
                                      reply:^(BOOL success, NSError *error) {
                                          if (success) {
                                              //
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if ([self.GestureDelegate respondsToSelector:@selector(gestureVCPopVCWithType:)]) {
                                                      [self.GestureDelegate gestureVCPopVCWithType:@"修改密码成功"];
                                                  }
                                                  [self hide];
                                                  
                                                  DDLog(@"-cc--修改密码成功-----");
                                              });
                                              [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:BXTouchIDEnabe];
                                              
                                          }else{
                                              switch (error.code) {
                                                  case LAErrorAuthenticationFailed:
                                                  {
                                                      //指纹错误，手机震动一下
                                                      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                                      //指纹验证失败
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          WS(weakSelf);
                                                          [AppUtils alertWithVC:self title:@"提示" messageStr:@"指纹验证失败" enSureBlock:^{
                                                              [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                          }];
                                                          
                                                          DDLog(@"-cc--指纹验证失败-----");
                                                      });
                                                      
                                                  }
                                                  case LAErrorSystemCancel:
                                                  {
                                                      //切换到其他APP，系统取消验证Touch ID
                                                      DDLog(@"-cc--切换到其他APP-----");
                                                      break;
                                                  }
                                                  case LAErrorUserCancel:
                                                  {
                                                      //用户取消验证Touch ID，切换主线程处理
                                                      DDLog(@"-cc--用户取消验证Touch ID-----");
                                                      break;
                                                  }
                                                  case LAErrorUserFallback:
                                                  {
                                                      //用户选择输入密码，切换主线程处理
                                                      DDLog(@"-cc--用户选择输入密码-----");
                                                      break;
                                                  }
                                                  default:
                                                  {
                                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                          //其他情况，切换主线程处理
                                                          DDLog(@"-cc--其他情况，切-----");
                                                          //蓝屏bug好像走这里！待调试
                                                      }];
                                                      break;
                                                  }
                                              }
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if ([self.GestureDelegate respondsToSelector:@selector(gestureVCPopVCWithType:)]) {
                                                      [self.GestureDelegate gestureVCPopVCWithType:@"修改密码成功"];
                                                  }
                                                  [self hide];
                                                  DDLog(@"-cc222--修改密码成功-----");
                                                  [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:BXTouchIDEnabe];
                                              });
                                          }
                                          
                                      }];
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([self.GestureDelegate respondsToSelector:@selector(gestureVCPopVCWithType:)]) {
                            [self.GestureDelegate gestureVCPopVCWithType:@"修改密码成功"];
                        }
                        [self hide];
                        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:BXTouchIDEnabe];
                    });
                }
                
            }
            
        } else {
            
            self.passwordconfirm = @"";
            
            [self setErrorTip:@"与上一次绘制不一致，请重新绘制" errorPswd:string];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setTip:self.tip1];
                self.passwordNew = @"";
                [self.indecator setPasswordString:@""];
            });
            
        }
    } else {
        NSAssert(1, @"设置密码意外");
    }
}

#pragma mark - 显示提示
- (void)setTip:(NSString*)tip
{
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorNormal];
    
    _tipLable.alpha = 0;
    [UIView animateWithDuration:0.8 animations:^{
                         _tipLable.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
}

// 错误
- (void)setErrorTip:(NSString*)tip errorPswd:(NSString*)string
{
    // 显示错误点点
    [self.lockview showErrorCircles:string];
    
    // 直接_变量的坏处是
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorError];
    
    [self shakeAnimationForView:_tipLable];
}

#pragma mark - 成功后返回
- (void)hide
{
    NSString *str = [NSString stringWithFormat:@"%d",LLLockRetryTimes];
    
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"RetryTimes"];
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:{
            [self dismiss];
        }
            break;
        case LLLockViewTypeCreate:{
            [self showTabBarViewWithdataType:LLLockViewTypeCreate];
        }
            break;
        case LLLockViewTypeModify:{
            [self showTabBarViewWithdataType:LLLockViewTypeModify];
        }
            break;
        case LLLockViewTypeNext:{
            [self showTabBarViewWithdataType:LLLockViewTypeNext];
            [LLLockPassword saveLockPassword:self.passwordNew];
        }
            break;
        case LLLockViewTypeClean:
        default:{
            [LLLockPassword saveLockPassword:nil];
        }
    }
    
    // 在这里可能需要回调上个页面做一些刷新什么的动作
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"appVersion"] == YES) {
        return;
    }
    
#ifdef LLLockAnimationOn
    [self captureCurrentSnap];
    // 隐藏控件
    for (UIView* v in self.view.subviews) {
        if (v.tag > 10000) continue;
        v.hidden = YES;
    }
    // 动画解锁
    [self animateUnlock];
#else
    [self dismiss];
#endif
    
}

- (void)showTabBarViewWithdataType:(LLLockViewType)type
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = (HXTabBarViewController *)dele.window.rootViewController;
    
    if (type == LLLockViewTypeCheck) {
        [tabBarVC reloadHomeVC];
        [tabBarVC loginStatusWithNumber:1];
    } else if (type == LLLockViewTypeNext){
        
        [self.GestureDelegate gestureVCPopVCWithType:@"取消登录状态"];
        // 清除缓存
        [AppUtils clearLoginDefaultCachesAndCookieImgCaches:YES];
        
        [tabBarVC reloadSelecAndAlert];
        [tabBarVC loginStatusWithNumber:2];
        
    } else if (type == LLLockViewTypeModify){
        [tabBarVC reloadHomeVC];
        [tabBarVC loginStatusWithNumber:1];
        
    } else if (type == LLLockViewTypeForgetPwd){
        [tabBarVC reloadHomeVC];
        [tabBarVC loginStatusWithNumber:1]; ////////////////////
        
    } else if (type == LLLockViewTypeCreate){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"LoginUsername"]){
            [defaults setObject:[defaults objectForKey:@"LoginUsername"] forKey:@"username"];
        }else if([defaults objectForKey:@"phoneNumber"]){
            [defaults setObject:[defaults objectForKey:@"phoneNumber"] forKey:@"username"];
        }
        [defaults setObject:nil forKey:@"LoginUsername"];
        [defaults setObject:[defaults objectForKey:@"LoginPassword"] forKey:@"password"];
        [defaults setObject:nil forKey:@"LoginPassword"];
        [defaults synchronize];
        
        [tabBarVC reloadHomeVC];
        [tabBarVC loginStatusWithNumber:3];
        
    }
    [self dismiss];
}

#pragma mark - delegate 每次划完手势后
- (void)lockString:(NSString *)string{
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            self.tip1 = @"请输入手势密码";
            [self checkPassword:string];
        }
            break;
        case LLLockViewTypeCreate:
        {
            self.tip1 = @"绘制手势密码";
            self.tip2 = @"再次绘制手势密码";
            self.tip3 = @"手势密码设置成功";
            [self createPassword:string];
        }
            break;
        case LLLockViewTypeModify:
        {
            if ([self.passwordOld isEqualToString:@""]) {
                self.tip1 = @"请输入原有密码";
                [self checkPassword:string];
            } else {
                self.tip1 = @"请输入新的密码";
                self.tip2 = @"请再次输入密码";
                self.tip3 = @"密码修改成功";
                [self createPassword:string];
            }
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            self.tip1 = @"请输入密码以清除密码";
            self.tip2 = @"清除密码成功";
            [self checkPassword:string];
        }
    }
    
    //    [self updateTipButtonStatus];
}

-(void)didUpdateLockString:(NSString *)string
{
    [self.indecator setPasswordString:string];
}

#pragma mark - 解锁动画
// 截屏，用于动画
#ifdef LLLockAnimationOn
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 上一界面截图
- (void)capturePreSnap
{
    self.preSnapImageView.hidden = YES; // 默认是隐藏的
    self.preSnapImageView.image = [self imageFromView:self.presentingViewController.view];
}

// 当前界面截图
- (void)captureCurrentSnap
{
    self.currentSnapImageView.hidden = YES; // 默认是隐藏的
    self.currentSnapImageView.image = [self imageFromView:self.view];
}

- (void)animateUnlock
{
    self.currentSnapImageView.hidden = NO;
    self.preSnapImageView.hidden = NO;
    
    static NSTimeInterval duration = 0.5;
    
    // currentSnap
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
    
    CABasicAnimation *opacityAnimation;
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue=[NSNumber numberWithFloat:1];
    opacityAnimation.toValue=[NSNumber numberWithFloat:0];
    
    CAAnimationGroup* animationGroup =[CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO; // 防止最后显现
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [self.currentSnapImageView.layer addAnimation:animationGroup forKey:nil];
    
    // preSnap
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1];
    
    animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    
    [self.preSnapImageView.layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.currentSnapImageView.hidden = YES;
    [self dismiss];
}
#endif

#pragma mark 抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - 提示信息
- (void)showAlert:(NSString*)string
{
    WS(weakSelf);
    [AppUtils alertWithVC:self title:nil messageStr:string enSureBlock:^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    if([string isEqualToString:@"密码修改成功"]){
        [self.GestureDelegate gestureVCPopVCWithType:@"修改密码成功"];
    }
}

// 返回
- (void)dismiss
{
    [UIView animateWithDuration:1.0 animations:^{
        self.view.alpha = 0;
        [self.view removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}



@end

