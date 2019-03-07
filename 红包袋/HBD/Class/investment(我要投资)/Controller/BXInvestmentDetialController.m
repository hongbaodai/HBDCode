//
//  BXInvestmentDetialController.m
//  sinvo
//
//  Created by 李先生 on 15/4/4.
//  Copyright (c) 2015年 李先生. All rights reserved.
//  项目详情

@class BXInvestmentDetailModel;
#import "BXInvestmentDetialController.h"
#import "BXInvestmentDetailHeader.h"
#import "BXInvestmentDetailModel.h"
#import "BXInvestmentDetialCell.h"
#import "BXJumpThirdPartyController.h"
#import "BXAccountAssetsVC.h"
#import "MYAlertView.h"
#import "MYPopupView.h"
#import "BXReminderPageController.h"
#import "BXInvestFailureController.h"
#import "BXInvestSuccessController.h"
#import "BXProjectDescriptionController.h"
#import "BXHFRechargeController.h"
#import "BXCouponListCell.h"
#import "BXBankCardInfoController.h"
#import "DDChooseRedbaoController.h"
#import "OYCountDownManager.h"
#import "DDWebViewVC.h"
#import "DDAccount.h"
#import "NSString+Other.h"
#import "NSDate+Setting.h"
#import "AppUtils.h"

typedef NS_ENUM(NSUInteger, DDSetStyle) {
    DDSetStylebindCard,             // 绑定银行卡
    DDSetStyleOther,            //
};
@interface BXInvestmentDetialController ()<UITableViewDelegate,UITableViewDataSource,BXInvestmentDetailProtocol,UITextFieldDelegate,PayThirdPartyProtocol,MYALertviewDelegate,MYPopupDelegate, DDChooseHbDelegate>

@property (nonatomic, weak) BXInvestmentDetailHeader *investmentDetailHeader;
@property (nonatomic, strong) BXInvestmentDetailModel  *element;
// 当前选择的红包model
@property (nonatomic, strong) BXCouponModel  *selectedModel;
@property (nonatomic, strong) BXCouponModel  *selectedMoreModel;
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UITableView *tableView;
// 红包ID
@property (nonatomic, copy) NSString *redPactID;
// 多选红包ID
@property (nonatomic, copy) NSString *moreRedPactID;
// 投资按钮
@property (nonatomic, strong) UIButton  *investBtn;
// 单选红包
@property (nonatomic, strong) NSMutableArray *singleCouponArr;
// 多选红包
@property (nonatomic, strong) NSMutableArray *moreCouponArr;

//  倒计时
@property (nonatomic, assign) NSInteger countDownNum;

@property (nonatomic, assign) DDSetStyle styleBan;

@end

@implementation BXInvestmentDetialController
{
    // 弹出的底视图
    UIView *_bottomView;
    UIView *_bottomgraryView;
    // 弹出的红包按钮
    UITableView *_couponTableView;
    // 红包数组
    NSArray *couponArray;
    // 记录当前选中的index，用于取消选择
    NSInteger _selectedIndex;
    // 记录选中多选红包
    NSMutableArray *moreHbArray;
    // 保存红包页选中的 做清空处理
    NSMutableArray *moreHbSelectedArr;
    // 多选后红包金额
    double moreHbMoney;
    // 当前可用红包数组
    NSArray *availbleArray;
    //记录红包最小使用条件
    CGFloat min_value;
    
    //记录秒数
    NSString *secondNum;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    [self addFoolRightBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title = @"项目详情";
    
    moreHbArray = [NSMutableArray array];
    
    if (self.loanId) {
        [self postLoanDetailWithLoanId:self.loanId];
    }else{
        [MBProgressHUD showError:@"网络异常"];
    }
    [self refreshButtonStateWithInvestmentDetailModel:self.element];
    
    if (self.investmentDetailHeader) {
        [self refreshAccountBalanceLabState];
    }
    
    // 创建视图
    [self settingFrame];
    [self addFooterBtn];
    [self.tableView reloadData];
    
    [self.investmentDetailHeader.investMoneyTextField resignFirstResponder];
    
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSelectedCouponAvaiable) name:UITextFieldTextDidChangeNotification object:self.investmentDetailHeader.investMoneyTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAvailableArray) name:UITextFieldTextDidChangeNotification object:self.investmentDetailHeader.investMoneyTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoMatchCoupon) name:UITextFieldTextDidChangeNotification object:self.investmentDetailHeader.investMoneyTextField];
}

#pragma mark - 立即投资按钮
- (void) addFooterBtn
{
    BXInvestmentDetailHeader *investmentDetailHeader = [BXInvestmentDetailHeader investmentDetailHeaderView];
    CGFloat height;
    if (SCREEN_SIZE.width == 320) {
        height = 530.0;
    }else{
        height = SCREEN_SIZE.height-144;
    }
    investmentDetailHeader.frame = CGRectMake(0, 0, SCREEN_SIZE.width, height);
    self.investmentDetailHeader = investmentDetailHeader;
    self.investmentDetailHeader.investmentDelegate = self;
    self.investmentDetailHeader.investMoneyTextField.delegate = self;
    self.tableView.tableHeaderView = investmentDetailHeader;
    
    self.investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.investBtn.frame = CGRectMake(0, SCREEN_SIZE.height-64-44, SCREEN_SIZE.width, 44);
    //    self.investBtn.backgroundColor = [UIColor redColor];
    //    [self.investBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    //----添加倒计时-----------
    [self addCountText];
    
    [self.investBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.investBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.investBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.investBtn addTarget:self action:@selector(didClickInvestBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.investBtn];
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
            NSString *investStr = [NSString stringWithFormat:@"%d天后%@开标",day,[NSDate ConvertStrToTime:_element.DJSKBSJ]];
            [self.investBtn setTitle:investStr forState:UIControlStateNormal];
            self.investBtn.enabled = NO;
            
        }else if (day==0  && house >= 2) {
            //大于2小时
            //比较日期是不是一天
            if ([daydjs isEqualToString:daynow]) {
                //是一天显示今日
                NSString *investStr = [NSString stringWithFormat:@"今日%@开标",[NSDate ConvertStrToTime:_element.DJSKBSJ]];
                [self.investBtn setTitle:investStr forState:UIControlStateNormal];
                self.investBtn.enabled = NO;
                
            } else {
                //不是一天显示1天后
                NSString *investStr = [NSString stringWithFormat:@"1天后%@开标",[NSDate ConvertStrToTime:_element.DJSKBSJ]];
                [self.investBtn setTitle:investStr forState:UIControlStateNormal];
                self.investBtn.enabled = NO;
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
                [countDownBtn setTitle:@"立即投资" forState:UIControlStateNormal];
                countDownBtn.enabled = YES;
                countDownBtn.userInteractionEnabled = YES;
            });
            
        } else {
            
            NSString *strTimeh = [NSString stringWithFormat:@"%02zd", timeout/3600];
            NSString *strTimem = [NSString stringWithFormat:@"%02zd", (timeout/60)%60];
            NSString *strTimes = [NSString stringWithFormat:@"%02zd", timeout%60];
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [countDownBtn setTitle:[NSString stringWithFormat:@"%@小时%@分钟%@秒", strTimeh, strTimem, strTimes] forState:UIControlStateNormal];
                countDownBtn.userInteractionEnabled = NO;
                countDownBtn.enabled = NO;
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}

