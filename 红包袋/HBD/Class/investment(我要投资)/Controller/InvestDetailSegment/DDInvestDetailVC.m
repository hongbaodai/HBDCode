//
//  DDInvestDetailVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/18.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestDetailVC.h"
#import "DDInvestdInfoView.h"
#import "DDInvestSureVC.h"
#import "XHStarRateView.h"
#import "DDProjectDetailModel.h"
#import "DDWebViewVC.h"
#import "DDProjectDetailTwoModel.h"
#import "NSDate+Setting.h"
#import "HXTextAndButModel.h"
#import "HWAlertViewController.h"
#import "HXAlertAccount.h"
#import "DDRegisterSuccessVC.h"

@interface DDInvestDetailVC ()

// 项目描述
@property (weak, nonatomic) IBOutlet UILabel *describeLab;
@property (weak, nonatomic) IBOutlet UIView *desContainView;

@property (weak, nonatomic) IBOutlet UIView *borrowerBgVIew;

// 资金用途
@property (weak, nonatomic) IBOutlet UILabel *moneyUseLab;
// 借款企业
@property (weak, nonatomic) IBOutlet UILabel *companylab;
// 成立时间
@property (weak, nonatomic) IBOutlet UILabel *setTimeLab;
// 所属行业
@property (weak, nonatomic) IBOutlet UILabel *industryLab;
// 经营状况
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
// 项目地区
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
// 注册资本
@property (weak, nonatomic) IBOutlet UILabel *regMoneyLab;
// 员工人数
@property (weak, nonatomic) IBOutlet UILabel *personnelLab;
// 企业年收入
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;
// 投标开标时间
@property (weak, nonatomic) IBOutlet UILabel *openTimeLab;

// 募集期
@property (weak, nonatomic) IBOutlet UILabel *collectPeriodLab;
// 募集期view
@property (weak, nonatomic) IBOutlet UIView *collectPeriodView;

// 投标截止时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
// 出借人条件
@property (weak, nonatomic) IBOutlet UILabel *conditionLab;
// 产品类型
@property (weak, nonatomic) IBOutlet UILabel *projectType;
// 项目类型
@property (weak, nonatomic) IBOutlet UILabel *projectLab;
// 有无车产
@property (weak, nonatomic) IBOutlet UILabel *haveCarLab;
// 有无房贷
@property (weak, nonatomic) IBOutlet UILabel *haveHouseDaiLab;
// 有无车贷
@property (weak, nonatomic) IBOutlet UILabel *haveCarDaiLab;
// 收入Y值
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *incomeLabY;

// 借款方
@property (weak, nonatomic) IBOutlet UILabel *moneyerLab;
// 付款方
@property (weak, nonatomic) IBOutlet UILabel *payerLab;
// 还款方式
@property (weak, nonatomic) IBOutlet UILabel *paybackLab;
// 计息方式
@property (weak, nonatomic) IBOutlet UILabel *percentStyleLab;
// 项目评级
@property (weak, nonatomic) IBOutlet UIView *starView;
// 项目描述view
@property (weak, nonatomic) IBOutlet UIView *projectDesView;
// 资金用途
@property (weak, nonatomic) IBOutlet UIView *moneyUsedView;
// 借款方信息
@property (weak, nonatomic) IBOutlet UIView *borrowerInformationView;
// 还款方式
@property (weak, nonatomic) IBOutlet UIView *reimbursementMeansView;

@property (weak, nonatomic) IBOutlet UILabel *projectGrade;
@property (weak, nonatomic) IBOutlet UIButton *projectGradeBtn;

@property (nonatomic, strong) UIView *headview;
@property (nonatomic, strong) DDInvestdInfoView *indInfoView;

@property (nonatomic, strong) DDProjectDetailModel *model;

@property (nonatomic, strong) DDProjectDetailTwoModel *modelTwo;

@end

