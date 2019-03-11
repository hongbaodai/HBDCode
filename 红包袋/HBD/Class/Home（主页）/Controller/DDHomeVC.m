//
//  DDHomeVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/28.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDHomeVC.h"
#import "BXJumpThirdPartyController.h"
#import "BXReminderPageController.h"
#import "SDCycleScrollView.h"
#import "DDActivityWebController.h"
#import "DDInvestSegmentVC.h"
#import "DDInviteFriendVc.h"
#import "DDAccount.h"
#import "BXInvestmentModel.h"
#import "BXIndustryModel.h"
#import "BXMessagedetailController.h"
#import "HXRefresh.h"
#import "DDWebViewVC.h"
#import "HXTabBarViewController.h"
#import "DDInvestSureVC.h"
#import "DDRegisterVC.h"
#import "DDRiskPopView.h"
#import "DDRiskAssessViewController.h"
#import "HXRiskAssessModel.h"
#import "HXPopUpViewController.h"
#import "DDEqbVC.h"
#import "APPVersonModel.h"
#import "NSString+Other.h"
#import "STLoopProgressView.h"
#import "OYCountDownManager.h"

@interface DDHomeVC () <PayThirdPartyProtocol, SDCycleScrollViewDelegate, DDCoverViewDelegate, UINavigationControllerDelegate, DDRiskPopViewDelegate>{
    NSString *secondNum;
    int ksecond;  //秒
    int kminute;
    int khouse;
    int kday;
    NSInteger countDown;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
// MARK:** 项目进度展示区域 **
// 首页圆形进度条
@property (weak, nonatomic) IBOutlet STLoopProgressView *cycleView;
// 首页标的 title
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
// 进度
@property (weak, nonatomic) IBOutlet UILabel *percentLab;
// 项目期限
@property (weak, nonatomic) IBOutlet UILabel *limitDayLab;
// 项目金额
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
// 立即出借按钮
@property (weak, nonatomic) IBOutlet HXButton *InvestBtn;
// 新手标图片
@property (weak, nonatomic) IBOutlet UIImageView *NewStandard;
// 精品推荐图片
@property (weak, nonatomic) IBOutlet UIImageView *ProductsRecommended;
// 加息图片
@property (weak, nonatomic) IBOutlet UIImageView *IncreasesInInterestRates;

@property (nonatomic, strong) DDCoverView *ddcoverView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) DDUpgradeView *upgradeView;
@property (nonatomic, strong) DDUpgradeStopView *upgradeStopView;
// 公告
@property (weak, nonatomic) IBOutlet UIView *noticebgView;
// 首页圆形区域点击区域
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
// 新手专享
@property (weak, nonatomic) IBOutlet UIView *newbgView;
@property (weak, nonatomic) IBOutlet UIView *getbgView;

@property (weak, nonatomic) IBOutlet UIButton *newerZyBtn;
@property (weak, nonatomic) IBOutlet UIButton *safeBzBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteHyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nowGetBtn;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *bannerTitleArray;
// 微信分享详细描述
@property (nonatomic, strong) NSMutableArray *bannerDetailArray;
@property (nonatomic, strong) NSMutableArray *LJDZArray;  //url
@property (nonatomic, strong) NSMutableArray *FXJBArray; //分享图片路径
@property (nonatomic, strong) NSArray  *dataArray;
@property (nonatomic, strong) NSArray  *newloanArray;
@property (nonatomic, strong) NSArray  *eloanArray;
@property (nonatomic, strong) BXInvestmentModel *model;

@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, strong) NSArray *noticeModelArr;

@end

@implementation DDHomeVC
{
    SDCycleScrollView *bannarView;
    SDCycleScrollView *noticeView;
    CGFloat progressF;
    NSDictionary  *userCardInfo;     // 用户绑卡信息
    BOOL isBankCard;                 // 是否绑定了银行卡
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.tableview.backgroundColor = [UIColor whiteColor];

    [self initBannarView];
    [self initNoticeLabView];
    [self initViewUIs];
    [self addHeaderRefresh];

    [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CountDownNotification) name:kCountDownNotification object:nil];
    [kCountDownManager start];

    if (IS_iPhoneX) {
        self.tableview.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
        self.tableview.tableHeaderView.height_ = 220;
    } else {
        self.tableview.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        self.tableview.tableHeaderView.height_ = 200;

    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];

    //    [self showAlert];  // 🚫🚫🚫如果平台合规和风险评估合并一起，则这个需要打开
    [self postUserBankCardInfo]; //用户信息
    [self addRefreshStep];
    //为了定时器刷新，各种bug
    [self postLoanNewList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNavgationColorNormalr];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