//--------------------添加倒计时----------------------------
#pragma mark - 点击选择红包
- (void)selectCouponBtnClick
{
    [self refreshAvailableArray];
    DDChooseRedbaoController *chVc = [[DDChooseRedbaoController alloc] init];
    chVc.chooseHbDelegate = self;
    chVc.singleCouponArr = self.singleCouponArr;
    chVc.moreMouponArr = self.moreCouponArr;
    chVc.availbleHbArr = availbleArray;
    chVc.investMoney = self.investmentDetailHeader.investMoneyTextField.text;
    chVc.singleIndex = _selectedIndex;
    chVc.singleModel = _selectedModel;
    chVc.moreModelArr = moreHbArray;
    chVc.moreHbSelectedArr = moreHbSelectedArr;
    chVc.dikouNum = moreHbMoney;
    
    [self.navigationController pushViewController:chVc animated:YES];
}

#pragma mark - DDChooseHbDeleagate
- (void)didSingleSingleHb:(BXCouponModel *)singleHb AndHbID:(NSInteger)hbID
{
    _selectedIndex = hbID;
    _selectedModel = singleHb;
    if (_selectedIndex == -1) {
        
        [self unselectedState];
    } else {
        //清除多选
        [moreHbArray removeAllObjects];
        [moreHbSelectedArr removeAllObjects];
        
        BXCouponModel *model = _singleCouponArr[_selectedIndex];
        self.redPactID = model.YHQ_ID;
        if (!self.investmentDetailHeader.investMoneyTextField.text.length) {
            
            if ([model.SYTJ isEqualToString:@"0.00"]) {//现金红包起投金额
                
                self.investmentDetailHeader.investMoneyTextField.text = self.element.QTJE;
            } else {
                self.investmentDetailHeader.investMoneyTextField.text = [NSString stringWithFormat:@"%.02f",[model.SYTJ doubleValue]];
            }
            
            [self refreshAvailableArray];
        }
        [self refreshSelectedCouponAvaiable];
    }
    [self refreshSingleActualPayment];
    [self refreshExpectProfit];
}

- (void)didMoreHbArr:(NSArray *)hbArr AndDikouNum:(double)dkNum
{
    if (hbArr == nil || hbArr.count == 0) {
        
        [self unselectedState];
    } else {
        //清除单选
        _selectedModel = nil;
        
        moreHbArray = (NSMutableArray *)hbArr;
        moreHbMoney = dkNum;
        BXCouponModel *model =  nil;
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableArray *redpactIDArr = [NSMutableArray array];
        for (int i = 0; i < moreHbArray.count; i++) {
//            model = [[BXCouponModel alloc] init];
            model = moreHbArray[i];
            [tempArr addObject:model.SYTJ]; //使用条件
            [redpactIDArr addObject:model.YHQ_ID];
        }
        NSString *IDstring = [redpactIDArr componentsJoinedByString:@","];
        
        _moreRedPactID = IDstring;
        if (!self.investmentDetailHeader.investMoneyTextField.text.length) {
            
            if ([model.SYTJ isEqualToString:@"0.00"]) {//现金红包起投金额
                
                self.investmentDetailHeader.investMoneyTextField.text = [NSString stringWithFormat:@"%.02f",model.MZ];
            } else {
                //求数组里限额额和
                CGFloat sumValue = [[tempArr valueForKeyPath:@"@sum.floatValue"] floatValue];;
                
                self.investmentDetailHeader.investMoneyTextField.text = [NSString stringWithFormat:@"%.02f",sumValue];
            }
            //取红包金额最大值
            //            CGFloat maxValue = [[tempArr valueForKeyPath:@"@max.floatValue"] floatValue];
            
        }
        [self refreshMoreHbAvaiable];
    }
    [self refreshMoreHbActualPayment];
    [self refreshExpectProfit];
}

#pragma  mark - 动态刷新 实际支付金额
- (void)refreshSingleActualPayment
{
    //单选
    BXInvestmentDetailModel *element = self.element;
    BXCouponModel *model = self.selectedModel;
    // 判断登录状况
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
    if (self.selectedModel) {
        if (inputText.length) {
            // 不可用红包或者无可用红包或者未登录或者是加息券
            if (![element.SFSYYHQ isEqual:@"Y"] || couponArray.count == 0 || !tabbar.bussinessKind || [model.YHQLB integerValue] == 2) {
                self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",[inputText doubleValue]];
            } else { //现金券
                if (self.selectedModel) {
                    double amount = [inputText doubleValue] - model.MZ;
                    self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",amount];
                } else {
                    self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",[inputText doubleValue]];
                }
            }
        } else {
            self.investmentDetailHeader.actualPaymentLab.text = @"0.00";
        }
    } else {
        if (inputText.length) {
            self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",[inputText doubleValue]];
        } else {
            self.investmentDetailHeader.actualPaymentLab.text = @"0.00";
        }
    }
}

- (void)refreshMoreHbActualPayment
{
    //多选
    BXInvestmentDetailModel *element = self.element;
    // 判断登录状况
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
    if (moreHbArray && moreHbArray.count != 0) {
        if (inputText.length) {
            // 不可用红包或者无可用红包或者未登录或者是加息券
            if (![element.SFSYYHQ isEqual:@"Y"] || couponArray.count == 0 || !tabbar.bussinessKind ) {
                self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",[inputText doubleValue]];
            } else { //现金券
                if (moreHbArray) {
                    
                    double amount = [inputText doubleValue] - moreHbMoney;
                    self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",amount];
                } else {
                    self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",[inputText doubleValue]];
                }
            }
        } else {
            self.investmentDetailHeader.actualPaymentLab.text = @"0.00";
        }
    } else {
        if (inputText.length) {
            self.investmentDetailHeader.actualPaymentLab.text = [NSString stringWithFormat:@"%.2lf",[inputText doubleValue]];
        } else {
            self.investmentDetailHeader.actualPaymentLab.text = @"0.00";
        }
    }
}

