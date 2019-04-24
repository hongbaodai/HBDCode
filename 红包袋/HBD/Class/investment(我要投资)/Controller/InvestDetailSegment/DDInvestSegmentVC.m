//
//  DDInvestSegmentVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/18.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//  出借详情页


#import "DDInvestSegmentVC.h"
#import "DDInvestDetailVC.h"
#import "DDInvestSafeVC.h"
#import "DDInvestRecordVC.h"
#import "DDInvestListVC.h"
#import "DDInvestSureVC.h"
#import "HXTabBarViewController.h"
#import "DDHomeVC.h"
#import "BXJumpThirdPartyController.h"
#import "NSDate+Setting.h"
#import "BXInvestmentDetailModel.h"
#import "DDEqbView.h"
#import "DDRiskPopView.h"
#import "DDRiskAssessViewController.h"
#import "HXRiskAssessModel.h"
#import "HXPopUpViewController.h"
#import "DDEqbVC.h"

@interface DDInvestSegmentVC () <ViewPagerDataSource, ViewPagerDelegate, PayThirdPartyProtocol, DDEqbViewDelegate, DDRiskPopViewDelegate, DDInSegmentDelegate>

@property (nonatomic, strong) DDInvestDetailVC *segDetailVC;
@property (nonatomic, strong) DDInvestSafeVC *segSafeVC;
@property (nonatomic, strong) DDInvestRecordVC *segRecordVC;

@property (nonatomic, strong) UIView *investView;
@property (nonatomic, strong) UIButton *investBtn;
@property (nonatomic, strong) BXInvestmentDetailModel  *element;

@end

@implementation DDInvestSegmentVC
{
    NSDictionary  *userCardInfo;     // 用户绑卡信息
    BOOL isBankCard;                 // 是否绑定了银行卡
    //记录秒数
    NSString *secondNum;
    BOOL isLogin;  //是否登录
}

#pragma mark life cycle
- (void)viewDidLoad {
    
    [self loadPagerDate];
    [super viewDidLoad];
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    HXTabBarViewController * tabBarVC = (HXTabBarViewController *)self.tabBarController;
    isLogin = NO;
    if (tabBarVC.bussinessKind) { //登录
        isLogin = YES;
    }else{ //未登录
        isLogin = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.segDetailVC.navController = self.navigationController;
    self.segSafeVC.navController = self.navigationController;
    self.segRecordVC.navController = self.navigationController;
    
    [self postUserBankCardInfo]; //用户信息
    [self addUIinvestBtn];
    if (self.loanID) {
        [self postLoanDetailWithLoanId:self.loanID];
    }else{
        [MBProgressHUD showError:@"网络异常"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.investView removeFromSuperview];
    [self.investBtn removeFromSuperview];
    
}

#pragma mark init
- (void)addUIinvestBtn {
    self.investView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- 108 - 2, SCREEN_WIDTH, 46 + 2)];
    self.investView.backgroundColor = [UIColor cyanColor];
    if (IS_iPhoneX) {
        self.investView.frame = CGRectMake(0, SCREEN_HEIGHT-46, SCREEN_WIDTH, 46);
    }
    [self.view addSubview:self.investView];
    [self.view bringSubviewToFront:self.investView];

    self.investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.investBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 46);
    [self.investBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
    [self.investBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];
    [self.investBtn addTarget:self action:@selector(investBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.investView addSubview:self.investBtn];

    if ([_tempModel.schedule isEqualToString:@"1"] || ([_tempModel.schedule integerValue] == 1)) {

        self.investBtn.userInteractionEnabled = NO;
        [self.investBtn setBackgroundImage:[UIImage imageNamed:@"yellowBack"] forState:UIControlStateNormal];
        [self.investBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.investBtn setTitle:@"已经满标" forState:UIControlStateNormal];
    } else {
        self.investBtn.userInteractionEnabled = YES;
        [self.investBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
        [self.investBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.investBtn setTitle:@"立即出借" forState:UIControlStateNormal];
    }
}

- (void)investBtnClick
{
    HXTabBarViewController * tabBarVC = (HXTabBarViewController *)self.tabBarController;
    if (tabBarVC.bussinessKind) { //登录
        if ([self isCanSubmit]) {
            UIStoryboard *segsb = [UIStoryboard storyboardWithName:@"DDInvestSureVC" bundle:nil];
            DDInvestSureVC *segVc=  [segsb instantiateInitialViewController];
            segVc.loanId = self.loanID;
            segVc.levelName =  userCardInfo[@"body"][@"levelName"];
            [self.navigationController pushViewController:segVc animated:YES];
        }

    }else{ //未登录
        [self presentLoginVC];
    }

}


#pragma mark DDViewPagerController
- (void)loadPagerDate {
    //  warning 此代理实现要再viewDidLoad前面
    self.dataSource = self;
    self.delegate = self;
    if (!self.starTab) {
        self.starTab = 0;
    }
    self.startFromSecondTab = self.starTab;
    self.padding = 10;
    self.tabsHeight = 44;
    //    [self reloadData];
    
}

#pragma viewPagerDataSourse
//返回多少组
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}

//设置组显示文字
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = kDefaultTextColor;
    if (index == 0) {
        lable.text = [NSString stringWithFormat:@"项目概要"];
    } else if (index == 1) {
        lable.text = [NSString stringWithFormat:@"风控措施"];
    } else if (index == 2) {
        lable.text = [NSString stringWithFormat:@"出借记录"];
    }
    [lable sizeToFit];
    return lable;
}
//创建组控制器
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        return self.segDetailVC;
    } else if (index == 1) {
        return self.segSafeVC;
    } else  {
        return self.segRecordVC;
    }
}
///设置滑动条颜色
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator://Tab状态条颜色
            return [UIColor clearColor];
            break;
        case ViewPagerTabsView://Tab底色
            return [UIColor clearColor];
            break;
        case ViewPagerContent:
            return [UIColor clearColor];
            break;
        case ViewPagerSelectedColor://选中tab文字颜色
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
}