#pragma mark -  init =================================================
// MARK: 图片轮播器
- (void)initBannarView {
    NSArray *imagesURLs = _imageArray;
    bannarView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.tableHeaderView.height_) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    bannarView.autoScrollTimeInterval = 3.0;
    bannarView.imageURLStringsGroup = imagesURLs;
    [self.tableView.tableHeaderView addSubview:bannarView];
}

// MARK: 上下滚动展示文字的轮播器
- (void)initNoticeLabView {
    NSArray *titles = _noticeArray;
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    noticeView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 30, 40) delegate:self placeholderImage:nil];
    noticeView.scrollDirection = UICollectionViewScrollDirectionVertical;
    noticeView.onlyDisplayText = YES;
    noticeView.titleLabelTextColor = [UIColor colorWithHexString:COLOUR_GRAY];
    noticeView.titleLabelTextFont = [UIFont systemFontOfSize:13.f];
    noticeView.titleLabelBackgroundColor = [UIColor clearColor];
    NSMutableArray *titlesArray = [NSMutableArray array];
    [titlesArray addObjectsFromArray:titles];
    noticeView.titlesGroup = [titlesArray copy];
    [noticeView disableScrollGesture];
    [self.noticebgView addSubview:noticeView];
}

//MARK: 点击方法添加
- (void)initViewUIs {
    [self.newerZyBtn addTarget:self action:@selector(newerZyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.safeBzBtn addTarget:self action:@selector(safeBzBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteHyBtn addTarget:self action:@selector(inviteHyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.nowGetBtn addTarget:self action:@selector(nowGetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.detailBtn addTarget:self action:@selector(cycleViewClick) forControlEvents:UIControlEventTouchUpInside];
    self.cycleView.persentage = 0.0;
    self.IncreasesInInterestRates.hidden = YES;
    [self.InvestBtn addTarget:self action:@selector(InvestBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

// MARK: 添加下拉刷新
- (void)addHeaderRefresh {
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerAction:@selector(loadHeaderRefresh)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadHeaderRefresh
{
    [bannarView removeFromSuperview];
    [noticeView removeFromSuperview];

    [self postLoanNewList];//获取新手标
    [self postBannerImage];//获取bannar
    [self postNoticeList];//获取公告

}

- (void)viewSafeAreaInsetsDidChange {  //iOS 11安全区适配新生命周期方法
    [super viewSafeAreaInsetsDidChange];
    
    if (@available(iOS 11.0, *)) { } else { }
}

- (void)showAlert {
    HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;    
    if (tabbar.bussinessKind == 0) { // 没有登陆的情况
        [APPVersonModel showHomeAlertEveryDayWithVC:self];
    }
}

#pragma mark - private func =================================================

- (void)addRefreshStep {
    HXTabBarViewController * tabBarVC = (HXTabBarViewController *)self.tabBarController;
    if (tabBarVC.bussinessKind) { //登录
        self.newbgView.hidden = NO;
        self.getbgView.hidden = YES;

    }else{ //未登录
        self.newbgView.hidden = YES;
        self.getbgView.hidden = NO;
    }
}

- (void)setNavgationColorNormalr {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 导航栏变红
    [self.navigationController.navigationBar setBackgroundImage:[AppUtils imageWithColor:COLOUR_BTN_BLUE_NEW] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
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

- (void)addPopViewWithStr:(NSString *)str {
    WS(weakSelf);
    HXPopUpViewController *vc = [HXPopUpViewController popUpVCInitWithTitle:str sureButton:@"立即开通" imageStr:@"Group 2" isHidden:YES sureBlock:^{
        BXOpenLDAccountEqianBaoController *openLDAccountVC = [[BXOpenLDAccountEqianBaoController alloc] init];
        [self.navigationController pushViewController:openLDAccountVC animated:YES];
    } deletBlock:nil];
    vc.littlButBlock = ^{
        [APPVersonModel pushBankDepositoryWithVC:weakSelf urlStr:HXBankCiguan];
    };
}

- (void)addPopEqbViewWithStr:(NSString *)str {
    WS(weakSelf);
    HXPopUpViewController *vc = [HXPopUpViewController popUpVCInitWithTitle:str sureButton:@"立即开通" imageStr:@"eqb_xiong" isHidden:YES sureBlock:^{
        // 开通e签宝->程远未来
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDEqbVC" bundle:nil];
        DDEqbVC *opVC = [sb instantiateInitialViewController];
        [weakSelf.navigationController pushViewController:opVC animated:YES];

    } deletBlock:^{

    }];

    vc.littlButBlock = ^{ };

}
// MARK: 升级弹窗
- (void)popUpgradeView {
    /*
     1、停服公告：点击确定退出账户，可以浏览，点击登录注册弹出
     2、升级公告：点击升级跳转升级页面升级，必须登录且为老账号
     */

    //处理升级公告
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *bizStr = [defaults objectForKey:@"BIZUPGRADE"];
    NSString *actStr = [defaults objectForKey:@"ACTIVATED"];
    NSString *lockStr = [defaults objectForKey:@"ISLOCKVC"];

    if ([bizStr isEqualToString:@"2"]) { //BIZUPGRADE:0-停服前  1-停服中  2-停服后  这个不用管
        // 登录状态 且 老账户  ACTIVATED：0-老账户 1-新账号
        HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
        if (tabbar.bussinessKind && [actStr isEqualToString:@"0"] && [lockStr isEqualToString:@"NO"]) {

            self.ddcoverView = [[DDCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.ddcoverView.viewStyle = DDViewStyleUpgradeView;
            self.ddcoverView.delegate = self;
        }
    }
}

// MARK: 拼接bannarURL路径
- (NSURL *)getImageUrlWithFilePath:(NSString *)filePath PictureStr:(NSString *)str {
    NSString *baseUrl = [NSString stringWithFormat:@"%@/p2p/SourcePortal?", BXNETURL];
    NSString *path = [NSString stringWithFormat:@"%@/banner/%@",filePath,str];

    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@service=%@&body={\"imgPath\":\"%@\"}",baseUrl,BXRequestCreatImage,path];

    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

//MARK: 登录状态下拼接参数
- (NSString *)urlWithPersonalInfo:(NSString *)url WithState:(NSString *)state {
    NSString *finalUrl = nil;
    if ([state isEqualToString:@"1"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSString *username = [defaults objectForKey:@"username"];
        NSString *_U = [defaults objectForKey:@"userId"];
        NSString *_T = [defaults objectForKey:@"_T"];
        NSString *roles = [defaults objectForKey:@"roles"];
        // 隐藏app内部显示的网页的字段
        NSString *hidden = @"1";

        if ([url rangeOfString:@"?"].location != NSNotFound) {
            finalUrl = [NSString stringWithFormat:@"%@&t=%@&u=%@&nickname=%@&roles=%@&hidden=%@",url,_T,_U,username,roles,hidden];
        } else {
            finalUrl = [NSString stringWithFormat:@"%@?t=%@&u=%@&nickname=%@&roles=%@&hidden=%@",url,_T,_U,username,roles,hidden];
        }
    } else {
        NSString *hidden = @"1";
        if ([url rangeOfString:@"?"].location != NSNotFound) {
            finalUrl = [NSString stringWithFormat:@"%@&t=null&u=null&nickname=null&roles=null&hidden=%@",url,hidden];
        }else{
            finalUrl = [NSString stringWithFormat:@"%@?t=null&u=null&nickname=null&roles=null&hidden=%@",url,hidden];
        }
    }

    return finalUrl;
}

#pragma mark - target action =================================================
/** 央企背景 */
- (void)newerZyBtnClick{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
//    DDActivityWebController *weVc = [sb instantiateInitialViewController];
////    weVc.webJSType = DDWebJSTypeXSZY;
//    weVc.webUrlStr = [NSString stringWithFormat:@"%@/#/newSafety?hidden=1#anchor2", DDWEBURL];
//    weVc.webTitleStr = @"新";
//    [self.navigationController pushViewController:weVc animated:YES];
    DDWebViewVC *vc = [[DDWebViewVC alloc] init];
    vc.webType = DDWebTypeYangQi;
    vc.navTitle = @"央企背景";
    [self.navigationController pushViewController:vc animated:YES];
}

/** 供应链金融 */
- (void)safeBzBtnClick{
    DDWebViewVC *vc = [[DDWebViewVC alloc] init];
    vc.webType = DDWebTypeGongYingLian;
    vc.navTitle = @"供应链金融";
    [self.navigationController pushViewController:vc animated:YES];
}

/** 点击安全保障 */
- (void)inviteHyBtnClick{

    DDWebViewVC *vc = [[DDWebViewVC alloc] init];
    vc.webType = DDWebTypeAQBZ;
    vc.navTitle = @"安全保障";
    [self.navigationController pushViewController:vc animated:YES];
}

/** 点击新手专享*/
- (void)nowGetBtnClick{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDRegisterVC" bundle:nil];
    DDRegisterVC *vc = [sb instantiateInitialViewController];
    vc.isHomeVc = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 新手标详情View */
- (void)cycleViewClick {
    DDInvestSegmentVC *segVc = [[DDInvestSegmentVC alloc] init];
    BXInvestmentModel *model = self.dataArray[0];
    if (model.B_ID) {
        segVc.loanID = model.B_ID;
        segVc.tempModel = model;
    }
    [self.navigationController pushViewController:segVc animated:YES];
}

/**立即出借*/
- (void)InvestBtnBtnClick {
    HXTabBarViewController * tabBarVC = (HXTabBarViewController *)self.tabBarController;
    if (tabBarVC.bussinessKind) { //登录

        if ([self isCanSubmit]) {

            UIStoryboard *segsb = [UIStoryboard storyboardWithName:@"DDInvestSureVC" bundle:nil];
            DDInvestSureVC *segVc=  [segsb instantiateInitialViewController];
            segVc.loanId = self.model.B_ID;
            segVc.levelName =  userCardInfo[@"body"][@"levelName"];
            [self.navigationController pushViewController:segVc animated:YES];
        }

    }else{ //未登录
        [self presentLoginVC];
    }
}

// 弹出登录页面
- (void)presentLoginVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
}

#pragma mark - delegate =================================================
// MARK: 点击轮播回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

    if ([cycleScrollView isEqual:noticeView]) { //公告回调
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BXMessagedetailController" bundle:nil];
        BXMessagedetailController *VC = [sb instantiateInitialViewController];
        BXIndustryModel *model = self.noticeModelArr[index];
        VC.type = @"0";
        VC.parameterId = model.WZZX_ID;
        [self.navigationController pushViewController:VC animated:YES];
    } else { //轮播图回调
        if (self.LJDZArray.count) {
            //            DDBannarWebVc *weVc = [[DDBannarWebVc alloc]init];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
            DDActivityWebController *weVc = [sb instantiateInitialViewController];
            NSString *bannerUrl;
            HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
            if (tabbar.bussinessKind){
                bannerUrl = [self urlWithPersonalInfo:self.LJDZArray[index] WithState:@"1"];
            }else{
                bannerUrl = [self urlWithPersonalInfo:self.LJDZArray[index] WithState:@"0"];
            }
            weVc.webUrlStr = bannerUrl;
            weVc.webTitleStr = self.bannerTitleArray[index];
            weVc.imgUrlStr = self.FXJBArray[index];
            if (self.bannerDetailArray.count > 0) {
                weVc.webDetailStr = self.bannerDetailArray[index];
            }
            [self.navigationController pushViewController:weVc animated:YES];

        }
    }
}

/**
 点击升级资金账户
 */
- (void)didClickZhsjBtn {
    
    [self.ddcoverView removeUpgradeView];
    [self postUserActivatedUpgrade];
}

/**
 点击停服公告确定按钮
 */
-(void)didClickTfsjBtn {
    
    [self.ddcoverView removeUpgradeView];
}

// MARK: - DDDelegate
- (void)didClickNowRiskBtn {
    //跳转到风险评估
    DDRiskAssessViewController *assesVC = [[HXRiskAssessModel shareRiskModel] creaAssessVC];
    [self.navigationController pushViewController:assesVC animated:YES];
}

// MARK: - payThirdDelegate
- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXReminderPageController *remindPageVC = [storyBoard instantiateViewControllerWithIdentifier:@"BXReminderPageVC"];
    if (isSuccess) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ACTIVATED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        remindPageVC.remindeType = BXRemindeTypeOpenSuccess;
        [remindPageVC settingFrameWithBXRemindeType:remindPageVC.remindeType];
        [self.navigationController pushViewController:remindPageVC animated:YES];
    } else {
        
        remindPageVC.remindeType = BXRemindeTypeOpenFailure;
        [remindPageVC settingFrameWithBXRemindeType:remindPageVC.remindeType];
        [self.navigationController pushViewController:remindPageVC animated:YES];
    }
}

// MAKR: UINavigationControllerDelegate-隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - network request =================================================
// MARK: 获取bannerImage
- (void)postBannerImage
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBanner;
    info.dataParam = nil;

    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];

        [self.imageArray removeAllObjects];
        [self.bannerTitleArray removeAllObjects];
        [self.bannerDetailArray removeAllObjects];
        [self.LJDZArray removeAllObjects];

        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            NSURL *url = nil;

            NSMutableArray *bannerArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in dict[@"body"][@"banners"]) {
                if ([dic[@"ZDLX"] isEqualToString:@"1"]) {
                    [bannerArr addObject:dic];
                }

            }
            for (NSDictionary *dic in bannerArr) {

                [self.LJDZArray addObject:[NSString stringWithFormat:@"%@",dic[@"LJDZ"]]]; //url
                url = [self getImageUrlWithFilePath:dict[@"body"][@"filePath"] PictureStr:dic[@"SYTP"]];//图片
                [self.imageArray addObject:url];
                [self.bannerTitleArray addObject:dic[@"BT"]];  //标题
                [self.bannerDetailArray addObject:dic[@"BZ"]]; // detailStr
                [self.FXJBArray addObject:[NSString stringWithFormat:@"%@",dic[@"FXJB"]]];
            }

            [self initBannarView];
        }

    } faild:^(NSError *error) {

    }];
}

// MARK: 获取公告消息
- (void)postNoticeList
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestIndustry;
    info.dataParam = @{@"pageNum":@"1",@"pageSize":@"6",@"belong_type":@"notice"};

    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];

        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            [_noticeArray removeAllObjects];
            NSArray *dataArray = [BXIndustryModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
            self.noticeModelArr = dataArray;
            for (BXIndustryModel *model in dataArray) {
                [self.noticeArray addObject:model.BT];
            }
            [self initNoticeLabView];
        }

        [self.tableView.mj_header endRefreshing];
    } faild:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

// MARK: 获取用户绑卡信息
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};

    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];

        if ([dict[@"body"][@"resultcode"] integerValue] == 0){

            [DDAccount mj_objectWithKeyValues:dict[@"body"]];
            userCardInfo = dict;
            if (dict[@"body"][@"bankcardBind"][@"YHKH"]) {
                isBankCard = YES;
            } else {
                isBankCard = NO;
            }

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dict[@"body"][@"bankcardBind"][@"YHKH"] forKey:@"YHKH"];//银行卡号，用来处理是否开通托管
            [defaults setObject:dict[@"body"][@"currUser"][@"ACTIVATED"] forKey:@"ACTIVATED"];
            [defaults synchronize];

            [self popUpgradeView];  //升级弹窗
        }
    } faild:^(NSError *error) {
    }];
}

