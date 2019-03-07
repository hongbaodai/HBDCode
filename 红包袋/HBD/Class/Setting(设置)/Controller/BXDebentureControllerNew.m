//
//  BXDebentureControllerNew.m
//  HBD
//
//  Created by hongbaodai on 2018/1/26.

#import "BXDebentureControllerNew.h"
#import "BXDebentureViewModel.h"
#import "DDAccount.h"
#import "AppUtils.h"
#import "DDEqbVC.h"
#import "DDVipPrivilegeController.h"
#import "DDAssessmentVC.h"
#import "DDRiskAssessViewController.h"
#import "HXRiskAssessModel.h"
#import "BXChangePasswordController.h"
#import "HXPopUpViewController.h"
#import "HXBankCardManagerVC.h"
#import "BXGesturePasswordViewController.h"
#import "SettingBottomView.h"
#import "BXOpenLDAccountEqianBaoController.h"

@interface BXDebentureControllerNew ()
{
    BOOL isOpen;  // 是否开通第三方账户:开通了银行存管
}
@property (nonatomic, strong) BXDebentureViewModel *viewModel;
/** 底部退出按钮视图 */
@property (nonatomic, strong) SettingBottomView *bottomView;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation BXDebentureControllerNew

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"账户管理";
    
    [self setupGroups];
    self.tableView.scrollEnabled = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.bottomView;
}
/** 添加数据源 */
- (void)setupGroups
{
    [self setUpGroup0];
    [self setUpGrop1];
}
/** group-0 */
- (void)setUpGroup0
{
    HXProuductGroup *group0 = [[HXProuductGroup alloc] init];
    group0.cellHeight = 51.0f;
    group0.headerHeight = 3.0f;
    group0.footerHeight = 0;
    
    HXLabelItem *firstRow = [[HXLabelItem alloc] initWithImg:@"" title:@"手机认证"];
    HXLabelArrowItem *seccondRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行存管"];
    HXLabelArrowItem *thirdRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行卡管理"];
    HXLabelArrowItem *forthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行卡预留手机号"];
    HXLabelArrowItem *fifthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"电子签章"];
    HXLabelArrowItem *zeroRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"VIP会员特权"];
    HXLabelArrowItem *sixthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"风险承受能力"];
    
    if (self.isDelete == YES) {
        group0.items = [NSMutableArray arrayWithObjects:firstRow, seccondRow, thirdRow, forthRow, fifthRow, sixthRow, nil];
    } else {
        group0.items = [NSMutableArray arrayWithObjects:firstRow, seccondRow, thirdRow, forthRow, fifthRow, zeroRow, sixthRow, nil];
    }
    [self.datas addObject:group0];
}
/** group-1 */
- (void)setUpGrop1
{
    WS(weakSelf);
    HXProuductGroup *group1 = [[HXProuductGroup alloc] init];
    group1.cellHeight = 51.0f;
    group1.headerHeight = 3.0f;
    group1.footerHeight = 0;
    
    HXArrowItem *seventhRow = [[HXArrowItem alloc] initWithImg:@"" title:@"修改登录密码"];
    seventhRow.option = ^(NSIndexPath *index) {
        [weakSelf pushModifyLoginPassword];
    };
    
    HXArrowItem *eighthRow = [[HXArrowItem alloc] initWithImg:@"" title:@"修改交易密码"];
    eighthRow.option = ^(NSIndexPath *index) {
        [weakSelf modifyPaypassword];
    };
    
    HXArrowItem *ninthRow = [[HXArrowItem alloc] initWithImg:@"" title:@"修改手势密码"];
    ninthRow.option = ^(NSIndexPath *index) {
        [weakSelf pushModifyGesturesLock];
    };
    
    HXSwitchItem *tenthRow = [[HXSwitchItem alloc] initWithImg:@"" title:@"开启Touch ID指纹密码锁"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:BXTouchIDEnabe] isEqual:@"yes"] && [self IsSupportFingerprint]) {
        tenthRow.open = YES;
    } else {
        tenthRow.open = NO;
    }
    
    group1.items = [NSMutableArray arrayWithObjects:seventhRow, eighthRow, ninthRow, tenthRow, nil];
    [self.datas addObject:group1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [BXDebentureViewModel postUserBankCardInfoWithVC:self success:^(id respose) {
        [weakSelf makeUIWithDic:respose];
    }];
    [self setSwitch];
}

- (void)setSwitch
{
    HXProuductGroup *group = self.datas[1];
    HXSwitchItem *ite = group.items[3];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:BXTouchIDEnabe] isEqual:@"yes"] && [self IsSupportFingerprint]) {
        ite.open = YES;
    } else {
        ite.open = NO;
    }
    group.items[3] = ite;
}

