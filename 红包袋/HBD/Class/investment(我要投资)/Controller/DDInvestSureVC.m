//
//  DDInvestSureVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestSureVC.h"
//#import "DDChooseRedbaoController.h"
#import "DDChooseCouponVC.h"
#import "DDWebViewVC.h"
#import "BXInvestmentDetailModel.h"
#import "BXCouponModel.h"
#import "BXJumpThirdPartyController.h"
#import "BXAccountAssetsVC.h"
#import <YYText/YYText.h>
#import <YYText/YYLabel.h>
#import "DDWebViewVC.h"
#import "NSString+Other.h"
#import "NSDate+Setting.h"
#import "BXHFRechargeController.h"
#import "BXInvestSuccessController.h"
#import "BXInvestFailureController.h"
#import "HXTextAndButModel.h"
#import "DDRiskAssessViewController.h"
#import "HXRiskAssessModel.h"
#import "ShadowView.h"
#import "InvestHeaderView.h"

typedef NS_ENUM(NSUInteger, DDSetStyle) {
    DDSetStylebindCard,             // 绑定银行卡
    DDSetStyleOther,            //
};

@interface DDInvestSureVC () <DDChooseCouponDelegate, PayThirdPartyProtocol, UITextFieldDelegate>
{
    double payMoney;  // 输入框金额-使用红包金额
}

@property (nonatomic, strong) InvestHeaderView *investHeaderView;

@property (nonatomic, strong) UIView *headerview;

// 出借金额输入
@property (weak, nonatomic) IBOutlet UITextField *investTxf;
// 同意合同
@property (weak, nonatomic) IBOutlet MPCheckboxButton *pactBtn;
// 充值
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
// 箭头
@property (weak, nonatomic) IBOutlet UIImageView *redArrowImg;

// 选择红包
@property (weak, nonatomic) IBOutlet UILabel *redpacketLab;
// 选择红包
@property (weak, nonatomic) IBOutlet UIButton *redpacketBtn;
// 支付金额和收益
@property (weak, nonatomic) IBOutlet UILabel *payinLab;
// 确认出借
@property (weak, nonatomic) IBOutlet UIButton *sureInvestBtn;
// 充值cell的contentview
@property (weak, nonatomic) IBOutlet UIView *czContentView;

// 红包ID
@property (nonatomic, copy) NSString *redPactID;
// 多选红包ID
@property (nonatomic, copy) NSString *moreRedPactID;
// 单选红包
@property (nonatomic, strong) NSMutableArray *singleCouponArr;
// 多选红包
@property (nonatomic, strong) NSMutableArray *moreCouponArr;
// 当前选择的红包model
@property (nonatomic, strong) BXCouponModel  *selectedModel;
@property (nonatomic, strong) BXCouponModel  *selectedMoreModel;
@property (nonatomic, strong) BXInvestmentDetailModel *element;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign) DDSetStyle styleBan;

@end

@implementation DDInvestSureVC
{
    // 弹出的底视图
//    UIView *_bottomView;
//    UIView *_bottomgraryView;
    // 弹出的红包按钮
//    UITableView *_couponTableView;
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
//    CGFloat min_value;
    NSDictionary  *userCardInfo;     // 用户绑卡信息
    BOOL isBankCard;                 // 是否绑定了银行卡
    //记录秒数
    NSString *secondNum;
    NSString *useAmount_; //可以余额
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"出借确认";
    self.investTxf.delegate = self;
    [self ininUIViews];

    if (self.loanId) {
        [self postLoanDetailWithLoanId:self.loanId];
    } else {
        [MBProgressHUD showError:@"网络异常"];
    }
    
    [self initsUIViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self postUserBankCardInfo];
}

- (void)ininUIViews {
    self.investHeaderView = [InvestHeaderView investHeaderView];
    
    CGRect newFrame = CGRectMake(0, 0, SCREEN_WIDTH, 167);
    self.headerview = [[UIView alloc] initWithFrame:newFrame];
    self.investHeaderView.frame = self.headerview.frame;
    [self.headerview addSubview:self.investHeaderView];

    self.tableView.tableHeaderView = self.headerview;
}