// MARK: POST获取首页新手标
- (void)postLoanNewList
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"rowsCount":@"1",@"termCount":@"0"}; //获取1个
    info.serviceString = BXRequestLoanNewList;

    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){

            NSArray *dataArray = [BXInvestmentModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"loanList"]];

            if (dataArray.count>0) {
                self.model = dataArray[0];
                self.dataArray = dataArray;
            }
            [self loadViewDatas];
        }
    } faild:^(NSError *error) {

    }];
}

- (void)loadViewDatas {
    if (_model.schedule) { //出借进度
        self.cycleView.persentage = [_model.schedule doubleValue]; //设置出借进度
    } else {
        self.cycleView.persentage = 0.0;
    }

    if ([_model.SFTYB isEqualToString:@"3"]) { // 新手标
        self.NewStandard.hidden = NO;

    } else { // 普通精品标
        self.NewStandard.hidden = YES;
    }
    if (_model.TXY.length > 0) { // 加息
        NSString *str = [NSString stringWithFormat:@"%g%%+%g%%",[_model.TXZ doubleValue] ,[_model.TXY doubleValue]];
        NSAttributedString *attr = [str homeAttributedStringWithSmallStr:@"%" smallFont:[UIFont systemFontOfSize:10.0f] bigFont:[UIFont systemFontOfSize:27.0f]];
        self.IncreasesInInterestRates.hidden = NO;
        self.percentLab.attributedText = attr;

    } else { // 不加息
        self.IncreasesInInterestRates.hidden = YES;
        if (_model.NHLL) { // 年化收益

            NSString *str = [NSString stringWithFormat:@"%g%%",[_model.NHLL doubleValue]];
            NSAttributedString *attr = [str homeAttributedStringWithSmallStr:@"%" smallFont:[UIFont systemFontOfSize:10.0f] bigFont:[UIFont systemFontOfSize:27.0f]];
            self.percentLab.attributedText = attr;

        } else { // 既不加息 也无年化收益的情况
            self.percentLab.text = @"--";
        }
    }

    if (_model.JKBT) { // 标题
        self.titleLab.text = [NSString stringWithFormat:@"  %@  ",_model.JKBT];
    } else {
        self.titleLab.text = @"暂无新手标";
    }

    if ([_model.schedule isEqualToString:@"1"] || ([_model.schedule integerValue] == 1)) {

        _InvestBtn.userInteractionEnabled = NO;
        //        [_InvestBtn  setBackgroundColor:[UIColor colorWithHexString:COLOUR_YELLOW]];
        [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"yellowBack"] forState:UIControlStateNormal];
        //        [_InvestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_InvestBtn setTitle:@"已经满标" forState:UIControlStateNormal];

    } else {
        _InvestBtn.userInteractionEnabled = YES;
        [_InvestBtn setBackgroundColor:COLOUR_BTN_BLUE_NEW];
        [_InvestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
        [_InvestBtn setTitle:@"立即出借" forState:UIControlStateNormal];//转成年月日，截止到日
        //        //倒计时
        //        _model.DJSKBSJ = @"1543896000000";
        //        _model.nowDate = @"1543889436100";

        NSString *daydjs = [NSDate transformStrToDay:_model.DJSKBSJ];
        NSString *daynow = [NSDate transformStrToDay:_model.nowDate];
        //截止到日转成秒  如果加入时分秒天数会不准
        NSString *s1 = [NSDate transformTimeToChuo:daydjs];
        NSString *s2 = [NSDate transformTimeToChuo:daynow];

        double tempmms = [s1 doubleValue] - [s2 doubleValue];
        double tempInt = ([_model.DJSKBSJ doubleValue] - [_model.nowDate doubleValue])/1000; //秒差
        ksecond = (int)tempInt %60;  //秒
        kminute = (int)tempInt /60 %60;
        khouse  = (int)tempInt /60 /60 %24;
        kday    = (int)tempmms /60 /60 /24;
        if (![_model.DJSKBSJ isEqualToString:@""] && tempInt > 0) {
            if (kday > 0) {  //大于1天
                NSString *investStr = [NSString stringWithFormat:@"%d天后 %@开标",kday,[NSDate ConvertStrToTime:_model.DJSKBSJ]];
                [_InvestBtn setTitle:investStr forState:UIControlStateNormal];
                [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
                [_InvestBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];
            } else if (kday==0  && khouse >= 2) {  //大于2小时

                //比较日期是不是一天
                if ([daydjs isEqualToString:daynow]) {    //是一天显示今日
                    NSString *investStr = [NSString stringWithFormat:@"今日 %@开标",[NSDate ConvertStrToTime:_model.DJSKBSJ]];
                    [_InvestBtn setTitle:investStr forState:UIControlStateNormal];

                } else {    //不是一天显示1天后
                    NSString *investStr = [NSString stringWithFormat:@"1天后 %@开标",[NSDate ConvertStrToTime:_model.DJSKBSJ]];
                    [_InvestBtn setTitle:investStr forState:UIControlStateNormal];
                }

                [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
                [_InvestBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];
            } else if (kday== 0 && khouse < 2) {   //小于2小时 开始执行倒计时
                //获取倒计时秒数
                long int tempS = khouse *60 *60 + kminute * 60 + ksecond;
                secondNum = [NSString stringWithFormat:@"%ld",tempS];
                [self CountDownNotification];

            }
        }else{
            [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
            [_InvestBtn setTitle:@"立即出借" forState:UIControlStateNormal];//转成年月日，截止到日
        }

    }


    if (_model.HKZQSL) { //项目期限
        if (_model.HKZQDW) { //项目期限单位
            if([_model.HKZQDW isEqualToString:@"1"]){ //天

                self.limitDayLab.text = [NSString stringWithFormat:@"项目期限：%@天",_model.HKZQSL];
            } else if([_model.HKZQDW isEqualToString:@"2"]){ //周

                self.limitDayLab.text = [NSString stringWithFormat:@"项目期限：%@周",_model.HKZQSL];
            } else if ([_model.HKZQDW isEqualToString: @"3"]) { //月

                self.limitDayLab.text = [NSString stringWithFormat:@"项目期限：%@个月",_model.HKZQSL];
            } if([_model.HKZQDW isEqualToString:@"4"]){ //年

                self.limitDayLab.text = [NSString stringWithFormat:@"项目期限：%@年",_model.HKZQSL];
            }
        }

    } else {
        self.limitDayLab.text = @"项目期限：--";
    }


    if (_model.ZE) { //项目规模
        //        if ([_model.ZE doubleValue] >= 10000) {
        //            NSString *amount = [NSString stringWithFormat:@"项目规模：%g万元",([_model.ZE doubleValue] / 10000)];
        //            self.amountLab.text = amount;
        //        }else{
        NSString *amountStr = [NSString stringWithFormat:@"项目金额：%.2lf元",[_model.ZE doubleValue]];
        self.amountLab.text = amountStr;
        //        }
    }else{
        self.amountLab.text = @"项目金额：--";
    }

}

// MARK: 升级银行存管
- (void)postUserActivatedUpgrade
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    //    info.serviceString = BXRequestBankcard;
    info.serviceString = DDRequestlmUserActivated;
    info.dataParam = @{@"vobankIdTemp":@""};

    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {

        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];

        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {

            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            //
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"账户升级";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            //            JumpThirdParty.payType = MPPayTypeOpenAccount;
            [self.navigationController pushViewController:JumpThirdParty animated:YES];
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }

    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];

    }];
}