@implementation DDInvestDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//   self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.tableView setSeparatorColor:DDRGB(237, 237, 237)];
    if (IS_iPhoneX) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    [HXTextAndButModel hxProjectItem:self.projectDesView strImgViewFrame:self.projectDesView.bounds status:TextAndImgStatusProjectDescribe];
    [HXTextAndButModel hxProjectItem:self.moneyUsedView strImgViewFrame:self.moneyUsedView.bounds status:TextAndImgStatusMoneyUsed];
    [HXTextAndButModel hxProjectItem:self.borrowerInformationView strImgViewFrame:self.borrowerInformationView.bounds status:TextAndImgStatusBorrowerInformation];
    [HXTextAndButModel hxProjectItem:self.collectPeriodView strImgViewFrame:self.collectPeriodView.bounds status:TextAndImgCollectPeriod];
   
    [self ininUIViews];
    
}

- (IBAction)projcectGradeAction:(UIButton *)sender {
    HWAlertViewController *hw = [[HWAlertViewController alloc] init];
    hw.clickBtnBlock = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    [self presentViewController:hw animated:NO completion:nil];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self postLoanDetailWithLoanId:self.loanId];
    
}

//显示星星等级
- (void)ininUIStarRateViewWithScore:(CGFloat)score {
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithOnlyShowStarFrame:CGRectMake(0, 0, self.starView.width_, self.starView.height_) CurrentScore:score];
    
    [self.starView addSubview: starRateView];
}

- (void)ininUIViews {

    self.indInfoView = [DDInvestdInfoView investmentDetailInfoView];
    self.indInfoView.backgroundColor = COLOUR_BTN_BLUE_NEW;
    self.indInfoView.limitLab.layer.masksToBounds = YES;
    self.indInfoView.limitLab.layer.cornerRadius = 9;
    self.indInfoView.qtamountLab.layer.masksToBounds = YES;
    self.indInfoView.qtamountLab.layer.cornerRadius = 9;
    self.indInfoView.dengEBXLabel.layer.masksToBounds = YES;
    self.indInfoView.dengEBXLabel.layer.cornerRadius = 9;

    CGRect newFrame = CGRectMake(0, 0, SCREEN_WIDTH, 208);
    self.headview = [[UIView alloc] initWithFrame:newFrame];
    self.indInfoView.frame = self.headview.frame;
    [self.headview addSubview:self.indInfoView];
    
    self.tableView.tableHeaderView = self.headview;
 }