#pragma mark - 动态刷新预期收益
- (void)refreshExpectProfit
{
    NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
    NSString *expectProfit = [self CalculationExpected:inputText Yield:self.element.NHLL time:[self.element.HKZQSL intValue] type:[self.element.HKZQDW intValue] productId:[self.element.HKFS intValue]];
    if (self.selectedModel) {
        if (inputText.length) {
            
            self.investmentDetailHeader.expectProfitLab.text = expectProfit;
            
        } else {
            self.investmentDetailHeader.expectProfitLab.text = @"0.00";
        }
    } else {
        if (inputText.length) {
            self.investmentDetailHeader.expectProfitLab.text = expectProfit;
        } else {
            self.investmentDetailHeader.expectProfitLab.text = @"0.00";
        }
    }
}

#pragma mark - 刷新可用余额状态(登录未登录)
- (void)refreshAccountBalanceLabState
{
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    if (!tabbar.bussinessKind) {
        self.investmentDetailHeader.accountBalanceState.text = @"可用余额登录后可见";
        self.investmentDetailHeader.accountBalanceLab.text = @"";
        self.investmentDetailHeader.redPactTypeLab.text = @"登录查看红包信息";
        [self.investmentDetailHeader.selectedBtn setTitle:@"[登录]" forState:UIControlStateNormal];
        
    } else {
        self.investmentDetailHeader.accountBalanceState.text = @"可用余额：";
        [self postAccountInfo];
        // 将输入框数值和选中红包置空
        self.investmentDetailHeader.investMoneyTextField.text = @"";
        [self.investmentDetailHeader.investMoneyTextField resignFirstResponder];
        self.selectedModel = nil;
        _selectedIndex = -1;
        //        [_couponTableView reloadData];
        if ([self.element.SFSYYHQ isEqual:@"Y"]) {
            if (couponArray.count) {
                [self.investmentDetailHeader.selectedBtn setTitle:@"[选择]" forState:UIControlStateNormal];
                self.investmentDetailHeader.selectedBtn.hidden = NO;
                self.investmentDetailHeader.selectedBtn.userInteractionEnabled = YES;
                self.investmentDetailHeader.redPactTypeLab.text = @"有未使用红包";
            }else{
                self.investmentDetailHeader.selectedBtn.hidden = YES;
                self.investmentDetailHeader.selectedBtn.userInteractionEnabled = NO;
                self.investmentDetailHeader.redPactTypeLab.text = @"无可用红包";
            }
        }
    }
    // 刷新选中按钮状态
    //    [self refreshCheckboxBtnState];
}

#pragma mark - 根据输入金额匹配红包
// 实时刷新单选红包
- (void)refreshSelectedCouponAvaiable
{
    //    // 刷新选择按钮状态
    //    [self refreshCheckboxBtnState];
    
    if (self.selectedModel) { //选中单选红包
        if ([self.element.SFSYYHQ isEqual:@"Y"]) {
            if ([self.selectedModel.YHQLB integerValue] == 1) { // 红包
                if (self.selectedModel) {
                    self.investmentDetailHeader.redPactTypeLab.text = [NSString stringWithFormat:@"已选择1个红包，可抵扣现金%.2f元",self.selectedModel.MZ];
                } else {
                    self.investmentDetailHeader.redPactTypeLab.text = [NSString stringWithFormat:@"无可用红包"];
                }
            } else {  // 现金红包
                if (self.selectedModel) {
                    
                    self.investmentDetailHeader.redPactTypeLab.text = [NSString stringWithFormat:@"已选择1个红包，可抵扣现金%.2f元",self.selectedModel.MZ];
                } else {
                    self.investmentDetailHeader.redPactTypeLab.text = [NSString stringWithFormat:@"无可用红包"];
                }
            }
            
        } else {
            self.investmentDetailHeader.redPactTypeLab.text = @"本标不可使用红包";
        }
    }
}

// 实时刷新多选红包
- (void)refreshMoreHbAvaiable
{
    //    // 刷新选择按钮状态
    //    [self refreshCheckboxBtnState];
    if(moreHbArray && moreHbArray.count != 0){
        self.investmentDetailHeader.redPactTypeLab.text = [NSString stringWithFormat:@"已选择%ld个红包，可抵扣现金%g元", (unsigned long)moreHbArray.count ,moreHbMoney];
    } else {
        self.investmentDetailHeader.redPactTypeLab.text = @"本标不可使用红包";
    }
}

// 手动选择的红包是否可用
//- (BOOL)couponIsAvaiable:(BXCouponModel *)model{
//    NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
//    if (inputText.length) {
//
//        if ([inputText doubleValue] >= [model.SYTJ doubleValue]) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }else{
//        return NO;
//    }
//}

#pragma mark -根据金额变化，实时筛选可用红包
- (void)refreshAvailableArray
{
    // 判断登录状况
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
    if (tabbar.bussinessKind) {
        if (couponArray.count) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            for (BXCouponModel *model in couponArray) {
                
                if (inputText.length) {
                    
                    [self AutoRedPacketHKZQDW:model And:tempArray];
                } else {
                    
                    if (self.element.HKZQDW) {
                        if ([self.element.HKZQDW isEqualToString: @"3"]) {
                            //月
                            // 使用期限无限制0，或者 起投期限<= 投资期限
                            if ([model.QTQX isEqualToString:@"0"] || ([model.QTQX doubleValue] <= [self.investmentDetailHeader.termCountLab.text doubleValue])) {
                                
                                [tempArray addObject:model];
                                
                            } else {
                                availbleArray = nil;
                            }
                            
                        } else if ([self.element.HKZQDW isEqualToString: @"1"]){
                            
                            // 天*30比较 // 使用期限无限制0，或者 起投期限<= 投资期限
                            if ([model.QTQX isEqualToString:@"0"]
                                || ([model.QTQX doubleValue] * 30 <= [self.investmentDetailHeader.termCountLab.text doubleValue])) {
                                [tempArray addObject:model];
                                
                            } else {
                                availbleArray = nil;
                            }
                            
                        } else if ([self.element.HKZQDW isEqualToString: @"2"]){
                            // 周
                        } else if ([self.element.HKZQDW isEqualToString: @"4"]){
                            // 年
                        }
                    }
                }
            }
            availbleArray = [NSArray arrayWithArray:tempArray];
            
        }else{
            availbleArray = nil;
        }
    }else{
        availbleArray = nil;
    }
}

// 将状态置于未选中
- (void)unselectedState
{
    if ([self.element.SFSYYHQ isEqual:@"Y"]) {
        if (couponArray.count) {
            self.investmentDetailHeader.redPactTypeLab.text = @"有未使用红包";
        }else{
            self.investmentDetailHeader.redPactTypeLab.text = @"无可用红包";
        }
    }
    self.selectedModel = nil;
    //    [self refreshCheckboxBtnState];
    [self refreshSingleActualPayment];
    [self refreshExpectProfit];
    _selectedIndex = -1;
}