- (void)makeUIWithDic:(NSDictionary *)dic
{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dic];
    if (dict[@"body"][@"bankcardBind"][@"YHBM"]) {
        self.kSFMRTX = dict[@"body"][@"bankcardBind"][@"YHBM"];
    } else {
        self.kSFMRTX = nil;
    }
    [self initUIData];
}

- (BOOL)IsSupportFingerprint
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        return YES;
    }
    return NO;
}
/** 处理数据 */
- (void)reviewDataSection:(NSInteger)sec crow:(NSInteger)row item:(HXItem *)item
{
    HXProuductGroup *group = self.datas[sec];
    group.items[row] = item;
}
/** 刷新加载的数据及页面 */
- (void)initUIData
{
    WS(weakSelf);
    DDAccount *account = [DDAccount sharedDDAccount];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //手机认证
    if (account.currUser.SJH) {
        NSString *phStr = account.currUser.SJH;
        HXLabelItem *firstRow = [[HXLabelItem alloc] initWithImg:@"" title:@"手机认证"];
        firstRow.text = [NSString stringWithFormat:@"%@    ",phStr];
        [self reviewDataSection:0 crow:0 item:firstRow];
    } else {
        HXLabelItem *firstRow = [[HXLabelItem alloc] initWithImg:@"" title:@"手机认证"];
        firstRow.text = @"未绑定    ";
        [self reviewDataSection:0 crow:0 item:firstRow];
    }
    
    //银行存管
    if (account.currUser.HFZH && ![account.currUser.HFZH isEqualToString:@""]) {
        isOpen = YES;
        HXLabelItem *seccondRow = [[HXLabelItem alloc] initWithImg:@"" title:@"银行存管"];
        seccondRow.text = @"已开通             ";
        [self reviewDataSection:0 crow:1 item:seccondRow];
    } else {
        HXLabelArrowItem *seccondRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行存管"];
        seccondRow.text = @"未开通";
        seccondRow.arrowImageStr = @"";
        seccondRow.option = ^(NSIndexPath *index) {
            [weakSelf bankDeposit];
        };
        [self reviewDataSection:0 crow:1 item:seccondRow];
    }
    
    // 银行卡管理:     只要开户了：绑卡了 就有数据
    if (self.kSFMRTX) {
        HXLabelArrowItem *thirdthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行卡管理"];
        thirdthRow.text = @"已绑定";
        thirdthRow.option = ^(NSIndexPath *index) {
            [weakSelf bankCard:YES];
        };
        [self reviewDataSection:0 crow:2 item:thirdthRow];
    } else {
        HXLabelArrowItem *thirdRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行卡管理"];
        thirdRow.text = @"立即绑定";
        thirdRow.option = ^(NSIndexPath *index) {
            [weakSelf bankCard:NO];
        };
        [self reviewDataSection:0 crow:2 item:thirdRow];
    }
    
    // 银行预留手机号
    if (account.bankPhoneNum && self.kSFMRTX) {
        NSString *str = [NSString stringWithFormat:@"%@    修改",account.bankPhoneNum];
        HXLabelArrowItem *forthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行卡预留手机号"];
        forthRow.text = str;
        forthRow.option = ^(NSIndexPath *index) {
            [weakSelf bankPhone];
        };
        [self reviewDataSection:0 crow:3 item:forthRow];
    } else {
        HXLabelArrowItem *forthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"银行卡预留手机号"];
        forthRow.text = @"立即绑定";
        forthRow.option = ^(NSIndexPath *index) {
            [weakSelf bankPhone];
        };
        [self reviewDataSection:0 crow:3 item:forthRow];
    }
    
    // e签宝  [dict[@"body"][@"signAccount"] integerValue] == 0
    if ([account.signAccount integerValue] == 1) {
        HXLabelItem *fifthRow = [[HXLabelItem alloc] initWithImg:@"" title:@"电子签章"];
        fifthRow.text = @"已开通             ";
        [self reviewDataSection:0 crow:4 item:fifthRow];
    } else {
        HXLabelArrowItem *fifthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"电子签章"];
        fifthRow.text = @"未开通";
        fifthRow.option = ^(NSIndexPath *index) {
            [weakSelf pushEqb];
        };
        [self reviewDataSection:0 crow:4 item:fifthRow];
    }
    
    //vip会员
    NSString *vipStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:DDUserVipState]];
    
    if ([vipStr isEqualToString:@"1"]) {
        if (account.SXSJ) {
            NSString *sxStr = [NSString stringWithFormat:@"%@到期", [account.SXSJ substringToIndex:10]];
            HXLabelArrowItem *vipRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"VIP会员特权"];
            vipRow.text = sxStr;
            vipRow.option = ^(NSIndexPath *index) {
                [weakSelf pushVipManage];
            };
            [self reviewDataSection:0 crow:5 item:vipRow];
        }
    }
    
    //风险评估类型
    NSInteger row = 6;
    if (_isDelete == YES) {
        row = 5;
    }
    if ([account.levelName length] > 0){
        NSString *str = [NSString stringWithFormat:@"%@",account.levelName];
        
        HXLabelArrowItem *seventhRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"风险承受能力"];
        seventhRow.text = str;
        seventhRow.option = ^(NSIndexPath *index) {
            [weakSelf pushRiskAssessment];
        };
        [self reviewDataSection:0 crow:row item:seventhRow];
    } else {
        HXLabelArrowItem *sixthRow = [[HXLabelArrowItem alloc] initWithImg:@"" title:@"风险承受能力"];
        sixthRow.text = @"完成评估有惊喜";
        sixthRow.option = ^(NSIndexPath *index) {
            [weakSelf pushRiskAssessment];
        };
        [self reviewDataSection:0 crow:row item:sixthRow];
    }
    [self.tableView reloadData];
}