- (void)initsUIViews {
    //添加合同lab
    [self setTouchPactLabel];
    [self.sureInvestBtn addTarget:self action:@selector(sureInvestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.redpacketBtn addTarget:self action:@selector(redpacketBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //输入框通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investTxfDidChangeNotification) name:UITextFieldTextDidChangeNotification object:self.investTxf];
}

#pragma -mark  充值
- (void)rechargeBtnClick {
    
    // 是否有数据
    if (userCardInfo[@"body"][@"currUser"] == nil) {
        [MBProgressHUD showError:userCardInfo[@"body"][@"resultinfo"]];
        return;
    }
    //不开户不会进此页面  // 绑卡
    if (isBankCard == NO) {
        WS(weakSelf);
        [AppUtils alertWithVC:self title:nil messageStr:@"您还未绑定银行卡，是否绑定？" enSureStr:@"去绑卡" cancelStr:@"取消" enSureBlock:^{
            [weakSelf postBlindCard];
        } cancelBlock:^{}];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    BXHFRechargeController *HFRecharge = [storyboard instantiateViewControllerWithIdentifier:@"BXHFRechargeVC"];
    [self.navigationController pushViewController:HFRecharge animated:YES];
}

/** 输入框通知 */
- (void)investTxfDidChangeNotification{
    [self refreshHongbaoAvaiable]; //刷新现金券状态
    [self refreshAvailableArray]; //根据金额变化，实时筛选可用红包
    [self refreshPaymentAndProfit]; //刷新实时金额
}

#pragma mark - 点击红包
- (void)redpacketBtnClick {
    if (![self isCanClickredpacketBtn]) return;
    DDChooseCouponVC *chVc = [[DDChooseCouponVC alloc] init];
    chVc.delegate = self;
    chVc.singleCouponArr = self.singleCouponArr;
    chVc.availbleHbArr = availbleArray;
    chVc.investMoney = self.investTxf.text;
    chVc.singleIndex = _selectedIndex;
    chVc.singleModel = _selectedModel;
    chVc.dikouNum = moreHbMoney;
    [self.navigationController pushViewController:chVc animated:YES];

//    if ([self isCanClickredpacketBtn]) {
//
//        DDChooseCouponVC *chVc = [[DDChooseCouponVC alloc] init];
//        chVc.delegate = self;
//        chVc.singleCouponArr = self.singleCouponArr;
//        chVc.availbleHbArr = availbleArray;
//        chVc.investMoney = self.investTxf.text;
//        chVc.singleIndex = _selectedIndex;
//        chVc.singleModel = _selectedModel;
//        chVc.dikouNum = moreHbMoney;
//        [self.navigationController pushViewController:chVc animated:YES];
//    }
}

- (BOOL)isCanClickredpacketBtn {
    
    if (self.investTxf.text.length == 0) {
        [MBProgressHUD showError:@"请输入出借金额"];
        return NO;
    } else if ([self.investTxf.text doubleValue] < [_element.QTJE  doubleValue]) {
        [MBProgressHUD showError:@"出借金额不能小于起投金额"];
        return NO;
    } else if ([self isIntegerStr:_element.DZJE with:self.investTxf.text] == NO) {
        [MBProgressHUD showError:@"出借金额必须为递增金额整数倍"];
        return NO;
    } else if (![NSString checkNum:self.investTxf.text]) {// 金额格式不合法(比如包含字母、符号、汉字等)
        [MBProgressHUD showError:@"请输入正确的出借金额"];
        return NO;
    }
    return YES;
}

// 判断是否是整数
- (BOOL)isIntegerStr:(NSString *)str1 with:(NSString *)str2 {
    
    int a=[str1 intValue];
    double s1=[str2 doubleValue];
    int s2=[str2 intValue];

    if (s1/a-s2/a>0) {
        return NO;
    }
    return YES;
}

// 将状态置于未选中
- (void)unselectedState
{
    if ([self.element.SFSYYHQ isEqual:@"Y"]) {
        if (couponArray.count) {
            self.redpacketLab.text = @"有可用";
        }else{
            self.redpacketLab.text = @"无可用奖券";
            self.redpacketBtn.hidden = YES;
            self.redArrowImg.hidden = YES;
        }
    }
    self.selectedModel = nil;
    self.selectedMoreModel = nil;
    
    [self refreshPaymentAndProfit];
    _selectedIndex = -1;
}

#pragma mark - DDChooseCouponDeleagate
- (void)chooseCouponSureSingleHb:(BXCouponModel *)singleHb AndHbID:(NSInteger)hbID {
    
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
        if (!self.investTxf.text.length) {
            
            if ([model.SYTJ isEqualToString:@"0.00"]) {//现金红包起投金额
                
                self.investTxf.text = self.element.QTJE;
            } else {
                self.investTxf.text = [NSString stringWithFormat:@"%.0f",[model.SYTJ doubleValue]];
            }

        } else {
            
            if ([model.SYTJ doubleValue] >[self.investTxf.text doubleValue]) {
                self.investTxf.text = [NSString stringWithFormat:@"%.0f",[model.SYTJ doubleValue]];
            }
        }
        [self refreshAvailableArray];
        [self refreshHongbaoAvaiable];
    }
    [self refreshPaymentAndProfit];
}

#pragma mark - 根据输入金额匹配红包
- (void)refreshHongbaoAvaiable
{
    if ([self.investTxf.text doubleValue] < [self.selectedModel.SYTJ doubleValue]) { //
        
        self.redpacketBtn.hidden = NO;
        self.redpacketLab.text = @"有可用";
        self.redArrowImg.hidden = NO;
        self.selectedModel = nil;
        _selectedIndex = -1;
        [self refreshAvailableArray];
        
    } else if (self.selectedModel) { //选中单选红包
        if ([self.element.SFSYYHQ isEqual:@"Y"]) {
            self.redpacketBtn.hidden = NO;
            if ([self.selectedModel.YHQLB integerValue] == 1) { // 红包
                if (self.selectedModel) {
                    self.redpacketLab.text = [NSString stringWithFormat:@"已选择1个返现券，返现金额%.2f元",self.selectedModel.MZ];
                } else {
                    self.redpacketLab.text = [NSString stringWithFormat:@"无可用奖券"];
                    self.redpacketBtn.hidden = YES;
                    self.redArrowImg.hidden = YES;
                }
            }
            
        } else {
            self.redpacketLab.text = @"不可使用奖券";
            self.redpacketBtn.hidden = YES;
            self.redArrowImg.hidden = YES;
            self.selectedModel = nil;
            self.selectedMoreModel = nil;
        }
    }
}

// 实时刷新多选红包
- (void)refreshMoreHbAvaiable
{
    if(moreHbArray && moreHbArray.count != 0){
        self.redpacketBtn.hidden = NO;
        self.redpacketLab.text = [NSString stringWithFormat:@"已选择%ld个返现券，返现金额%g元", moreHbArray.count ,moreHbMoney];
    } else {
        self.redpacketLab.text = @"不可使用奖券";
        self.redpacketBtn.hidden = YES;
        self.redArrowImg.hidden = YES;
    }
}


#pragma mark -根据金额变化，实时筛选可用红包
- (void)refreshAvailableArray
{
    NSString *inputText = self.investTxf.text;
    
    if (couponArray.count) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (BXCouponModel *model in couponArray) {
            
            if (inputText.length) {
                
                [self AutoRedPacketHKZQDW:model And:tempArray];
            } else {
                
                if (self.element.HKZQDW) {
                    if ([self.element.HKZQDW isEqualToString: @"3"]) {
                        //月
                        // 使用期限无限制0，或者 起投期限<= 出借期限
                        if ([model.QTQX isEqualToString:@"0"] || ([model.QTQX doubleValue] <= [_element.HKZQSL doubleValue])) {
                            
                            [tempArray addObject:model];
                            
                        } else {
                            availbleArray = nil;
                        }
                        
                    } else if ([self.element.HKZQDW isEqualToString: @"1"]){
                        
                        // 天*30比较 // 使用期限无限制0，或者 起投期限<= 出借期限
                        if ([model.QTQX isEqualToString:@"0"]
                            || ([model.QTQX doubleValue] * 30 <= [_element.HKZQSL doubleValue])) {
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
}

//借款单位来处理红包匹配
- (void)AutoRedPacketHKZQDW:(BXCouponModel *)model And:(NSMutableArray *)mutableArr
{
    
    NSString *inputText = self.investTxf.text;
    
    if (self.element.HKZQDW) {
        if ([self.element.HKZQDW isEqualToString: @"3"]) {
            //月
            // 使用期限无限制0，或者 起投期限<= 出借期限
            if ([model.QTQX isEqualToString:@"0"] || ([model.QTQX doubleValue] <= [_element.HKZQSL doubleValue])) {
                
                if ([inputText doubleValue] >= [model.SYTJ doubleValue]) { //可用红包
                    model.QTQXINT = [model.QTQX integerValue];
                    [mutableArr addObject:model];
                }
            }
            
        } else if ([self.element.HKZQDW isEqualToString: @"1"]){
            
            // 天*30比较 // 使用期限无限制0，或者 起投期限<= 出借期限
            if ([model.QTQX isEqualToString:@"0"] || ([model.QTQX doubleValue] * 30 <= [_element.HKZQSL doubleValue])) {
                
                if ([inputText doubleValue] >= [model.SYTJ doubleValue]) { //可用红包
                    
                    if ([inputText doubleValue] >= [model.SYTJ doubleValue]) { //可用红包
                        model.QTQXINT = [model.QTQX integerValue];
                        [mutableArr addObject:model];
                    }
                }
                
            }
        }
    }
}

#pragma  mark - 本次支付和预计收益
- (void)refreshPaymentAndProfit
{
    //逾期利息
    NSString *expectProfit = [self CalculationExpected:_investTxf.text Yield:_element.NHLL time:[_element.HKZQSL intValue] type:[_element.HKZQDW intValue] productId:[_element.HKFS intValue]];
    
    if (self.selectedModel || (moreHbArray && moreHbArray.count != 0)) { //有红包可用
        if (self.investTxf.text.length) {
            // 不可用红包或者无可用红包或者未登录或者是加息券
            if (![self.element.SFSYYHQ isEqual:@"Y"] || couponArray.count == 0 || [self.selectedModel.YHQLB integerValue] == 2) {
                
                self.payinLab.text =[NSString stringWithFormat:@"本次支付：%.2lf元，预计获得收益：%.2lf元",[_investTxf.text doubleValue], [expectProfit doubleValue]];
            } else { //使用红包
                if (self.selectedModel) {
                    
                    double amount = [self.investTxf.text doubleValue] - self.selectedModel.MZ; //返现券不减
                    self.payinLab.text =[NSString stringWithFormat:@"本次支付：%.2lf元，预计获得收益：%.2lf元", [_investTxf.text doubleValue], [expectProfit doubleValue]];
                    
                } else {
                    self.payinLab.text =[NSString stringWithFormat:@"本次支付：%.2lf元，预计获得收益：%.2lf元",[_investTxf.text doubleValue], [expectProfit doubleValue]];
                }
            }
        } else {
            self.payinLab.text = @"本次支付：0.00元，预计获得收益：0.00元";
        }
    } else {  // 没有红包可用
        if (self.investTxf.text.length) {
            self.payinLab.text =[NSString stringWithFormat:@"本次支付：%.2lf元，预计获得收益：%.2lf元",[_investTxf.text doubleValue], [expectProfit doubleValue]];
        } else {
            self.payinLab.text = @"本次支付：0.00元，预计获得收益：0.00元";
        }
    }
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

// 循环监测是否有现金券（匹配优先级，先现金券，后加息券）
- (BOOL)existCashCoupon
{
    NSString *inputText = self.investTxf.text;
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



// 输入金额，利率，期限数，期限的单位,还款方式计算逾期利息
- (NSString *)CalculationExpected:(NSString*)beginMoney Yield:(NSString*)Yield time:(int)time type:(int)type productId:(int)productId
{
    double Amount = [beginMoney doubleValue];//金额
    int Deadline = time;//期数
    double Rate = [Yield doubleValue];//约定年化利率 年化收益
    
    NSString*earnings;
    
    if(productId){//还款方式
        switch(productId){ //还款方式：1:按月付息到期还本 2：到期还本付息 3：等额回款
            case 3:
                Rate = Rate / 1200;
                double monthIn = (Amount  * Rate * pow((1 + Rate), Deadline))/ (pow((1 + Rate), Deadline) - 1);
//                monthIn = [[NSString stringWithFormat:@"%.2lf",monthIn] doubleValue];
                earnings = [NSString stringWithFormat:@"%.2lf",(monthIn * Deadline - Amount)];// 支付总利息
                break;
            default:
                if(type == 1){   //借款周期单位：1：天 2：周 3：月  4：年
                    earnings = [NSString stringWithFormat:@"%.2lf",(Amount*Rate*Deadline/36500)]; //365天
                } else {
                    monthIn = [[NSString stringWithFormat:@"%.2lf",Amount*Rate/100/12] doubleValue];
                    earnings = [NSString stringWithFormat:@"%.2lf",(monthIn*Deadline)];
                }
        }
    }
    return earnings;
}


#pragma mark - 刷新选择红包Lab状态
- (void)refreshAccountBalanceLabState
{
    [self postAccountInfo]; //可用余额
    
    // 输入框placeholder
    if (_element.QTJE) {
        self.investTxf.placeholder = [NSString stringWithFormat:@"起投金额%.2f元,递增金额%.2f元", [_element.QTJE floatValue], [_element.DZJE floatValue]];
    } else {
        self.investTxf.placeholder = @"起投金额0.00元,递增金额0.00元";
    }

    if (_element.TXY.length > 0) { // 加息 //预期年化收益
        NSString *str = [NSString stringWithFormat:@"%g+%g",[_element.TXZ doubleValue] ,[_element.TXY doubleValue]];
        self.investHeaderView.increasesInInterestRates.hidden = NO;
        self.investHeaderView.percentLab.text = str;

    } else { // 不加息 //预期年化收益
        self.investHeaderView.increasesInInterestRates.hidden = YES;
        if (_element.NHLL) { // 年化收益

            NSString *str = [NSString stringWithFormat:@"%g",[_element.NHLL doubleValue]];
            self.investHeaderView.percentLab.text = str;

        } else { // 既不加息 也无年化收益的情况
            self.investHeaderView.percentLab.text = @"--";
        }
    }
    
    // 剩余可投金额
    if (_element.ZE) {
        self.investHeaderView.loanAmountLab.text =  [NSString stringWithFormat:@"%.2lf",([_element.ZE doubleValue] - [_element.MQYTBJE doubleValue])];
    }else{
        self.investHeaderView.loanAmountLab.text = @"--";
    }

    if (_element.JKBT) {
        self.investHeaderView.titleLab.text = _element.JKBT;
    } else {
        self.investHeaderView.titleLab.text = @"--";
    }
    
    // 将输入框数值和选中红包置空
    self.investTxf.text = @"";
    
    self.selectedModel = nil;
    _selectedIndex = -1;
    
    if ([self.element.SFSYYHQ isEqual:@"Y"]) {
        
        if (couponArray.count) {
            self.redpacketBtn.hidden = NO;
            self.redpacketLab.text = @"有可用";
            
        }else{
            self.redpacketLab.text = @"无可用奖券";
            self.redpacketBtn.hidden = YES;
            self.redArrowImg.hidden = YES;
        }
    } else {
        self.redpacketLab.text = @"不可使用奖券";
        self.redpacketBtn.hidden = YES;  
        self.redArrowImg.hidden = YES;
    }
    
}
/** =======风险评估条件
 XMPJ(项目评级[1~5])
 XMPJ_NAME(对应出借人的类型[如稳健型、保守型]等)
 "XMPJ" : 5,
 "XMPJ_NAME" : "保守型",
 
 保守型   5
 稳健型   5 4
 平衡型   5 4
 进取型   5 4 3
 激进型   5 4 3
 
 */
- (BOOL)judgeRiskCondition {
    
    NSString *pjNameStr = self.dict[@"body"][@"loan"][@"XMPJ_NAME"];
    NSString *pjStr = self.dict[@"body"][@"loan"][@"XMPJ"];//  项目等级 5 4 3
    
    NSInteger klevNum;
    if ([self.levelName isEqualToString:@"保守型"]) {//客户评级
        klevNum = 1;
    } else if ([self.levelName isEqualToString:@"稳健型"]) {
        klevNum = 2;
    } else if ([self.levelName isEqualToString:@"平衡型"]) {
        klevNum = 3;
    } else if ([self.levelName isEqualToString:@"进取型"]) {
        klevNum = 4;
    } else { // 激进型
        klevNum = 5;
    }
    
    //用户类型
    if ([pjStr integerValue] == 4) {
        if (klevNum == 1) {
            WS(weakSelf);
            NSString *lxstr = [NSString stringWithFormat:@"风险承受能力“%@”及以上的出借人可出借此项目。", pjNameStr];
            [AppUtils alertWithVC:self title:@"" messageStr:lxstr enSureStr:@"重新评估" cancelStr:@"确定" enSureBlock:^{
                
                //跳转到风险评估
                DDRiskAssessViewController *assesVC = [[HXRiskAssessModel shareRiskModel] creaAssessVC];
                [self.navigationController pushViewController:assesVC animated:YES];
                
            } cancelBlock:^{
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            return NO;
        } else {
            return YES;
        }
    } else if ([pjStr integerValue] == 3) {
        if (klevNum == 4 || klevNum == 5) {
            return YES;
        } else {
            WS(weakSelf);
            NSString *lxstr = [NSString stringWithFormat:@"风险承受能力“%@”及以上的出借人可出借此项目。", pjNameStr];
            [AppUtils alertWithVC:self title:@"" messageStr:lxstr enSureStr:@"重新评估" cancelStr:@"确定" enSureBlock:^{
                
                //跳转到风险评估
                DDRiskAssessViewController *assesVC = [[HXRiskAssessModel shareRiskModel] creaAssessVC];
                [self.navigationController pushViewController:assesVC animated:YES];
                
            } cancelBlock:^{
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            return NO;
        }
        
    } else { // =5
        return YES;
    }
}

#pragma mark - 点击确认出借
- (void)sureInvestBtnClick
{
    if (![self judgeRiskCondition]) { // 风险评估
        return;
    }
    
    if (self.investTxf.text.length == 0) {
        [MBProgressHUD showError:@"请输入出借金额"];
        return;
    }

    if (![NSString checkNum:self.investTxf.text]) { //输入的是整数或小数
         [MBProgressHUD showError:@"请输入合法的出借金额"];
        return;
    }

    if ([self payAmout] == NO) return;  // 实际支付金额 < 可用余额

    if ([self leijiNewPersonAndNomal] == NO) return; // 新手标：单人单笔限额不能大于最大出借金额 普通标：累计最大限制

    [self diffrentStateInvestAction];
}

- (BOOL)payAmout
{
    // 实际支付金额 > 可以余额
    double payAmount;
    if (self.selectedModel) {

        payAmount = [self.investTxf.text doubleValue] - self.selectedModel.MZ;
    } else {
        payAmount = [self.investTxf.text doubleValue];
    }
    payMoney = payAmount;
    if (payAmount > [useAmount_ doubleValue]) {
        [MBProgressHUD showError:@"您的余额不足,请充值"];
        return NO;
    }
    return YES;
}

- (BOOL)leijiNewPersonAndNomal
{
    CGFloat money =  [self.element.ZDTZJE doubleValue];
    if ([self.element.SFTYB isEqualToString:@"3"]) {  // 新手标
        if (payMoney > money) {
            NSString *str = [NSString stringWithFormat:@"单人单笔限额不能大于最大出借金额%.2f元",money];
            [MBProgressHUD showError:str];
            return NO;
        }
    } else if ([self.element.SFTYB isEqualToString:@"1"]){ // 普通标
        if ((payMoney + [self.element.haveinvestAmount doubleValue]) > [self.element.ZDTZJE doubleValue]) {
            NSString *str = [NSString stringWithFormat:@"累计出借金额不能大于%.2f元",money];
            [MBProgressHUD showError:str];
            return NO;
        }
    }
    return YES;
}

- (void)diffrentStateInvestAction
{
    //借款金额 - 已投标金额 < 起投金额
    if (([_element.ZE doubleValue] - [_element.MQYTBJE doubleValue]) < [_element.QTJE doubleValue]) {

        if ([self.investTxf.text doubleValue] != ([_element.ZE doubleValue] - [_element.MQYTBJE doubleValue])) {
            [MBProgressHUD showError:@"剩余金额小于起投金额时需一笔投完"];
            return;
        }
        //借款金额 - 已投标金额 < 递增金额
    } else if (([_element.ZE doubleValue] - [_element.MQYTBJE doubleValue]) < [_element.DZJE doubleValue]) {

        if ([self.investTxf.text doubleValue] != ([_element.ZE doubleValue] - [_element.MQYTBJE doubleValue]))   // 输入金额 ！= 借款金额-已投标的金额
        {
            [MBProgressHUD showError:@"剩余金额小于递增金额时需一笔投完"];
            return;
        }

    } else {

        if ([self.investTxf.text doubleValue] > ([_element.ZE doubleValue] - [_element.MQYTBJE doubleValue])) {
            [MBProgressHUD showError:@"出借金额不可大于项目可投金额"];
            return;

        }
        if ([self.investTxf.text doubleValue] < [_element.QTJE doubleValue]) {
            [MBProgressHUD showError:@"出借金额不能小于起投金额"];
            return;

        }
        if (([self.investTxf.text intValue] - [_element.QTJE intValue]) % [_element.DZJE intValue]) { //出借金额 - 起投金额 % 递增金额
            [MBProgressHUD showError:@"出借金额必须为递增金额整数倍"];
            return;
        }
    }
    [self pingtaixieyi];
}

- (void)pingtaixieyi
{
    if (self.pactBtn.selected == NO) {
        [MBProgressHUD showError:@"请知悉并同意《风险告知书》、《借款合同》、《平台服务协议》、《网络借贷平台禁止性行为》、《网络借贷风险提示》"];
        return;
    }
    [self onlyMeAlertView];
}

// 一锤定音和唯我独尊判断逻辑
- (void)onlyMeAlertView
{

    [self oneOrMoreRedPacket]; // 后续需要加上一锤定音和为我独尊判断弹框再把这个去掉把👇的打开
    
//    if ([self.element.SFTYB isEqualToString:@"3"]) {
//        [self oneOrMoreRedPacket];
//        return;
//    }; // 新手标不享受这个服务
//    double all = [self.element.ZE floatValue];
//    double pay = [self.element.MQYTBJE floatValue];
//    double diffPay = all - pay - payMoney;
//
//    NSString *str;
//    if (pay > 0.0) { // 已经有人出借
//        if (diffPay + payMoney <= all * 0.1) {  // 一锤定音
//            str = @"50";
//
//            NSString *newStr = [NSString stringWithFormat:@"您再出借%.2f元可获得价值%@元返现券",diffPay,str];
//
//           [APPVersonModel showAlertViewThreeWith:MoneyPartOneStep textStr:newStr left:^{
//                // 跳转到出借页面
//                [self oneOrMoreRedPacket];
//            } right:nil];
//        } else {
//            [self oneOrMoreRedPacket];
//        }
//
//    } else {  // 还没有人出借
//
//        if (all < 200000.0) {
//            [self oneOrMoreRedPacket];
//        } else { // 唯我独尊
//            if (payMoney >= all * 0.5) {  // 出借额到总额度一半以上
//
//                if (all >= 1000000.0) {
//                    // 300元
//                    str = @"1500";
//
//                } else if (all >= 500000.0) {
//                    // 750
//                    str = @"750";
//                } else if (all >= 200000.0) {
//                    // 1500
//                    str = @"300";
//                }
//
//                NSString *newStr = [NSString stringWithFormat:@"您再出借%.2f元可获得价值%@元返现券",diffPay,str];
//                [APPVersonModel showAlertViewThreeWith:MoneyPartOnlyMe textStr:newStr left:^{
//                    // 跳转到出借页面
//                    [self oneOrMoreRedPacket];
//                } right:nil];
//            } else {
//                [self oneOrMoreRedPacket];
//            }
//
//        }
//    }
}

- (void)oneOrMoreRedPacket
{
    //判断出借是单选还是多选红包
    if (self.selectedModel) {
        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investTxf.text RedPact:@"0" CouponId:self.redPactID];
    } else {
        [self postStartInitiativeTenderWithLoanId:self.loanId TransAmt:self.investTxf.text RedPact:@"0" CouponId:self.moreRedPactID];
    }
}

#pragma mark - textFieldDelegate 设置字数限制为10：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.investTxf) {
        if (textField.text.length >= 10) return NO;
    }
    
    return YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//===========================================================================

#pragma mark - 点击合同
- (void)setTouchPactLabel
{
//    self.pactBtn.selected = YES;

    CGRect rect = CGRectMake(38, 114, SCREEN_WIDTH-48, 35);
    NSInteger integer = 0;
    if ([userCardInfo[@"body"][@"signAccount"] integerValue] == 5) {
        integer = 5;
    }
    HXTextAndButModel *textModel = [[HXTextAndButModel alloc] initWithProjectTapAction:self.czContentView strImgViewFrame:rect tag:integer];
    WS(weakSelf);
    textModel.tapBlock = ^(NSString *str) {
        if ([str isEqualToString:@"《风险告知书》"]) {
            [weakSelf pushWebViewType:DDWebTypeFXGZS withStr:@"风险告知书"];
        } else if ([str isEqualToString:@"《借款合同》"]) {
            [weakSelf pushWebViewType:DDWebTypeJKHT withStr:@"借款合同"];
        } else if ([str isEqualToString:@"《平台服务协议》"]) {
            [weakSelf pushWebViewType:DDWebTypePTFWXY withStr:@"平台服务协议"];
        } else if ([str isEqualToString:@"《网络借贷平台禁止性行为》"]) {
            [weakSelf pushWebViewType:DDWebTypeWLJDFXTS withStr:@"网络借贷风险提示"];
        } else if ([str isEqualToString:@"《网络借贷风险提示》"]) {
            [weakSelf pushWebViewType:DDWebTypeWLJDJZXXW withStr:@"网络借贷禁止性行为"];
        }else if ([str isEqualToString:@"《授权书》"]){
            [weakSelf pushWebViewType:DDWebTypeDDSQS withStr:@""];
        }

    };
}

- (void)pushWebViewType:(DDWebType)typ withStr:(NSString *)str
{
    DDWebViewVC *web = [[DDWebViewVC alloc] init];
    web.webType = typ;
    web.navTitle = str;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark -tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 刷新立即出借按钮状态
- (void)refreshButtonStateWithInvestmentDetailModel:(BXInvestmentDetailModel *)model
{
    
    if ([model.schedule isEqualToString:@"1"] || ([model.schedule integerValue] == 1)) {
        
        self.sureInvestBtn.userInteractionEnabled = NO;
        [self.sureInvestBtn setBackgroundImage:[UIImage imageNamed:@"yellowBack"] forState:UIControlStateNormal];
        [self.sureInvestBtn setTitle:@"已经满标" forState:UIControlStateNormal];
        
    } else {
        
        self.sureInvestBtn.userInteractionEnabled = YES;
        //[self.sureInvestBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
        [self.sureInvestBtn setTitle:@"确认出借" forState:UIControlStateNormal];
    }
}

#pragma mark - POST
/** POST项目详情  */
- (void)postLoanDetailWithLoanId:(NSString *)loanId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"loanId":loanId};
    info.serviceString = BXRequestLoanDetail;
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [MBProgressHUD hideHUD];
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            [self.singleCouponArr removeAllObjects]; //清空数组
            [self.moreCouponArr removeAllObjects];
            
            BXInvestmentDetailModel *model  = [BXInvestmentDetailModel mj_objectWithKeyValues:dict[@"body"][@"loan"]];
            couponArray = [BXCouponModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"couponList"]];
            availbleArray = [NSArray arrayWithArray:couponArray];
            
            
            for (BXCouponModel *model in couponArray) { //转换红包日期格式
                model.DDJZRQ = [NSDate formmatDateStr:model.JZRQ];
            }
            
            for (int i =0; i<couponArray.count; i++) {//添加红包数据
                BXCouponModel *model;
                model = couponArray[i];
                
                if ([model.SFDJSY isEqualToString:@"0"]) {// 是否可叠加 0 不能，1可以
                    
                    [self.singleCouponArr addObject:model];
                    
                } else if ([model.SFDJSY isEqualToString:@"1"]) {
                    
                    [self.moreCouponArr addObject:model];
                }
                
            }
            
            self.dict = dict;
            self.element = model;
            
            [self refreshAvailableArray]; //实时筛选可用红包
            [self refreshAccountBalanceLabState]; //刷新红包描述文字alb
            [self refreshButtonStateWithInvestmentDetailModel:self.element]; //刷新出借按钮
            [self refreshPageNewMarkTip];
            [self addCountText]; //添加倒计时
        }
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)refreshPageNewMarkTip
{
    if ([self.element.SFTYB isEqualToString:@"3"]) { // 只有新手标
        [self setUpHeaderUIWithHeadeHeight:197 layoutTop:10.0f dEBXLab:YES tipView:NO];
    }

    if ([self.element.HKFS isEqualToString:@"3"]) { // 只有等额本息
        [self setUpHeaderUIWithHeadeHeight:189 layoutTop:35.0f dEBXLab:NO tipView:YES];
    }

    if ([self.element.SFTYB isEqualToString:@"3"] && [self.element.HKFS isEqualToString:@"3"]) { // 既有等额本息 又有新手标
        [self setUpHeaderUIWithHeadeHeight:222 layoutTop:35.0f dEBXLab:NO tipView:NO];
    }
    
    CGFloat money =  [self.element.ZDTZJE floatValue];
    if (money) {
        self.investHeaderView.isNewMarkTipLab.text = [NSString stringWithFormat:@"该项目为新手专享，单人单笔最大出借金额：%.2f元",money];

    }
}

- (void)setUpHeaderUIWithHeadeHeight:(CGFloat)height layoutTop:(CGFloat)layoutTop dEBXLab:(BOOL)deBX tipView:(BOOL)tipView
{
    self.investHeaderView.isNewMarkTipView.hidden = tipView;
    CGRect newFrame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.headerview.frame = newFrame;
    self.investHeaderView.frame = newFrame;
    self.tableView.tableHeaderView.frame = newFrame;
    self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = self.headerview;

    self.investHeaderView.layoutViewToTopCons.constant = layoutTop;
    self.investHeaderView.dengEBXiLab.hidden = deBX;
    self.investHeaderView.dengEBXiLab.layer.masksToBounds = YES;
    self.investHeaderView.dengEBXiLab.layer.cornerRadius = 7;
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
                NSString *accountStr = [NSString stringWithFormat:@"%.2lf",[accountUser.cash doubleValue]];
                useAmount_ = accountUser.cash; //可以余额
//                self.useAmountLab.text = accountStr;
                self.investHeaderView.useAmountLab.text = accountStr;

            } else {
//                self.useAmountLab.text = @"0.00元";
                self.investHeaderView.useAmountLab.text = @"0.00元";

            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:accountUser.cash forKey:@"AvlBal"];
        }
        
    } faild:^(NSError *error) {
        
    }];
}

/**
 * post出借
 **/
- (void)postStartInitiativeTenderWithLoanId:(NSString *)loanId TransAmt:(NSString *)transAmt RedPact:(NSString *)redPact CouponId:(NSString *)couponId
{
    self.sureInvestBtn.enabled = NO;
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    
    info.serviceString = DDRequestlmInitiativeTender;
    
    if ([self.element.SFSYYHQ isEqual:@"Y"] && (self.selectedModel || (moreHbArray && moreHbArray.count != 0))) {
        info.dataParam = @{@"loanId":loanId, @"transAmt":transAmt, @"redPact":redPact, @"couponId":couponId, @"client":@"ios", @"from":@"M"};
    } else {
        info.dataParam = @{@"loanId":loanId, @"transAmt":transAmt, @"redPact":redPact, @"client":@"ios", @"from":@"M"};
    }
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        self.sureInvestBtn.enabled = YES;
        [MBProgressHUD hideHUD];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"立即出借";
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
        self.sureInvestBtn.enabled = YES;
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

#pragma mark - lazyload
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


#pragma mark - 汇付操作完成后的回调
- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    if (self.styleBan == DDSetStylebindCard) {
        
        [self makeBindCardSuccess:isSuccess];
        return;
    } else if (self.styleBan == DDSetStyleOther) {
        [self investSuccess:isSuccess message:message Serial_number:serial_number];
    }
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

- (void)showAlertWithStr:(NSString *)str
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)investSuccess:(BOOL)isSuccess message:(NSString *)message Serial_number:(NSString *)serial_number
{
    if (isSuccess) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *balance = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
        int cashMoney =  ([balance doubleValue] - [self.investTxf.text doubleValue]);
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


/** 获取用户开户信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        //缓存用户信息
        userCardInfo = dict;
        if (dict[@"body"][@"bankcardBind"][@"YHKH"]) {
            isBankCard = YES;
        } else {
            isBankCard = NO;
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
            [self.sureInvestBtn setTitle:investStr forState:UIControlStateNormal];
            self.sureInvestBtn.enabled = NO;
            [self.sureInvestBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
            [self.sureInvestBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];
            
        }else if (day==0  && house >= 2) {
            //大于2小时
            //比较日期是不是一天
            if ([daydjs isEqualToString:daynow]) {
                //是一天显示今日
                NSString *investStr = [NSString stringWithFormat:@"今日 %@开标",[NSDate ConvertStrToTime:_element.DJSKBSJ]];
                [self.sureInvestBtn setTitle:investStr forState:UIControlStateNormal];
                self.sureInvestBtn.enabled = NO;
                [self.sureInvestBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
                [self.sureInvestBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];
                
            } else {
                //不是一天显示1天后
                NSString *investStr = [NSString stringWithFormat:@"1天后 %@开标",[NSDate ConvertStrToTime:_element.DJSKBSJ]];
                [self.sureInvestBtn setTitle:investStr forState:UIControlStateNormal];
                self.sureInvestBtn.enabled = NO;
                [self.sureInvestBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
                [self.sureInvestBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];

            }
            
        }else if (day==0 && house <2) {
            //小于2小时 开始执行倒计时
            //获取倒计时秒数
            long int tempS = house *60 *60 + minute * 60 +second;
            secondNum = [NSString stringWithFormat:@"%ld",tempS];
            //执行倒计时
            [self setupCountDowntimer:self.sureInvestBtn];
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
                countDownBtn.enabled = YES;
                countDownBtn.userInteractionEnabled = YES;
            });
            
        } else {
            
            NSString *strTimeh = [NSString stringWithFormat:@"%01zd", timeout/3600];
            NSString *strTimem = [NSString stringWithFormat:@"%02zd", (timeout/60)%60];
            NSString *strTimes = [NSString stringWithFormat:@"%02zd", timeout%60];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [countDownBtn setTitle:[NSString stringWithFormat:@"%@小时%@分钟%@秒", strTimeh, strTimem, strTimes] forState:UIControlStateNormal];
                countDownBtn.userInteractionEnabled = NO;
                countDownBtn.enabled = NO;
                [countDownBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
                [countDownBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];

                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}

//--------------------添加倒计时----------------------------

@end