// 根据已选model获取整个数组中选中的位置
- (NSInteger)searchIndexWithModel:(BXCouponModel *)model
{
    NSInteger index = -1;
    for (int i = 0; i < _singleCouponArr.count; i ++) {
        BXCouponModel *item = _singleCouponArr[i];
        if ([item.YHQ_ID isEqual:model.YHQ_ID]) {
            index = i;
        }
    }
    return index;
}

//借款单位来处理红包匹配
- (void)AutoRedPacketHKZQDW:(BXCouponModel *)model And:(NSMutableArray *)mutableArr
{
    
    NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
    
    if (self.element.HKZQDW) {
        if ([self.element.HKZQDW isEqualToString: @"3"]) {
            //月
            // 使用期限无限制0，或者 起投期限<= 投资期限
            if ([model.QTQX isEqualToString:@"0"] || ([model.QTQX doubleValue] <= [self.investmentDetailHeader.termCountLab.text doubleValue])) {
                
                if ([inputText doubleValue] >= [model.SYTJ doubleValue]) { //可用红包
                    model.QTQXINT = [model.QTQX integerValue];
                    [mutableArr addObject:model];
                }
            }
            
        } else if ([self.element.HKZQDW isEqualToString: @"1"]){
            
            // 天*30比较 // 使用期限无限制0，或者 起投期限<= 投资期限
            if ([model.QTQX isEqualToString:@"0"] || ([model.QTQX doubleValue] * 30 <= [self.investmentDetailHeader.termCountLab.text doubleValue])) {
                
                if ([inputText doubleValue] >= [model.SYTJ doubleValue]) { //可用红包
                    
                    if ([inputText doubleValue] >= [model.SYTJ doubleValue]) { //可用红包
                        model.QTQXINT = [model.QTQX integerValue];
                        [mutableArr addObject:model];
                    }
                }
                
            } else if ([self.element.HKZQDW isEqualToString: @"2"]){
                // 周
            } else if ([self.element.HKZQDW isEqualToString: @"4"]){
                // 年
            }
        }
    }
}

#pragma mark - 根据金额变化，实时自动匹配
- (void)autoMatchCoupon
{
    // 判断登录状况
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    if (tabbar.bussinessKind) {
        NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
        
        NSMutableArray *oneHbArray = [[NSMutableArray alloc]init];
        for (BXCouponModel *model in couponArray) {
            [oneHbArray addObject:model.SYTJ];
        }
        min_value = [[oneHbArray valueForKeyPath:@"@min.floatValue"] floatValue];  //最小值
        
        // 获取最小值
        NSMutableArray *sinHbArray = [[NSMutableArray alloc]init];
        
        for (BXCouponModel *model in self.singleCouponArr) {
            [sinHbArray addObject:model.SYTJ];
        }
        CGFloat min_sin = [[sinHbArray valueForKeyPath:@"@min.floatValue"] floatValue];
        
        //获取单选有没有可用，没有去匹配多选
        NSMutableArray *tempSArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < _singleCouponArr.count; i ++) {

            BXCouponModel *model = _singleCouponArr[i];

            [self AutoRedPacketHKZQDW:model And:tempSArr];
        }

        if (inputText.length && [inputText floatValue] >= min_value) { // 判断输入框输入长度
            if ([NSString checkNum:inputText]) {
                
                if ([self existCashCoupon]) { // 有红包
                    
                    NSMutableArray *sigtempArray = [[NSMutableArray alloc]init];
                    NSMutableArray *mortempArray = [[NSMutableArray alloc]init];

                    if (self.singleCouponArr &&self.singleCouponArr.count != 0 && tempSArr.count!= 0 && [inputText floatValue] >= min_sin ) { //匹配单选红包
  
                        for (int i = 0; i < _singleCouponArr.count; i ++) {
                            
                            BXCouponModel *model = _singleCouponArr[i];
                            
                            [self AutoRedPacketHKZQDW:model And:sigtempArray];

                            
                            if (sigtempArray.count) {
                                // 获取最大值
                                int j = 0;
                                //                            double max = 0.0;
                                
                                NSArray *array = (NSArray *)sigtempArray;
                                //构建排序描述器
                                NSSortDescriptor *MZDesc = [NSSortDescriptor sortDescriptorWithKey:@"MZ" ascending:NO];
                                NSSortDescriptor *QTQXDesc = [NSSortDescriptor sortDescriptorWithKey:@"QTQXINT" ascending:NO];
                                NSSortDescriptor *JZRQDesc = [NSSortDescriptor sortDescriptorWithKey:@"DDJZRQ" ascending:YES];
                                
                                NSArray *descriptorArray = [NSArray arrayWithObjects:MZDesc ,JZRQDesc ,QTQXDesc, nil];
                                NSArray *sortedArray = [array sortedArrayUsingDescriptors: descriptorArray];

                                
                                BXCouponModel *dmodel = sortedArray[0];
                                
                                for (int i =0; i< sigtempArray.count; i++) {
                                    BXCouponModel *model = sigtempArray[i];
                                    if (dmodel.YHQ_ID == model.YHQ_ID) {
                                        j = i;
                                    }
                                }

                                
                                // 用最大的model刷新当前选中状态
                                self.selectedModel = sigtempArray[j];
                                [moreHbArray removeAllObjects];
                               
                                self.redPactID = self.selectedModel.YHQ_ID;
                                // 刷新列表选中状态
                                _selectedIndex = [self searchIndexWithModel:self.selectedModel];
                                
                                 [self refreshSelectedCouponAvaiable];
                            }
                        }
                        
                    } else {//匹配多选红包
                        
                        [moreHbArray removeAllObjects];
                        
                        for (int i = 0; i < _moreCouponArr.count; i ++) {
                            BXCouponModel *model = _moreCouponArr[i];
    
                             [self AutoRedPacketHKZQDW:model And:mortempArray];

                        }
                        if (mortempArray.count) {
                            // 获取最大值
                            int j = 0;
           
                            NSArray *array = (NSArray *)mortempArray;
                            //构建排序描述器
                            NSSortDescriptor *MZDesc = [NSSortDescriptor sortDescriptorWithKey:@"MZ" ascending:NO];
                            NSSortDescriptor *QTQXDesc = [NSSortDescriptor sortDescriptorWithKey:@"QTQXINT" ascending:NO];
                            NSSortDescriptor *JZRQDesc = [NSSortDescriptor sortDescriptorWithKey:@"DDJZRQ" ascending:YES];
                            
                            NSArray *descriptorArray = [NSArray arrayWithObjects:MZDesc ,JZRQDesc ,QTQXDesc, nil];
                            NSArray *sortedArray = [array sortedArrayUsingDescriptors: descriptorArray];
          
                            BXCouponModel *dmodel = sortedArray[0];
                            
                            for (int i =0; i< mortempArray.count; i++) {
                                BXCouponModel *model = mortempArray[i];
                                if (dmodel.YHQ_ID == model.YHQ_ID) {
                                    j = i;
                                }
                            }
            
                            // 用最大的model刷新当前选中状态
                            [moreHbArray addObject:mortempArray[j]];
                            self.selectedModel = mortempArray[j];
                            self.redPactID = self.selectedModel.YHQ_ID;
                            [self refreshSelectedCouponAvaiable];
                        }
                    }
                    
                    if (sigtempArray.count == 0 && moreHbArray.count == 0) {
                        [self unselectedState];
                    }
                } else {
                    
                    [self unselectedState];
                }
            }else{
                [MBProgressHUD showError:@"请输入合法的投资金额"];
            }
        }else{
            
            //如果输入金额没有满足红包全部清空
            self.selectedModel = nil;
            [moreHbArray removeAllObjects];
            moreHbMoney = 0;
            
            [self unselectedState];
        }
    }
    if (self.selectedModel) {
        [self refreshSingleActualPayment];
    } else {
        [self refreshMoreHbActualPayment];
    }
    [self refreshExpectProfit];
}