#pragma mark - touchID切换状态
- (void)settingSwith:(UISwitch *)swi
{
    UISwitch *switchButton = (UISwitch*)swi;
    BOOL isButtonOn = [switchButton isOn];
    if (!isButtonOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:BXTouchIDEnabe];
        return;
    }
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    context.localizedFallbackTitle = @"";
    //首先使用canEvaluatePolicy 判断设备支持状态
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //不支持指纹识别，LOG出错误详情
        switchButton.on = !switchButton.on;
        WS(weakSelf);
        [AppUtils alertWithVC:self title:@"使用提示" messageStr:@"请先在系统设置-Touch ID与密码中开启" enSureBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    //支持指纹验证
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过验证指纹开启"reply:^(BOOL success, NSError *error) {
        if (success) {
            [self setSuccess];
        } else {
            [self setFailureWithSwitch:switchButton error:error];
        }
    }];
}
/** 指纹验证成功 */
- (void)setSuccess
{
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:BXTouchIDEnabe];
    dispatch_async(dispatch_get_main_queue(), ^{
        WS(weakSelf);
        [AppUtils alertWithVC:self title:@"提示" messageStr:@"指纹解锁设置成功" enSureBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    });
}
/** 只玩验证失败 */
- (void)setFailureWithSwitch:(UISwitch *)switchButton error:(NSError *)error
{
    switch (error.code) {
        case LAErrorAuthenticationFailed:   // 指纹验证失败
        {
            //指纹错误，手机震动一下
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            //      switchButton.on = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                WS(weakSelf);
                [AppUtils alertWithVC:self title:@"提示" messageStr:@"指纹验证失败" enSureBlock:^{
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }];
            });
        }
        case LAErrorSystemCancel:           // 切换到其他APP，系统取消验证Touch ID
        {
            break;
        }
        case LAErrorUserCancel:             // 用户取消验证Touch ID，切换主线程处理
        {
            break;
        }
        case LAErrorUserFallback:           // 用户选择输入密码，切换主线程处理
        {
            break;
        }
        default:                            // 其他情况，切换主线程处理
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{}];
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        switchButton.on = !switchButton.on;
    });
}
/** 银行存管 */
- (void)bankDeposit
{
    if (isOpen == YES) return;
    BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc] init];
    [self.navigationController pushViewController:openLDAccountVC animated:YES];
}
/** 银行卡管理 */
- (void)bankCard:(BOOL)isBind
{
    if (isBind == YES) { // 绑定银行卡  加上解除绑定
        [self makeBindCard];
        return;
    }
    //未绑定银行卡
    if (isOpen) {
        // 开通了银行存管--没绑定银行卡：进行绑卡
        [self.viewModel postBlindCardWithVC:self success:^(id respose) {}];
    } else {
        [self showMYPopupViewWithStr:@"开通银行存管账户，才能管理银行卡哦"];
    }
}
/** 修改银行预留手机号 */
- (void)bankPhone
{
    if (!isOpen) {
        [self showMYPopupViewWithStr:@"开通银行存管账户，才能管理预留手机号哦"];
        return;
    }
    if (!self.kSFMRTX) { // 非 立即绑定
        [self.viewModel postBlindCardWithVC:self success:^(id respose) {}];
        
    } else { // 海口银行修改手机号页面
        [self.viewModel postAmendPhoneNumWithVC:self success:^(id respose) {}];
    }
}
/** 修改交易密码 */
- (void)modifyPaypassword
{
    if (!isOpen) {
        [self showMYPopupViewWithStr:@"开通银行资金账户，才能管理交易密码哦"];
        return;
    }
    if (!self.kSFMRTX) {
        [self.viewModel postBlindCardWithVC:self success:^(id respose) {}];
        
    } else {
        [self.viewModel postChangeTransPwdWithVC:self success:^(id respose) {}];
    }
}
/** e签宝 */
- (void)pushEqb
{
    if (!isOpen) {
        [self showMYPopupViewWithStr:@"开通银行资金账户，才能开通电子签章哦"];
        return;
    }

    //通过开没开户来判断走哪个e签宝页面。需求：老用户开户的，没开通银行存管的，走老页面e签宝。
    DDAccount *account = [DDAccount sharedDDAccount];
    if (account.currUser.HFZH && ![account.currUser.HFZH isEqualToString:@""]) { // 已开通(已开户)

        if ([account.signAccount integerValue] == 1) return;
        DDEqbVC * eqbVc = [DDEqbVC creatVCFromSB];
        [self.navigationController pushViewController:eqbVc animated:YES];

    } else {  // 未开通（未开户）
        BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc]init];
        [self.navigationController pushViewController:openLDAccountVC animated:YES];
    }
}
/** vip */
- (void)pushVipManage
{
    DDVipPrivilegeController * vipVc = [DDVipPrivilegeController creatVCFromStroyboard];
    [self.navigationController pushViewController:vipVc animated:YES];
}
/** 风险评估 */
- (void)pushRiskAssessment
{
    DDAccount *account = [DDAccount sharedDDAccount];
    if ([account.levelName length] > 0){
        
        DDAssessmentVC * assVc = [DDAssessmentVC creatVCFromStroyboard];
        [self.navigationController pushViewController:assVc animated:YES];
    } else {
        
        DDRiskAssessViewController *assesVC = [[HXRiskAssessModel shareRiskModel] creaAssessVC];
        [self.navigationController pushViewController:assesVC animated:YES];
    }
}
/** 修改登录密码 */
- (void)pushModifyLoginPassword
{
    BXChangePasswordController *changePwdVC = [BXChangePasswordController creatVCFromSB];
    [self.navigationController pushViewController:changePwdVC animated:YES];
}
/** 修改手势锁页面 */
- (void)pushModifyGesturesLock
{
    BXGesturePasswordViewController *myData = [BXGesturePasswordViewController creatVCFromSB];
    [self.navigationController pushViewController:myData animated:YES];
}
/** 进入绑卡银行页面 */
- (void)makeBindCard
{
    HXBankCardManagerVC *myData = [HXBankCardManagerVC creatVCFromSB];
    myData.infoDict = self.currDict;
    
    WS(weakSelf);
    myData.cardBlock = ^(NSString *str) {
        weakSelf.kSFMRTX = nil;
    };
    [self.navigationController pushViewController:myData animated:YES];
}
/** 退出-清除缓存 */
- (void)clickAlertButton
{
    [AppUtils clearLoginDefaultCachesAndCookieImgCaches:YES];
    
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:0];
    tabBarVC.selectedIndex = 0;
}
/** 弹框 */
- (void)showMYPopupViewWithStr:(NSString *)str
{
    WS(weakSelf);
    HXPopUpViewController *vc = [HXPopUpViewController popUpVCInitWithTitle:str sureButton:@"立即开通" imageStr:@"Group 2" isHidden:YES sureBlock:^{
        [weakSelf sureAlertBut];
    } deletBlock:nil];
    vc.littlButBlock = ^{
        [APPVersonModel pushBankDepositoryWithVC:weakSelf urlStr:HXBankCiguan];
    };
}