- (void)CountDownNotification{

    /// 计算倒计时
    if ([_model.DJSKBSJ isEqualToString:@""]
        || [_model.nowDate doubleValue] > [_model.DJSKBSJ doubleValue]
        ||kday > 0
        ||(kday==0 && khouse >= 2)){

        return;
    }

    countDown = [secondNum integerValue] - kCountDownManager.timeInterval;

    if (countDown <= 0) {
        [_InvestBtn setTitle:@"立即出借" forState:UIControlStateNormal];
        [_InvestBtn setTitleColor:COLOUR_White forState:UIControlStateNormal];
        [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"yellowBack"] forState:UIControlStateNormal];
        return;
    }

    /// 重新赋值
    NSString *investStr = [NSString stringWithFormat:@"%01zd小时%02zd分%02zd秒", countDown/3600, (countDown/60)%60, countDown%60];
    [_InvestBtn setTitle:investStr forState:UIControlStateNormal];
    [_InvestBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
    [_InvestBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];
    
}

#pragma mark - getter =================================================
- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)bannerTitleArray
{
    if (_bannerTitleArray == nil) {
        _bannerTitleArray = [NSMutableArray array];
    }
    return _bannerTitleArray;
}

- (NSMutableArray *)bannerDetailArray
{
    if (_bannerDetailArray == nil) {
        _bannerDetailArray = [NSMutableArray array];
    }
    return _bannerDetailArray;
}

-(NSMutableArray *)LJDZArray
{
    if (_LJDZArray == nil) {
        _LJDZArray = [NSMutableArray array];
    }
    return _LJDZArray;
}

- (NSMutableArray *)FXJBArray
{
    if (_FXJBArray == nil) {
        _FXJBArray = [NSMutableArray array];
    }
    return _FXJBArray;
}

- (NSMutableArray *)noticeArray
{
    if (_noticeArray == nil) {
        _noticeArray = [NSMutableArray array];
    }
    return _noticeArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