// 循环监测是否有现金券（匹配优先级，先现金券，后加息券）
- (BOOL)existCashCoupon
{
    NSString *inputText = self.investmentDetailHeader.investMoneyTextField.text;
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (BXCouponModel *model in couponArray) {
        if ([inputText doubleValue] >= [model.SYTJ doubleValue]) {
            [tempArray addObject:model];
        }
    }
    for (BXCouponModel *model in tempArray) {// 红包类别（1：红包，2：加息劵（暂未使用），3：现金红包）
        if ([model.YHQLB integerValue] == 1
            ||[model.YHQLB integerValue] == 3 ) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 右上角详情按钮
- (void)addFoolRightBtn
{
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

// 点击项目详情按钮
- (void)rightBtnClick
{
    BXProjectDescriptionController *VC = [[BXProjectDescriptionController alloc]init];
    VC.loanId = self.loanId;
    [self.navigationController pushViewController:VC animated:YES];
}

// 限制输入长度为一千万
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 7) {
        return NO;
    }else{
        return YES;
    }
}

// 根据参数刷新项目可用红包状态
- (void)refreshRedPactStateWithModel:(BXInvestmentDetailModel *)model
{
    // 刷新角标
    if ([model.YHZ_ID isEqualToString:@"3"]) {
        self.investmentDetailHeader.redPactView.hidden = NO;
        self.investmentDetailHeader.redPactView.image = [UIImage imageNamed:@"shangyuanzhuanxiang"];
    }else if((![model.TXY isEqualToString:@""]) && (![model.TXZ isEqualToString:@""])){
        self.investmentDetailHeader.redPactView.hidden = NO;
        self.investmentDetailHeader.redPactView.image = [UIImage imageNamed:@"pingtaitiexi"];
    }else{
        self.investmentDetailHeader.redPactView.hidden = YES;
    }
    // 刷新标题位置
    if (self.investmentDetailHeader.redPactView.hidden == YES) {
        self.investmentDetailHeader.titleConstraint.constant = 15;
    }else{
        self.investmentDetailHeader.titleConstraint.constant = 40;
    }
    // 刷新选择按钮和选中按钮的状态
    if (![model.SFSYYHQ isEqual:@"Y"]) {
        //        self.investmentDetailHeader.checkboxButton.hidden = YES;
        //        self.investmentDetailHeader.checkboxButton.userInteractionEnabled = NO;
        self.investmentDetailHeader.selectedBtn.hidden = YES;
        self.investmentDetailHeader.selectedBtn.userInteractionEnabled = NO;
        self.investmentDetailHeader.redPactTypeLab.text = @"本标不可使用红包";
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 设置视图
- (void)settingFrame
{
    UITableView *tableView;
    if (tableView == nil) {
        tableView = [[UITableView alloc] init];
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
    }
    self.tableView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
    self.tableView.backgroundColor = DDRGB(240, 240, 240);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self refreshButtonStateWithInvestmentDetailModel:self.element];
}

// 判断用户组权限
-(BOOL)isPermission :(NSString *)YHZ_ID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *usergroup=[defaults objectForKey:@"usergroup"];
    //   如果用户组id为空
    if ([YHZ_ID isEqualToString:@""]) {
        //    有投资权限
        return YES;
    }else if ([usergroup isEqualToString:@""]) {
        return NO;
    }else{
        NSArray  * array= [usergroup componentsSeparatedByString:@","];
        for (int i=0; i<array.count;i++) {
            if ([YHZ_ID isEqualToString:array[i]]) {
                return YES;
            }
        }
    }
    return NO;
}

// 刷新立即投资按钮状态
- (void)refreshButtonStateWithInvestmentDetailModel:(BXInvestmentDetailModel *)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    if ([defaults objectForKey:@"roles"] == nil || [[defaults objectForKey:@"roles"] intValue] == 1) {
    if ([self.JKZH_ID isEqual:[defaults objectForKey:@"userId"]]) {
        
        [self.investBtn  setBackgroundColor:[UIColor grayColor]];
        [self.investBtn setTitle:@"不可购买自己发起的借款" forState:UIControlStateNormal];
        self.investBtn.userInteractionEnabled = NO;
    } else {
        if (![self.loanProductId isEqualToString:@"518"]) {
            if (model) {
                self.schedule = model.schedule;
                self.YHZ_ID = model.YHZ_ID;
            }
            
            NSString *string=self.YHZ_ID;
            if ([self isPermission:string]) {
                if ([self.schedule isEqualToString:@"1"] || ([self.schedule integerValue] == 1)) {
                    [self.investBtn  setBackgroundColor:[UIColor grayColor]];
                    [self.investBtn setTitle:@"已满标" forState:UIControlStateNormal];
                    self.investBtn.userInteractionEnabled = NO;
                } else {
                    self.investBtn.userInteractionEnabled = YES;
                    [self.investBtn setBackgroundColor:COLOUR_BTN_BLUE];
                    [self.investBtn setTitle:@"立即投资" forState:UIControlStateNormal];
                    //                    self.investmentDetailHeader.inverstConstraint.constant = 44;
                }
            } else {
                [self.investBtn  setBackgroundColor:[UIColor grayColor]];
                [self.investBtn setTitle:@"无投资权限" forState:UIControlStateNormal];
                self.investBtn.userInteractionEnabled = NO;
                //                self.investmentDetailHeader.inverstConstraint.constant = 0;
            }
            
        } else {
            [self.investBtn  setBackgroundColor:[UIColor grayColor]];
            [self.investBtn setTitle:@"大客户专享" forState:UIControlStateNormal];
            self.investBtn.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - 点击合同
//我已知悉并同意《平台服务协议》、《借款合同》、《风险告知书》
-(void)didClickPactBtnWithPact:(NSString *)pact
{
    
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    if (!tabbar.bussinessKind) {
        
        [self presentLoginVC];
        
    }else{
        
        DDWebViewVC *webVc = [[DDWebViewVC alloc] init];
        webVc.weburlStr = pact;
        webVc.weburlStyle = self.element.JXFS;
        BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:webVc];
        [self presentViewController:Nav animated:YES completion:nil];
        //        [self.navigationController pushViewController:Nav animated:YES];
    }
}

#pragma mark -  点击投资按钮
- (void)didClickInvestBtn
{
    BXTabBarController * tabBarVC = (BXTabBarController *)self.tabBarController;
    if (tabBarVC.bussinessKind) {
        [self didClickInvestBtnToInvestMethed];
        
    }else{
        [self presentLoginVC];
    }
}

// 点击投资按钮触发判断条件
- (void)didClickInvestBtnToInvestMethed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *avlBalStr = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
    
    if (self.investmentDetailHeader.investMoneyTextField.text.length == 0) {
        
        [MBProgressHUD showError:@"请输入投资金额"];
    } else {
        //waring !!!：因为有2位小数，取余数操作为int会把小数舍掉，所以先乘100，后期有问题再改
        int numLAB = [self.investmentDetailHeader.investMoneyTextField.text doubleValue]*100;
        int numQTJE = [self.element.QTJE doubleValue]*100;
        int numDZJE  = [self.element.DZJE doubleValue]*100;
        
        if ([NSString checkNum:self.investmentDetailHeader.investMoneyTextField.text]) {//输入的是整数或小数
            //借款金额 - 已投标金额 < 起投金额
            if (([self.element.ZE doubleValue] - [self.element.MQYTBJE doubleValue]) < [self.element.QTJE doubleValue]) {
                if ([self.investmentDetailHeader.actualPaymentLab.text doubleValue] > [avlBalStr doubleValue]) {
                    [MBProgressHUD showError:@"您的余额不足,请充值"];
                    
                } else if ([self.investmentDetailHeader.investMoneyTextField.text doubleValue] != ([self.element.ZE doubleValue] - [self.element.MQYTBJE doubleValue])) {
                    
                    [MBProgressHUD showError:@"剩余金额小于起投金额时需一笔投完"];
                } else if (self.investmentDetailHeader.pactBtn.selected == NO) {
                    
                    [MBProgressHUD showError:@"请知悉并同意《风险告知书》、《平台服务协议》、《借款合同》"];
                } else {
                    
                    //判断投资是单选还是多选红包
                    if (self.selectedModel) {
                        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investmentDetailHeader.investMoneyTextField.text RedPact:@"0" CouponId:self.redPactID];
                    } else {
                        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investmentDetailHeader.investMoneyTextField.text RedPact:@"0" CouponId:self.moreRedPactID];
                    }
                    
                    
                }
                //借款金额 - 已投标金额 < 递增金额
            } else if (([self.element.ZE doubleValue] - [self.element.MQYTBJE doubleValue]) < [self.element.DZJE doubleValue]) {
                
                if ([self.investmentDetailHeader.actualPaymentLab.text doubleValue] > [avlBalStr doubleValue]) { //实际支付金额>余额
                    [MBProgressHUD showError:@"您的余额不足,请充值"];
                    
                } else if ([self.investmentDetailHeader.investMoneyTextField.text doubleValue] != ([self.element.ZE doubleValue] - [self.element.MQYTBJE doubleValue]))   // 输入金额 ！= 借款金额-已投标的金额
                {
                    [MBProgressHUD showError:@"剩余金额小于递增金额时需一笔投完"];
                } else if (self.investmentDetailHeader.pactBtn.selected == NO) {
                    
                    [MBProgressHUD showError:@"请知悉并同意《风险告知书》、《平台服务协议》、《借款合同》"];
                } else {
                    // 账号id  标id 投资金额
                    
                    //判断投资是单选还是多选红包
                    if (self.selectedModel) {
                        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investmentDetailHeader.investMoneyTextField.text RedPact:@"0" CouponId:self.redPactID];
                    } else {
                        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investmentDetailHeader.investMoneyTextField.text RedPact:@"0" CouponId:self.moreRedPactID];
                    }
                    
                }
            } else {
                if ([self.investmentDetailHeader.actualPaymentLab.text doubleValue] > [avlBalStr doubleValue]) {
                    [MBProgressHUD showError:@"您的余额不足,请充值"];
                }else if ([self.investmentDetailHeader.investMoneyTextField.text doubleValue] > ([self.element.ZE doubleValue] - [self.element.MQYTBJE doubleValue])) {
                    [MBProgressHUD showError:@"投资金额不可大于项目可投金额"];
                }else if ([self.investmentDetailHeader.investMoneyTextField.text doubleValue] < [self.element.QTJE doubleValue]) {
                    [MBProgressHUD showError:@"投资金额不可小于起投金额"];
                }
                //                else if (([self.investmentDetailHeader.investMoneyTextField.text intValue] - [self.element.QTJE intValue]) % [self.element.DZJE intValue])
                else if ((numLAB - numQTJE) % numDZJE) { //投资金额 - 起投金额 % 递增金额
                    
                    [MBProgressHUD showError:@"请输入符合递增规定的金额"];
                } else if (self.investmentDetailHeader.pactBtn.selected == NO) {
                    
                    [MBProgressHUD showError:@"请知悉并同意《风险告知书》、《平台服务协议》、《借款合同》"];
                } else {
                    //判断投资是单选还是多选红包
                    if (self.selectedModel) {
                        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investmentDetailHeader.investMoneyTextField.text RedPact:@"0" CouponId:self.redPactID];
                    } else {
                        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investmentDetailHeader.investMoneyTextField.text RedPact:@"0" CouponId:self.moreRedPactID];
                    }
                }
            }
            
        } else {
            [MBProgressHUD showError:@"请输入合法的投资金额"];
        }
        
    }
}