#pragma mark - getter
- (DDInvestDetailVC *)segDetailVC{
    if (!_segDetailVC) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDInvestDetailVC" bundle:nil];
        DDInvestDetailVC *VC0 = [sb instantiateInitialViewController];
        VC0.loanId = self.loanID;
        _segDetailVC = VC0;
    }
    return _segDetailVC;
}

- (DDInvestSafeVC *)segSafeVC{
    if (!_segSafeVC) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDInvestSafeVC" bundle:nil];
        DDInvestSafeVC *VC1 = [sb instantiateInitialViewController];
        VC1.loanId = self.loanID;
        _segSafeVC = VC1;
    }
    return _segSafeVC;
}

- (DDInvestRecordVC *)segRecordVC{
    if (!_segRecordVC) {
        
        DDInvestRecordVC *VC2 = [[DDInvestRecordVC alloc] init];;
        VC2.loanId = self.loanID;
        VC2.islogin = isLogin;
        VC2.ddelegate = self;
        _segRecordVC = VC2;
    }
    return _segRecordVC;
}


- (BOOL)isCanSubmit {
    
    // 是否有数据
    if (userCardInfo[@"body"][@"currUser"] == nil) {
        [MBProgressHUD showError:userCardInfo[@"body"][@"resultinfo"]];
        return NO;
    }
    
    // 开通实名认证
    if ([userCardInfo[@"body"][@"currUser"][@"HFZH"] isEqualToString:@""]) {
        [self addPopViewWithStr:@"开通银行资金账户，才能出借哦"];
        return NO;
    }
    // e签宝-> 程远未来
    if ([userCardInfo[@"body"][@"signAccount"] integerValue] == 0) {
        [self addPopEqbViewWithStr:@"开通电子签名，才能出借哦"];
        return NO;
    }
    
    // 是否风险评估
    if ([userCardInfo[@"body"][@"levelName"] isEqualToString:@""]) {
        DDRiskPopView *rView = [[DDRiskPopView alloc] initWithImage:@"risk_lipn" Title:@"完成风险承受能力评估，才能出借哦" BtnImg:@"risk_bt-pg"];
        rView.delegate = self;
        
        return NO;
    }
    return YES;
}

#pragma mark - DDDelegate
/* 跳转到登录 */
- (void)didClickLoginVc {
    [self presentLoginVC];
}

/* 跳转到风险评估 */
- (void)didClickNowRiskBtn {
    
    DDRiskAssessViewController *assesVC = [[HXRiskAssessModel shareRiskModel] creaAssessVC];
    [self.navigationController pushViewController:assesVC animated:YES];
}

- (void)addPopEqbViewWithStr:(NSString *)str
{
    WS(weakSelf);
    
    HXPopUpViewController *vc = [HXPopUpViewController popUpVCInitWithTitle:str sureButton:@"立即开通" imageStr:@"eqb_xiong" isHidden:YES sureBlock:^{
        
        // 开通e签宝
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDEqbVC" bundle:nil];
        DDEqbVC *opVC = [sb instantiateInitialViewController];
        [weakSelf.navigationController pushViewController:opVC animated:YES];
        
    } deletBlock:^{
        
    }];
    vc.littlButBlock = ^{ };
}


// PopView
- (void)addPopViewWithStr:(NSString *)str
{
    WS(weakSelf);
    
    HXPopUpViewController *vc = [HXPopUpViewController popUpVCInitWithTitle:str sureButton:@"立即开通" imageStr:@"Group 2" isHidden:YES sureBlock:^{
        BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc] init];
        [self.navigationController pushViewController:openLDAccountVC animated:YES];
    } deletBlock:nil];
    vc.littlButBlock = ^{
        [APPVersonModel pushBankDepositoryWithVC:weakSelf urlStr:HXBankCiguan];
    };
}

// 弹出登录页面
- (void)presentLoginVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];

    [self.navigationController presentViewController:Nav animated:YES completion:nil];

}