- (void)sureAlertBut
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"khfs"] isEqual:@"2"]) {
        WS(weakSelf);
        [AppUtils alertWithVC:self title:@"提示" messageStr:@"企业用户请前往官网进行开户" enSureBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc] init];
        [self.navigationController pushViewController:openLDAccountVC animated:YES];
    }
}
/** 绑卡成功 */
- (void)doBlindCardSuccess
{
    HXBankCardManagerVC *myData = [HXBankCardManagerVC creatVCFromSB];
    [self.navigationController pushViewController:myData animated:YES];
}
/** 安全退出 */
- (void)quitAction
{
    WS(weakSelf);
    [AppUtils alertWithVC:self title:@"确定要退出？" messageStr:nil enSureStr:@"确认" cancelStr:@"取消" enSureBlock:^{
        [weakSelf clickAlertButton];
    } cancelBlock:^{}];
}
/** 底部退出按钮 */
- (SettingBottomView *)bottomView
{
    if (_bottomView == nil) {
        WS(weakSelf);
        _bottomView = [[SettingBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        _bottomView.quitBlock = ^{
            [weakSelf quitAction];
        };
    }
    return _bottomView;
}
/** 头部view */
- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (BXDebentureViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[BXDebentureViewModel alloc] init];
        WS(weakSelf);
        _viewModel.succesBlo = ^(id respose) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _viewModel.succesBlindCardBlo = ^(id respose) {
            [weakSelf doBlindCardSuccess];
        };
    }
    return _viewModel;
}

@end