#pragma mark - 点击充值按钮
- (void)didClickRechargeBtn
{
    BXTabBarController * tabBarVC = (BXTabBarController *)self.tabBarController;
    if (tabBarVC.bussinessKind) {
        
        [self postUserBankCardInfo];
        
    }else{
        [self presentLoginVC];
    }
}

// 弹出登录页面
- (void)presentLoginVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.isPresentedWithMyAccount = 0;
    BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
    if (self.loanId) {
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

// 点击安全提示详情按钮
- (void)didClickDetailBtn
{
    BXProjectDescriptionController *VC = [[BXProjectDescriptionController alloc]init];
    VC.type = @"风险提示";
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 点击选择或者登录按钮
-(void)didClickSelectedBtn
{
    
    BXTabBarController *tabbar = (BXTabBarController *)self.tabBarController;
    if (!tabbar.bussinessKind) {
        [self presentLoginVC];
    } else {
        if (self.investmentDetailHeader.investMoneyTextField.text.length) {
            if ([NSString checkNum:self.investmentDetailHeader.investMoneyTextField.text]) {
                [self selectCouponBtnClick];
            } else {
                [MBProgressHUD showError:@"请输入合法的投资金额"];
            }
        } else {
            [self selectCouponBtnClick];
        }
    }
}

#pragma mark - UItableViewDatesoure
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.tag == 2) {
//        return 110;
//    }else{
        return 80;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if (tableView.tag == 2) {
//        return couponArray.count;
//    }else{
        return 1;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    BXCouponModel *model = couponArray[indexPath.row];
    //    //        model.YHQ_ID
    //    self.redPactID = model.YHQ_ID;
    //
    //    if ([availbleArray containsObject:model]) { // 可点
    //        if (_selectedIndex == indexPath.row) {
    //            _selectedIndex=-1;
    ////            [_couponTableView reloadData];
    //        }else{
    //
    //            _selectedIndex=indexPath.row;
    ////            [_couponTableView reloadData];
    //        }
    //    }else{ // 不可点
    //
    //    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (tableView.tag == 2) {
//        BXCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponListCell"];
//        if (!cell) {
//            cell = [[NSBundle mainBundle]loadNibNamed:@"BXCouponListCell" owner:nil options:nil][0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        BXCouponModel *model = couponArray[indexPath.row];
//        
//        [cell fillWithCouponModel:model];
//        if (![availbleArray containsObject:model]) {
//            
//            if ([model.YHQLB integerValue] == 1) { //不可用状态
//                // 红包
//                cell.typeImagV.image = [UIImage imageNamed:@"myhb_hb_sel"];
//                cell.bottomImageV.image = [UIImage imageNamed:@"yhqd3"];
//                
//            } else { // 现金红包
//                cell.typeImagV.image = [UIImage imageNamed:@"myhb_xjhb_sel"];
//                cell.bottomImageV.image = [UIImage imageNamed:@"yhqd3"];
//            }
//            if (indexPath.row==_selectedIndex) {
//                cell.selecImagV.image=[UIImage imageNamed:@"couponList_cantselected"];;
//            } else {
//                cell.selecImagV.image=[UIImage imageNamed:@"couponList_unselected"];
//            }
//        } else {
//            if (indexPath.row==_selectedIndex) {
//                cell.selecImagV.image=[UIImage imageNamed:@"couponList_selected"];;
//            } else {
//                cell.selecImagV.image=[UIImage imageNamed:@"couponList_unselected"];
//            }
//        }
//        return cell;
//        
//    } else {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
//    }
}

-(void)myAlertView:(MYAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index
{
    if (index!=1) {
        [self presentLoginVC];
    }
}

#pragma mark - POST
/** POST项目详情  */
- (void)postLoanDetailWithLoanId:(NSString *)loanId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"loanId":loanId};
    info.serviceString = BXRequestLoanDetail;
    
    BXTabBarController * tabBarVC = (BXTabBarController *)self.tabBarController;
    if (!tabBarVC.bussinessKind) {//未登录
        
        [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
            
            [MBProgressHUD hideHUD];
            //            [self.tableView.header endRefreshing];
            if ([dict[@"body"][@"resultcode"] integerValue] == 0){
                BXInvestmentDetailModel *model  = [BXInvestmentDetailModel mj_objectWithKeyValues:dict[@"body"][@"loan"]];
                [self.investmentDetailHeader fillInWithInvestmentDetailHeader:model];
                self.dict = dict;
                self.element = model;
                [self refreshAccountBalanceLabState];
                [self refreshRedPactStateWithModel:model];
                [self refreshButtonStateWithInvestmentDetailModel:self.element];
                
                //-----添加倒计时-----
                [self addCountText];
            }
            
        } faild:^(NSError *error) {
            [MBProgressHUD hideHUD];
            //            [self.tableView.header endRefreshing];
            
        }];
    } else {//已登录   新增两字段 QTQX 起投上限； SFDJSY 是否可叠加 0 不能，1可以；
        [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
            
            //            [self.tableView.header endRefreshing];
            [MBProgressHUD hideHUD];
            if ([dict[@"body"][@"resultcode"] integerValue] == 0){
                BXInvestmentDetailModel *model  = [BXInvestmentDetailModel mj_objectWithKeyValues:dict[@"body"][@"loan"]];
                couponArray = [BXCouponModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"couponList"]];
                availbleArray = [NSArray arrayWithArray:couponArray];
                
                //此处添加红包数据
                for (BXCouponModel *model in couponArray) {
                    model.DDJZRQ = [NSDate formmatDateStr:model.JZRQ];
                }
                //此处添加红包数据
                for (int i =0; i<couponArray.count; i++) {
                    BXCouponModel *hbModel;;
                    hbModel = couponArray[i];
                    if ([hbModel.SFDJSY isEqualToString:@"0"]) {
                        
                        [self.singleCouponArr addObject:hbModel];
                    } else if ([hbModel.SFDJSY isEqualToString:@"1"]) {
                        
                        [self.moreCouponArr addObject:hbModel];
                    }
                    
                }
                [self refreshAvailableArray];
                
                //                [_couponTableView reloadData];
                
                [self.investmentDetailHeader fillInWithInvestmentDetailHeader:model];
                self.dict = dict;
                self.element = model;
                [self refreshAccountBalanceLabState];
                [self refreshRedPactStateWithModel:model];
                [self refreshButtonStateWithInvestmentDetailModel:self.element];
                
                //-----添加倒计时-----
                [self addCountText];
            }
        } faild:^(NSError *error) {
            
            [MBProgressHUD hideHUD];
            //            [self.tableView.header endRefreshing];
        }];
    }
}