#pragma mark - post
/** 获取用户绑卡信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            userCardInfo = dict;
            if (dict[@"body"][@"bankcardBind"][@"YHKH"]) {
                isBankCard = YES;
            } else {
                isBankCard = NO;
            }
        
        }
    } faild:^(NSError *error) {
    }];
}



/** POST项目详情  */
- (void) postLoanDetailWithLoanId:(NSString *)loanId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"loanId":loanId};
    info.serviceString = BXRequestLoanDetail;
    
    HXTabBarViewController * tabBarVC = (HXTabBarViewController *)self.tabBarController;
    if (!tabBarVC.bussinessKind) {//未登录
        
        [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
            
            [MBProgressHUD hideHUD];
    
            if ([dict[@"body"][@"resultcode"] integerValue] == 0){
                BXInvestmentDetailModel *model  = [BXInvestmentDetailModel mj_objectWithKeyValues:dict[@"body"][@"loan"]];
              
                self.element = model;
                
                //-----添加倒计时-----
                [self addCountText];
                
            }
            
        } faild:^(NSError *error) {
            [MBProgressHUD hideHUD];
            
            
        }];
    } else {//已登录   新增两字段 QTQX 起投上限； SFDJSY 是否可叠加 0 不能，1可以；
        [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
            
            [MBProgressHUD hideHUD];
            if ([dict[@"body"][@"resultcode"] integerValue] == 0){
                BXInvestmentDetailModel *model  = [BXInvestmentDetailModel mj_objectWithKeyValues:dict[@"body"][@"loan"]];

                self.element = model;
             
                //-----添加倒计时-----
                [self addCountText];
            }
        } faild:^(NSError *error) {
            [MBProgressHUD hideHUD];
        }];
    }
}


#pragma mark -- 倒计时
//--------------------添加倒计时----------------------------
- (void)addCountText
{
    //转成年月日 ，到天
    NSString *daydjs = [NSDate transformStrToDay:_element.DJSKBSJ];
    NSString *daynow = [NSDate transformStrToDay:_element.nowDate];
    //转成秒  截止到天的秒
    NSString *s1 = [NSDate transformTimeToChuo:daydjs];
    NSString *s2 = [NSDate transformTimeToChuo:daynow];
    double tempmms = [s1 doubleValue] - [s2 doubleValue];
    
    double tempInt =  ([_element.DJSKBSJ doubleValue] - [_element.nowDate doubleValue])/1000; //秒差
    
    if (tempInt > 0) {
        // 秒
        int second = (int)tempInt %60;
        int minute = (int)tempInt /60%60;
        int house = (int)tempInt /60/60%24;
        int day = (int)tempmms /60 /60 /24;
        
        if (day > 0) {
            //大于1天
            NSString *investStr = [NSString stringWithFormat:@"%d天后 %@开标",day,[NSDate ConvertStrToTime:_element.DJSKBSJ]];
            [self.investBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
            [self.investBtn setTitle:investStr forState:UIControlStateNormal];
            self.investBtn.userInteractionEnabled = NO;
            
        }else if (day==0  && house >= 2) {
            //大于2小时
            //比较日期是不是一天
            if ([daydjs isEqualToString:daynow]) {
                //是一天显示今日
                NSString *investStr = [NSString stringWithFormat:@"今日 %@开标",[NSDate ConvertStrToTime:_element.DJSKBSJ]];
                [self.investBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
                [self.investBtn setTitle:investStr forState:UIControlStateNormal];
                self.investBtn.userInteractionEnabled = NO;
                
            } else {
                //不是一天显示1天后
                NSString *investStr = [NSString stringWithFormat:@"1天后 %@开标",[NSDate ConvertStrToTime:_element.DJSKBSJ]];
                [self.investBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
                [self.investBtn setTitle:investStr forState:UIControlStateNormal];
                self.investBtn.userInteractionEnabled = NO;
            }
            
        }else if (day==0 && house <2) {
            //小于2小时 开始执行倒计时
            //获取倒计时秒数
            long int tempS = house *60 *60 + minute * 60 +second;
            secondNum = [NSString stringWithFormat:@"%ld",tempS];
            //执行倒计时
            [self setupCountDowntimer:self.investBtn];
        }
    }
}

-(void)setupCountDowntimer:(UIButton *)countDownBtn
{
    //倒计时时间
    __block int timeout = [secondNum intValue];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [countDownBtn setTitle:@"立即出借" forState:UIControlStateNormal];
                [countDownBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
                countDownBtn.userInteractionEnabled = YES;
            });
            
        } else {
            
            NSString *strTimeh = [NSString stringWithFormat:@"%01zd", timeout/3600];
            NSString *strTimem = [NSString stringWithFormat:@"%02zd", (timeout/60)%60];
            NSString *strTimes = [NSString stringWithFormat:@"%02zd", timeout%60];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [countDownBtn setTitle:[NSString stringWithFormat:@"%@小时%@分钟%@秒", strTimeh, strTimem, strTimes] forState:UIControlStateNormal];
                countDownBtn.userInteractionEnabled = NO;
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}

@end