- (void)fillViewData {
    
    if (![_model.SFTYB isEqualToString:@"3"]) {
        CGRect newFrame = CGRectMake(0, 0, SCREEN_WIDTH, 170);
        self.indInfoView.markView.hidden = YES;
        self.headview.frame = newFrame;
    }
    self.indInfoView.markTextLab.text = [NSString stringWithFormat:@"该项目为新手专享，单人单笔最大出借金额：%.2f元", [_model.ZDTZJE doubleValue]];
    
    if ([_model.HKFS isEqualToString:@"3"]) {
        self.indInfoView.layoutCenterXConstaint.constant = 35.0f;
        self.indInfoView.dengEBXLabel.hidden = NO;
    } else {
        self.indInfoView.layoutCenterXConstaint.constant = 0.0f;
        self.indInfoView.dengEBXLabel.hidden = YES;
    }

    if (_model.TXY.length > 0) { // 加息 //预期年化收益
        NSString *str = [NSString stringWithFormat:@"%g+%g",[_model.TXZ doubleValue] ,[_model.TXY doubleValue]];
        self.indInfoView.increasesInInterestRates.hidden = NO;
        self.indInfoView.percentLab.text = str;

    } else { // 不加息 //预期年化收益
        self.indInfoView.increasesInInterestRates.hidden = YES;
        if (_model.NHLL) { // 年化收益

            NSString *str = [NSString stringWithFormat:@"%g",[_model.NHLL doubleValue]];
            self.indInfoView.percentLab.text = str;

        } else { // 既不加息 也无年化收益的情况
            self.indInfoView.percentLab.text = @"--";
        }
    }

    if (_model.HKFS) { // 等额本息
        if([_model.HKFS isEqual:@"3"]){ // 等额本息
            self.indInfoView.limitLab.text = [NSString stringWithFormat:@" 项目期限%@个月 ", _model.HKZQSL];
            [HXTextAndButModel hxProjectItem:self.reimbursementMeansView strImgViewFrame:self.reimbursementMeansView.bounds status:TextAndImgStatusReimbursementAverageCapitalPlusInterest];
        } else { // 其他情况
            if (_model.HKZQSL) { 
#pragma mark - 处理天 月逻辑
                if([_model.HKZQDW isEqualToString:@"1"]){ //天

                    self.indInfoView.limitLab.text = [NSString stringWithFormat:@" 项目期限%@天 ", _model.HKZQSL];
                    [self.reimbursementMeansView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

                    [HXTextAndButModel hxProjectItem:self.reimbursementMeansView strImgViewFrame:self.reimbursementMeansView.bounds status:TextAndImgStatusReimbursementMeansDay];

                }else if([_model.HKZQDW isEqualToString:@"2"]){ //周

                    self.indInfoView.limitLab.text = [NSString stringWithFormat:@" 项目期限%@周 ", _model.HKZQSL];
                }else if ([_model.HKZQDW isEqualToString: @"3"]) { //月

                    [self.reimbursementMeansView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

                    self.indInfoView.limitLab.text = [NSString stringWithFormat:@" 项目期限%@个月 ", _model.HKZQSL];
                    [HXTextAndButModel hxProjectItem:self.reimbursementMeansView strImgViewFrame:self.reimbursementMeansView.bounds status:TextAndImgStatusReimbursementMeansMouth];

                } if([_model.HKZQDW isEqualToString:@"4"]){ //年

                    self.indInfoView.limitLab.text = [NSString stringWithFormat:@" 项目期限%@年 ", _model.HKZQSL];
                }

            } else {
                self.indInfoView.limitLab.text = [NSString stringWithFormat:@" 项目期限 "];
            }
        }
    }

    if (_model.QTJE) {
        self.indInfoView.qtamountLab.text = [NSString stringWithFormat:@" 起投金额%.2f元 ", [_model.QTJE floatValue]];
    } else {
        self.indInfoView.qtamountLab.text = [NSString stringWithFormat:@" 起投金额 "];
    }
    
    if (_model.ZE) {
        self.indInfoView.allAmountLab.text = _model.ZE;
    } else {
        self.indInfoView.allAmountLab.text = @"";
    }
    
    if (_model.ZE) {
        double yed = [_model.ZE doubleValue] - [_model.MQYTBJE doubleValue];
        self.indInfoView.nowAmountLab.text = [NSString stringWithFormat:@"%.2f",yed];
    } else {
        self.indInfoView.nowAmountLab.text = @"";
    }
    
    if (_model.JKMS) {// 项目描述
        self.describeLab.text = [NSString stringWithFormat:@"%@", _model.JKMS];

    } else {
        self.describeLab.text = @"";
    }
    
    if (_model.ZJYT) {// 资金用途
        self.moneyUseLab.text = [NSString stringWithFormat:@"%@", _model.ZJYT];

    } else {
        self.moneyUseLab.text = @"";
    }

    if (_model.openDate) {// 开标时间
        self.openTimeLab.text = [NSString stringWithFormat:@"%@", [NSDate transformDateSecondsNoMToTime: _model.openDate]];
    } else {
        self.openTimeLab.text = @"";
    }
    
    if (_model.HKFS) {// 还款方式
        if ([_model.HKFS isEqual:@"1"]) {
            self.paybackLab.text = @"按月付息到期还本";
        }else if([_model.HKFS isEqual:@"2"]){
            self.paybackLab.text = @"到期还本付息";
        }else if([_model.HKFS isEqual:@"3"]){
            self.paybackLab.text = @"等额本息";
        }

    } else {
        self.paybackLab.text = @"";
    }
    
    if (_model.JXFS) {// 计息方式
        if ([_model.JXFS isEqualToString:@"1"]) {
            self.percentStyleLab.text = @"T+1个自然日";
        }else if ([_model.JXFS isEqualToString:@"2"]) {
            self.percentStyleLab.text = @"出借当日计息";//T+0个自然日
        }

    } else {
        self.percentStyleLab.text = @"";
    }
    
    if (_model.XMLX) {// 项目类型
        self.projectLab.text = _model.XMLX;
    } else {
        self.projectLab.text = @"";
    }
    if (_model.TZRTJ) {// 出借人条件
        NSMutableString *mustr = [NSMutableString stringWithFormat:@"%@", _model.TZRTJ];
        [mustr insertString:@"“" atIndex:6];
        [mustr insertString:@"”" atIndex:10];
        self.conditionLab.text = mustr;
    } else {
        self.conditionLab.text = @"";
    }

    if (_model.projectType) {//产品类型
        if ([_model.projectType isEqualToString:@"1"]) {//智造类
            self.projectType.text = @"智造类项目";
        }else if ([_model.projectType isEqualToString:@"2"]) {//消费类
            self.projectType.text = @"消费类项目";
        }else if ([_model.projectType isEqualToString:@"3"]) {//惠农类
            self.projectType.text = @"惠农类项目";
        }else if ([_model.projectType isEqualToString:@"4"]) {//电商类
            self.projectType.text = @"电商类项目";
        }else {
            self.projectType.text = @"";
        }
    }

    if (_model.XMPJ) { // 项目评级
         
        float score = [_model.XMPJ floatValue] ;
        [self ininUIStarRateViewWithScore:score];
    }

//    if (_model.TBKFQ) { // 项目募集期
//        self.collectPeriodLab.text = [NSString stringWithFormat:@"%@天",_model.TBKFQ];
//    }
    // 这里赋值投标截止时间🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫
//    self.endTimeLab.text = 
    if (_model.TBKFQ) { // 项目募集期
        self.collectPeriodLab.text = [NSString stringWithFormat:@"%@天",_model.TBKFQ];
    }
    // 投标截止时间
    self.endTimeLab.text = [NSString stringWithFormat:@"%@", [NSDate transformDateSecondsNoMToTime: _model.ZBJSSJ]];

}


- (void)fillViewDataTwo {
    
    //客户类型：KHLX（1-个人 2-企业）
    if ([_modelTwo.KHLX isEqualToString:@"1"]) { //个人
        
        self.incomeLabY.constant = 26;
        self.haveHouseDaiLab.hidden = NO;
        self.haveCarDaiLab.hidden = NO;
        self.haveCarLab.hidden = NO;
        
        if (_modelTwo.KHMC) {// 借款人
            self.companylab.text = [NSString stringWithFormat:@"借款人：%@", _modelTwo.KHMC];
            self.moneyerLab.text = [NSString stringWithFormat:@"%@", _modelTwo.KHMC];// 借款方
            self.payerLab.text = [NSString stringWithFormat:@"%@", _modelTwo.KHMC];// 付款方
        } else {
            self.companylab.text = [NSString stringWithFormat:@"借款人："];
            self.moneyerLab.text = [NSString stringWithFormat:@""];
            self.payerLab.text = [NSString stringWithFormat:@""];
        }
        
        if (_modelTwo.XB) {// 性别：XB（0-男 1-女）
            if ([_modelTwo.XB isEqualToString:@"0"]) {
                self.areaLab.text = [NSString stringWithFormat:@"性别：男"];
            } else{
                self.areaLab.text = [NSString stringWithFormat:@"性别：女"];
            }
        } else {
            self.areaLab.text = [NSString stringWithFormat:@"性别："];
        }
        
        if (_modelTwo.XL) {// 最高学历：XL（0-大专及以下；1-本科；2-硕士及以上）
            if ([_modelTwo.XL isEqualToString:@"0"]) {
                self.setTimeLab.text = [NSString stringWithFormat:@"最高学历：大专及以下"];
            } else if ([_modelTwo.XL isEqualToString:@"1"]) {
                self.setTimeLab.text = [NSString stringWithFormat:@"最高学历：本科"];
            } else {
                self.setTimeLab.text = [NSString stringWithFormat:@"最高学历：硕士及以上"];
            }
        } else {
            self.setTimeLab.text = [NSString stringWithFormat:@"最高学历："];
        }
        
        if (_modelTwo.HYZK) {// 婚姻状况：HYZK（0-已婚；1-未婚；2-离异）
            if ([_modelTwo.HYZK isEqualToString:@"0"]) {
                self.regMoneyLab.text = [NSString stringWithFormat:@"婚姻状况：已婚"];
            } else if ([_modelTwo.HYZK isEqualToString:@"1"]) {
                self.regMoneyLab.text = [NSString stringWithFormat:@"婚姻状况：未婚"];
            } else {
                self.regMoneyLab.text = [NSString stringWithFormat:@"婚姻状况：离异"];
            }
        } else {
            self.regMoneyLab.text = [NSString stringWithFormat:@"婚姻状况："];
        }
        
        if (_modelTwo.CSRQ) {// 年龄：根据出生日期计算（出生日期：CSRQ）
            
            // 获取代表公历的NSCalendar对象
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            // 获取当前日期
            NSDate* dt = [NSDate date];
            // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
            unsigned unitFlags = NSCalendarUnitYear |
            NSCalendarUnitMonth |  NSCalendarUnitDay |
            NSCalendarUnitHour |  NSCalendarUnitMinute |
            NSCalendarUnitSecond | NSCalendarUnitWeekday;
            // 获取不同时间字段的信息
            NSDateComponents* comp = [gregorian components: unitFlags
                                                  fromDate:dt];
         
            NSString * csStr = [_modelTwo.CSRQ substringWithRange:NSMakeRange(0, 4)]; //出生年
            NSString * str = [NSString stringWithFormat:@"%ld",comp.year - [csStr intValue]];
            
            self.industryLab.text = [NSString stringWithFormat:@"年龄：%@", str];
        } else {
            self.industryLab.text = [NSString stringWithFormat:@"年龄："];
        }
        
        if (_modelTwo.GZCS) {// 工作城市：沿用PC端的逻辑，解析字段GZCS
            self.personnelLab.text = [NSString stringWithFormat:@"工作城市：%@", _modelTwo.GZCS];
        } else {
            self.personnelLab.text = [NSString stringWithFormat:@"工作城市："];
        }
        
        if (_modelTwo.YWFC) {// 有无房产：YWFC（Y-有；N-无）
            if ([_modelTwo.YWFC isEqualToString:@"N"]) {
                 self.stateLab.text = [NSString stringWithFormat:@"有无房产：无房"];
            } else{
                 self.stateLab.text = [NSString stringWithFormat:@"有无房产：有房"];
            }
           
        } else {
            self.stateLab.text = [NSString stringWithFormat:@"有无房产："];
        }
        
        if (_modelTwo.YWCC) {// 有无车产：YWCC（Y-有；N-无）
            if ([_modelTwo.YWCC isEqualToString:@"N"]) {
                self.haveCarLab.text = [NSString stringWithFormat:@"有无车产：无车"];
            } else{
                self.haveCarLab.text = [NSString stringWithFormat:@"有无车产：有车"];
            }
        } else {
            self.haveCarLab.text = [NSString stringWithFormat:@"有无车产："];
        }
        
        if (_modelTwo.YWFD) {// 有无房贷：YWFD（Y-有；N-无）
            if ([_modelTwo.YWFD isEqualToString:@"N"]) {
                self.haveHouseDaiLab.text = [NSString stringWithFormat:@"有无房贷：无房贷"];
            } else{
                self.haveHouseDaiLab.text = [NSString stringWithFormat:@"有无房贷：有房贷"];
            }
        } else {
            self.haveHouseDaiLab.text = [NSString stringWithFormat:@"有无房贷："];
        }
        
        if (_modelTwo.YWCD) {// 有无车贷：YWCD（Y-有；N-无）
            if ([_modelTwo.YWCD isEqualToString:@"N"]) {
                self.haveCarDaiLab.text = [NSString stringWithFormat:@"有无车贷：无车贷"];
            } else{
                self.haveCarDaiLab.text = [NSString stringWithFormat:@"有无车贷：有车贷"];
            }
        } else {
            self.haveCarDaiLab.text = [NSString stringWithFormat:@"有无车贷："];
        }
        
        // 家庭净资产：JTJZC（0-50万以下；1-50~100万；2-100~200万；3-200~400万；4-400~600万；5-600万以上）
        NSArray *ygArray = @[@"500000.00以下",
                             @"500000.00元~1000000.00元",
                             @"1000000.00元~2000000.00元",
                             @"2000000.00元~4000000.00元",
                             @"4000000.00元~6000000.00元",
                             @"6000000.00元以上"];
        if (_modelTwo.JTJZC) {
            int i = [_modelTwo.JTJZC intValue];
            self.incomeLab.text = [NSString stringWithFormat:@"家庭净资产：%@", ygArray[i]];
        } else {
            self.incomeLab.text = [NSString stringWithFormat:@"家庭净资产："];
        }
        //更新约束,解决6的家庭净资产重叠问题
        [self.companylab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
        }];
    } else { // 企业
        
        self.incomeLabY.constant = 6;
        self.haveHouseDaiLab.hidden = YES;
        self.haveCarDaiLab.hidden = YES;
        self.haveCarLab.hidden = YES;
        
        if (_modelTwo.KHMC) {// 借款企业
            self.companylab.text = [NSString stringWithFormat:@"借款企业：%@", _modelTwo.KHMC];
            self.moneyerLab.text = [NSString stringWithFormat:@"%@", _modelTwo.KHMC];// 借款方
            self.payerLab.text = [NSString stringWithFormat:@"%@", _modelTwo.KHMC];// 付款方
        } else {
            self.companylab.text = [NSString stringWithFormat:@"借款企业："];
            self.moneyerLab.text = [NSString stringWithFormat:@""];
            self.payerLab.text = [NSString stringWithFormat:@""];
        }
        
        
        
        if (_modelTwo.CLSJ) {// 成立时间
            if (_modelTwo.CLSJ ==nil ||[_modelTwo.CLSJ isEqualToString:@""]) {
                self.setTimeLab.text = [NSString stringWithFormat:@"成立时间："];
            } else{
                NSString *timeStr = [_modelTwo.CLSJ substringWithRange:NSMakeRange(0, 10)];
                self.setTimeLab.text = [NSString stringWithFormat:@"成立时间：%@", timeStr];
            }
        } else {
            self.setTimeLab.text = [NSString stringWithFormat:@"成立时间："];
        }
        
        NSArray *hyArray = @[@"农、林、牧、渔业",
                             @"采矿业",
                             @"制造业",
                             @"电力、热力、燃气及水的生产和供应业",
                             @"环境和公共设施管理业",
                             @"建筑业",
                             @"交通运输、仓储业和邮政业",
                             @"信息传输、计算机服务和软件业",
                             @"批发和零售业",
                             @"住宿、餐饮业",
                             @"金融、保险业",
                             @"房地产业",
                             @"租赁和商务服务业",
                             @"科学研究、技术服务和地质勘查业",
                             @"水利、环境和公共设施管理业",
                             @"居民服务和其它服务业",
                             @"教育",
                             @"卫生、社会保障和社会服务业",
                             @"文化、体育、娱乐业",
                             @"综合（含出借类、主业不明显）",
                             @"其它"];
        if (_modelTwo.SSHY) {// 所属行业
            
            int i = [_modelTwo.SSHY intValue];
            self.industryLab.text = [NSString stringWithFormat:@"所属行业：%@", hyArray[i]];
            
        } else {
            self.industryLab.text = [NSString stringWithFormat:@"所属行业："];
        }
        
        if (_modelTwo.JYZK) {// 经营状况
            self.stateLab.text = [NSString stringWithFormat:@"经营状况：%@", _modelTwo.JYZK];
        } else {
            self.stateLab.text = [NSString stringWithFormat:@"经营状况："];
        }
        
        if (_modelTwo.XMDQ) {// 项目地区
            self.areaLab.text = [NSString stringWithFormat:@"项目地区：%@", _modelTwo.XMDQ];
        } else {
            self.areaLab.text = [NSString stringWithFormat:@"项目地区："];
        }
        
        if (_modelTwo.ZCZB) { // 注册资本
            self.regMoneyLab.text = [NSString stringWithFormat:@"注册资本：%.2f元", [_modelTwo.ZCZB floatValue]];
        } else {
            self.regMoneyLab.text = [NSString stringWithFormat:@"注册资本："];
        }
        
        // 员工人数：YGRS（0:10人以内 1:10~20人 2:20~50人 3:50~100人 4:100~200人 5:200~500人 6:500人以上）
        NSArray *ygArray = @[@"10人以内",
                             @"10~20人",
                             @"20~50人",
                             @"50~100人",
                             @"100~200人",
                             @"200~500人",
                             @"500人以上"];
        if (_modelTwo.YGRS) { // 员工人数
            int i = [_modelTwo.YGRS intValue];
            self.personnelLab.text = [NSString stringWithFormat:@"员工人数：%@", ygArray[i]];
        } else {
            self.personnelLab.text = [NSString stringWithFormat:@"员工人数："];
        }
        NSArray *srArray = @[@"500000.00元以下",
                             @"500000.00元-1500000.00元",
                             @"1500000.00元-5000000.00元",
                             @"5000000.00元-20000000.00元",
                             @"20000000.00元以上"];
        if (_modelTwo.QYNSR) { // 企业年收入
            int i = [_modelTwo.QYNSR intValue];
            self.incomeLab.text = [NSString stringWithFormat:@"企业年收入：%@", srArray[i]];
            
        } else {
            self.incomeLab.text = [NSString stringWithFormat:@"企业年收入："];
        }
    }
    
    
    
    
    // 客户评级：KHPJ（A,  A-,  B,  B-,  C）
//    float score;
//    if (_modelTwo.KHPJ) {
//        if ([_modelTwo.KHPJ isEqualToString:@"A"]) {
//            score = 5 ;
//        } else if ([_modelTwo.KHPJ isEqualToString:@"A-"]) {
//            score = 4.5 ;
//        } else if ([_modelTwo.KHPJ isEqualToString:@"B"]) {
//            score = 4 ;
//        } else if ([_modelTwo.KHPJ isEqualToString:@"B-"]) {
//            score = 3.5 ;
//        } else if ([_modelTwo.KHPJ isEqualToString:@"C"]) {
//            score = 3 ;
//        } else {
//            score = 5 ;
//        }
//
//        [self ininUIStarRateViewWithScore:score];
//    }
    
    [_borrowerBgVIew setNeedsLayout]; //获取背景view真实高度
    [_borrowerBgVIew layoutIfNeeded];
}

- (void)investBtnClick {
    HXTabBarViewController *tabbar = (HXTabBarViewController *)self.tabBarController;
    if (!tabbar.bussinessKind) { //未登录
        [self presentLoginVC];
    } else {
    
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDInvestSureVC" bundle:nil];
        DDInvestSureVC *vc = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 弹出登录页面
- (void)presentLoginVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
    BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.isPresentedWithMyAccount = 0;
    BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if (indexPath.row == 14) {//点击了风险提示
//        DDWebViewVC *vc = [[DDWebViewVC alloc] init];
//        vc.webType = DDWebTypeWLJDFXTS;
//        vc.navTitle = @"网络借贷风险提示";
//        [self.navController pushViewController:vc animated:YES];
//    }
//    if (indexPath.row == 15) {//点击了禁止性行为
//        DDWebViewVC *vc = [[DDWebViewVC alloc] init];
//        vc.webType = DDWebTypeWLJDJZXXW;
//        vc.navTitle = @"网络借贷禁止性行为";
//        [self.navController pushViewController:vc animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return self.describeLab.height_ +40;
    }else if (indexPath.row == 2) {
        return self.moneyUseLab.height_ +40;
    } else if (indexPath.row == 3) {
        return _borrowerBgVIew.height_ +50;
    } else if (indexPath.row == 0) {
        return 39;
    } else {
        return 45;
    }
}


#pragma mark - post
/** POST项目详情  */
- (void)postLoanDetailWithLoanId:(NSString *)loanId {
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestLoanDetail;
    info.dataParam = @{@"loanId":loanId};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];

        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
         DDProjectDetailModel *model  = [DDProjectDetailModel mj_objectWithKeyValues:dict[@"body"][@"loan"]];
            _model = model;

            [self postLoanDetailTwoWithBorrowerId:model.JKZH_ID andRzsqId:model.RZSQ_ID];
        }
        [self fillViewData];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}


/**  */
- (void)postLoanDetailTwoWithBorrowerId:(NSString *)borrowerId andRzsqId:(NSString *)rzsqId{
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestLoanDetailTwo;
    info.dataParam = @{@"JKZH_ID":borrowerId, @"RZSQ_ID":rzsqId};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            DDProjectDetailTwoModel *model  = [DDProjectDetailTwoModel mj_objectWithKeyValues:dict[@"body"][@"xxpl"]];
            _modelTwo = model;
        }
        [self fillViewDataTwo];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}


@end