/** 获取用户开户信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
        // 加载指定的页面去
        if (![dict[@"body"][@"resultcode"] intValue]) {
            if ([dict[@"body"][@"currUser"][@"HFZH"] isEqualToString:@""]) {
                MYPopupView *popupView = [[MYPopupView alloc]initWithTitle:@"开通银行存管账户，才能投资哦" CancelButton:@"取消" OkButton:@"立即开通" ImageName:@"kaitonghuifu"];
                popupView.delegate = self;
                [self.view addSubview:popupView];
                
            } else {
                
                if (dict[@"body"][@"bankcardBind"][@"YHKH"]) {
                    BXHFRechargeController *HFRecharge = [storyboard instantiateViewControllerWithIdentifier:@"BXHFRechargeVC"];
                    [self.navigationController pushViewController:HFRecharge animated:YES];
                    
                } else {
                    [self bindCard];
                }
            }
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

- (void)bindCard
{
    WS(weakSelf);
    [AppUtils alertWithVC:self title:nil messageStr:@"您还未绑定银行卡，是否绑定？" enSureStr:@"去绑卡" cancelStr:@"取消" enSureBlock:^{
        // 充值逻辑 没绑卡绑卡
        [weakSelf postBlindCard];
    } cancelBlock:^{
    }];
}

- (void)showAlertWithStr:(NSString *)str
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)makeBindCardSuccess:(BOOL)isSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
    if (isSuccess) {
        [self showAlertWithStr:@"绑卡成功!"];
    } else {
        [self showAlertWithStr:@"绑卡失败，请稍后再试！"];
    }
}

- (void)investSuccess:(BOOL)isSuccess message:(NSString *)message Serial_number:(NSString *)serial_number
{
    if (isSuccess) {
        
        // 发送投资成功统计
        [[SinvoClick standardSinvoClick] sendStatisticsWithczlx:@"40" lxid:serial_number];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //            NSString *balance = [defaults objectForKey:@"AvlBal"];
        NSString *balance = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
        int cashMoney =  ([balance doubleValue] - [self.investmentDetailHeader.investMoneyTextField.text doubleValue]);
        NSString *string = [NSString stringWithFormat:@"%d",cashMoney];
        [defaults setObject:string forKey:@"AvlBal"];
        
        NSDictionary *dict = @{@"investSuccess" : @"YES"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"investClickSuccess" object:nil userInfo:dict];
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BXInvestSuccessController" bundle:nil];
        BXInvestSuccessController *successVC = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:successVC animated:YES];
        
    } else {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BXInvestFailureController" bundle:nil];
        BXInvestFailureController *failureVC = [sb instantiateInitialViewController];
        failureVC.respDesc = message;
        [self.navigationController pushViewController:failureVC animated:YES];
        
    }
}

// 汇付操作完成后的回调
-(void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    if (self.styleBan == DDSetStylebindCard) {
      
        [self makeBindCardSuccess:isSuccess];
        return;
    } else if (self.styleBan == DDSetStyleOther) {
        [self investSuccess:isSuccess message:message Serial_number:serial_number];
    }
}

/** POST获取可用余额 **/
- (void)postAccountInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestAccountInfo;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            BXAccountAssetsVC *accountUser = [BXAccountAssetsVC  mj_objectWithKeyValues:dict[@"body"]];
            if ([accountUser.cash doubleValue] > 0) {
                NSString *accountStr = [NSString stringWithFormat:@"%@元",accountUser.cash];
                
                self.investmentDetailHeader.accountBalanceLab.text = accountStr;
            } else {
                self.investmentDetailHeader.accountBalanceLab.text = @"0.00元";
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:accountUser.cash forKey:@"AvlBal"];
        } 

    } faild:^(NSError *error) {

    }];
}

/**
 * post投资
 **/
- (void)postStartInitiativeTenderWithLoanId:(NSString *)loanId TransAmt:(NSString *)transAmt RedPact:(NSString *)redPact CouponId:(NSString *)couponId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
//    info.serviceString = DDRequestInitiativeTender;
    info.serviceString = DDRequestlmInitiativeTender;
    
    if ([self.element.SFSYYHQ isEqual:@"Y"] && (self.selectedModel || (moreHbArray && moreHbArray.count != 0))) {
        info.dataParam = @{@"loanId":loanId, @"transAmt":transAmt, @"redPact":redPact, @"couponId":couponId, @"client":@"ios", @"from":@"M"};
    } else {
        info.dataParam = @{@"loanId":loanId, @"transAmt":transAmt, @"redPact":redPact, @"client":@"ios", @"from":@"M"};
    }
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [MBProgressHUD hideHUD];
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"立即投资";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            JumpThirdParty.payType = MPPayTypeHKBank;
            self.styleBan = DDSetStyleOther;
            [self.navigationController pushViewController:JumpThirdParty animated:YES];
            
        } else {
            
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

/** 绑定银行卡 */
- (void)postBlindCard
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestlmBindPersonCard;
    info.dataParam = @{@"from":@"M"};
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            //
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"绑定银行卡";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            self.styleBan = DDSetStylebindCard;
            [self.navigationController pushViewController:JumpThirdParty animated:YES];
            
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

//字符串转字典
- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (void)MYPopupView:(MYPopupView *)PopupView didClickButtonAtIndex:(NSUInteger)index
{
    if (index != 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if ([[defaults objectForKey:@"khfs"] isEqual:@"2"]) {
            WS(weakSelf);
            [AppUtils alertWithVC:self title:@"提示" messageStr:@"企业用户请前往官网进行开户" enSureBlock:^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {

            BXOpenLDAccountController *openLDAccountVC = [[BXOpenLDAccountController alloc]init];
            [self.navigationController pushViewController:openLDAccountVC animated:YES];
        }
    } else {
        
    }
}

// 输入金额，利率，期限数，期限的单位,还款方式计算预期收益
-(NSString *)CalculationExpected:(NSString*)beginMoney Yield:(NSString*)Yield time:(int)time type:(int)type productId:(int)productId
{
    //期数
    int Deadline = time;
    //金额
    double Amount = [beginMoney doubleValue];
    //收益率
    double Rate = [Yield doubleValue] ;
    NSString*earnings;
    if(productId){
        switch(productId){
            case 3:
                Rate = Rate / 1200;
                double monthIn =(Amount  * Rate * pow((1 + Rate), Deadline))/ (pow((1 + Rate), Deadline) - 1);
                monthIn=[[NSString stringWithFormat:@"%.2lf",monthIn] doubleValue];
                earnings = [NSString stringWithFormat:@"%.2lf",(monthIn * Deadline - Amount)];// 支付总利息
                break;
            default:
                if(type==1){
                    earnings=[NSString stringWithFormat:@"%.2lf",(Amount*Rate*Deadline/36000)];
                } else {
                    monthIn=[[NSString stringWithFormat:@"%.2lf",Amount*Rate/100/12] doubleValue];;
                    earnings=[NSString stringWithFormat:@"%.2lf",(monthIn*Deadline)];
                }
        }
    }
    return earnings;
}

-(NSMutableArray *)moreCouponArr
{
    if (!_moreCouponArr) {
        _moreCouponArr = [NSMutableArray array];
    }
    return _moreCouponArr;
}
- (NSMutableArray *)singleCouponArr
{
    if (!_singleCouponArr) {
        _singleCouponArr = [NSMutableArray array];
    }
    return _singleCouponArr;
}





@end
