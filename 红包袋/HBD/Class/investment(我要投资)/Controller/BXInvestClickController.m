//
//  BXInvestClickController.m
//  sinvo
//
//  Created by 李先生 on 15/4/13.
//  Copyright (c) 2015年 李先生. All rights reserved.
//

#import "BXInvestClickController.h"
#import "BXInvestmentDetailModel.h"
#import "BXInvestmentDetialController.h"
#import "BXJumpThirdPartyController.h"
#import "BXPayObject.h"
#import "BXAccountAssetsVC.h"
#import "MJRefresh.h"
#import "NSString+Other.h"

@interface BXInvestClickController ()<PayThirdPartyProtocol,UITextFieldDelegate>
// 充值
@property (weak, nonatomic) IBOutlet UIButton *toRecharge;

@end

@implementation BXInvestClickController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self fillInWithinvestClick:self.element];
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewStatus)];
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"立即投资"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"立即投资"];
}

////动态刷新 实际支付金额
//- (void)refreshActualPayment
//{
//    BXInvestmentDetailModel *element = self.element;
//    
//    if ([element.prizeValue isEqualToString:@"-1"] && [element.prizeType isEqualToString:@"-1"]) {
//        
//        if (self.investMoneyTextField.text.length) {
//            self.actualPayment.text = self.investMoneyTextField.text;
//        }else{
//            self.actualPayment.text = @"0.00";
//        }
//        
//    }else if ([element.prizeType isEqualToString:@"1"]) { //定额红包
//
//        if (self.checkboxButton.selected == YES) {
//            if ([element.prizeValue intValue] <= [self.redPact intValue]) {
//                if ([self.investMoneyTextField.text intValue] > [element.prizeValue intValue]) {
//                    self.actualPayment.text = [NSString stringWithFormat:@"%.2f",([self.investMoneyTextField.text doubleValue] - [element.prizeValue doubleValue])];
//                }else{
//                    if (self.investMoneyTextField.text.length) {
//                        self.actualPayment.text = self.investMoneyTextField.text;
//                    }else{
//                        self.actualPayment.text = @"0.00";
//                    }
//                }
//            }else{
//                if ([self.investMoneyTextField.text intValue] > [self.redPact intValue]) {
//                    self.actualPayment.text = [NSString stringWithFormat:@"%.2f",([self.investMoneyTextField.text doubleValue] - [self.redPact doubleValue])];
//                }else{
//                    if (self.investMoneyTextField.text.length) {
//                        self.actualPayment.text = self.investMoneyTextField.text;
//                    }else{
//                        self.actualPayment.text = @"0.00";
//                    }
//                }
//            }
//            
//        }else{
//            if (self.investMoneyTextField.text.length) {
//                self.actualPayment.text = self.investMoneyTextField.text;
//            }else{
//                self.actualPayment.text = @"0.00";
//            }
//        }
//        
//    }else if ([element.prizeType isEqualToString:@"2"]){    // 按比例使用红包
//        
//        double redPactNum = [element.prizeValue doubleValue] * [self.investMoneyTextField.text doubleValue] * 0.01; //比例红包
//        if (self.checkboxButton.selected == YES) {
//            if ([self.redPact doubleValue] >= redPactNum) {
//                if ([self.investMoneyTextField.text doubleValue] > redPactNum) {
//                    self.actualPayment.text = [NSString stringWithFormat:@"%.2f",[self.investMoneyTextField.text doubleValue] - redPactNum];
//                }else{
//                    if (self.investMoneyTextField.text.length) {
//                        self.actualPayment.text = self.investMoneyTextField.text;
//                    }else{
//                        self.actualPayment.text = @"0.00";
//                    }
//                }
//            }else{
//                if ([self.investMoneyTextField.text doubleValue] > [self.redPact doubleValue]) {
//                    self.actualPayment.text = [NSString stringWithFormat:@"%.2f",[self.investMoneyTextField.text doubleValue] - [self.redPact doubleValue]];
//                }else{
//                    if (self.investMoneyTextField.text.length) {
//                        self.actualPayment.text = self.investMoneyTextField.text;
//                    }else{
//                        self.actualPayment.text = @"0.00";
//                    }
//                }
//            }
//        }else{
//            if (self.investMoneyTextField.text.length) {
//                self.actualPayment.text = self.investMoneyTextField.text;
//            }else{
//                self.actualPayment.text = @"0.00";
//            }
//            
//        }
//            
//    }
//}
//

//- (IBAction)toRechargeClick:(UIButton *)sender {
//    
//
//    
//}

////开始刷新
//- (void)setupRefresh{
//    
//    [self.tableView.header beginRefreshing];
//}
//
////刷新数据
//- (void)loadNewStatus{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"userId"]) {
////        [self postAccountInfo];
//    }else{
//        ;
//    }
//    
//}

//
//- (void)makeCoverView{
//    
//    UIView *coverView = [[UIView alloc] init];
//    coverView.frame = CGRectMake(0, 0, BXSize.width, BXSize.height - 64);
//    coverView.backgroundColor = [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:0.8];
//    [self.view addSubview:coverView];
//    
//    CGFloat iconImageW = BXSize.width;
//    CGFloat iconImageH = 110;
//    CGFloat iconImageX = (BXSize.width - iconImageW) * 0.5;
//    CGFloat iconImageY = 100;
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH)];
//    titleLab.font = [UIFont systemFontOfSize:15];
//    titleLab.textColor = [UIColor whiteColor];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    [coverView addSubview:titleLab];
//    
//    
//    
//    // 绑定银行卡按钮
//    CGFloat  bindingBtnH = 44;
//    CGFloat  bindingBtnY = CGRectGetMaxY(titleLab.frame);
//    CGFloat  bindingBtnW = 200;
//    CGFloat  bindingBtnX = (BXSize.width - bindingBtnW) * 0.5;
//    UIButton *bindingBtn = [[UIButton alloc] initWithFrame:CGRectMake(bindingBtnX, bindingBtnY, bindingBtnW, bindingBtnH)];
//    bindingBtn.backgroundColor = BXColor(47, 166, 255, 255);
//    [bindingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [bindingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    bindingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    bindingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [bindingBtn.layer setMasksToBounds:YES];
//    [bindingBtn.layer setCornerRadius:5.0];
//    [coverView addSubview:bindingBtn];
//    titleLab.text = @"开通第三方支付账户享资金安全保障";
//    [bindingBtn setTitle:@"立即开通" forState:UIControlStateNormal];
//    [bindingBtn addTarget:self action:@selector(jumpThirdPartyWithBtntitle) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//}
//
//- (void)jumpThirdPartyWithBtntitle{

////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    [self postStartUserRegisterWithUserId:[defaults objectForKey:@"userId"]];
//}


#pragma mark - Table view data source

//
//- (void)fillInWithinvestClick:(BXInvestmentDetailModel *)element{
//
//    //是否显示红包相关控件
//    if (element) {
//        if ([element.prizeValue isEqualToString:@"-1"] && [element.prizeType isEqualToString:@"-1"]) {
//            self.redPactCell.hidden = YES;
//            self.actualPaymentCell.hidden = YES;
//        }else{
//            self.redPactCell.hidden = NO;
//            self.actualPaymentCell.hidden = NO;
//            // 红包
//            self.redEnvelope.text = self.redPact;
//            if ([element.prizeType isEqualToString:@"1"]) {
//                if (element.prizeValue) {
//                    self.redPactTypeLab.text = [NSString stringWithFormat:@"最大使用红包金额为:%@元",element.prizeValue];
//                }else{
//                    self.redPactTypeLab.text = @"可用红包";
//                }
//            }else if ([element.prizeType isEqualToString:@"2"]){
//                if (element.prizeValue) {
//                    self.redPactTypeLab.text = [NSString stringWithFormat:@"本次可用红包比例100:%g",[element.prizeValue floatValue]];
//                }else{
//                    self.redPactTypeLab.text = @"可用红包";
//                }
//
//            }
//        }
//    }else{
//        self.redPactCell.hidden = YES;
//        self.actualPaymentCell.hidden = YES;
//    }
//
////    // 标名称
////    self.titleLab.text = element.title;
////    // 期限
////    NSString *date = element.termCount;
////    if ([element.termUnit isEqualToString: @"3"]) {
////        self.financingPeriod.text = [NSString stringWithFormat:@"%@ 个月",date];
////        
////    }else if([element.termUnit isEqualToString: @"1"]){
////        self.financingPeriod.text = [NSString stringWithFormat:@"%@ 天",date];
////    }else if([element.termUnit isEqualToString: @"2"]){
////        self.financingPeriod.text = [NSString stringWithFormat:@"%@ 周",date];
////    }else if([element.termUnit isEqualToString: @"4"]){
////        self.financingPeriod.text = [NSString stringWithFormat:@"%@ 年",date];
////    }
////    
//
//    
//    //年化利率
////    self.yearsMoneyRate.text = [NSString stringWithFormat:@"%@%%",element.annualInterestRate];
//   // 项目可投金额
////    self.productMoney.text = [NSString stringWithFormat:@"%.2f",([element.amount floatValue] - [element.biddingAmount floatValue])];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *balance = [[NSString alloc]init];
//    
//    if(self.isOpen == YES)
//    {
//        balance = [defaults objectForKey:@"AvlBal"];
//    }
//    else
//    {
//        balance = @"0";
//    }
//    
//    NSString *accountStr = [NSString stringWithFormat:@"本人可用金额%@元",balance];

//    // 账户金额
//    self.accountBalance.text =  accountStr;
//    
////    self.investMoneyTextField.placeholder = [NSString stringWithFormat:@"起投金额%@元,递增金额%@元",element.beginAmount,element.increaseAmount];
//    
//}

// 投资
//- (IBAction)investmentClickBtn:(UIButton *)sender {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *avlBalStr = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
//    if (self.investMoneyTextField.text.length == 0) {
//        [MBProgressHUD showError:@"请输入投资金额"];
//    }else{
//        if ([NSString checkNumisWholeNumber:self.investMoneyTextField.text]) {
//
//            if (([self.element.amount intValue] - [self.element.biddingAmount intValue]) < [self.element.beginAmount intValue]) {
//                if ([self.investMoneyTextField.text intValue] > [avlBalStr floatValue]) {
//                    [MBProgressHUD showError:@"您的余额不足,请充值"];
//                }else if ([self.investMoneyTextField.text intValue] != ([self.element.amount intValue] - [self.element.biddingAmount intValue])) {
//                    [MBProgressHUD showError:@"剩余金额小于起投金额时需一笔投完"];
//                }
//                else{
//                    // 账号id  标id 投资金额
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    [self postStartInitiativeTenderWithLoanId:self.investDetailLoanId TransAmt:self.investMoneyTextField.text UserId:[defaults objectForKey:@"userId"]];
//                    
//                }
//
//            }
//            else if (([self.element.amount intValue] - [self.element.biddingAmount intValue]) < [self.element.increaseAmount intValue]) {
//                if ([self.investMoneyTextField.text intValue] > [avlBalStr floatValue]) {
//                    [MBProgressHUD showError:@"您的余额不足,请充值"];
//                }else if ([self.investMoneyTextField.text intValue] != ([self.element.amount intValue] - [self.element.biddingAmount intValue]))
//                {
//                    [MBProgressHUD showError:@"剩余金额小于递增金额时需一笔投完"];
//                }else{
//                    // 账号id  标id 投资金额
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    [self postStartInitiativeTenderWithLoanId:self.investDetailLoanId TransAmt:self.investMoneyTextField.text UserId:[defaults objectForKey:@"userId"]];
//                    
//                }
//            }else{
//                if ([self.investMoneyTextField.text doubleValue] > [avlBalStr floatValue]) {
//                    [MBProgressHUD showError:@"您的余额不足,请充值"];
//                }else if ([self.investMoneyTextField.text doubleValue] > ([self.element.amount doubleValue] - [self.element.biddingAmount doubleValue])) {
//                    [MBProgressHUD showError:@"投资金额不可大于项目可投金额"];
//                }else if ([self.investMoneyTextField.text doubleValue] < [self.element.beginAmount doubleValue]) {
//                    [MBProgressHUD showError:@"投资金额不可小于起投金额"];
//                }else if (([self.investMoneyTextField.text intValue] - [self.element.beginAmount intValue]) % [self.element.increaseAmount intValue]) {
//                    [MBProgressHUD showError:@"请输入符合递增规定的金额"];
//                }
//                else{
//                    // 账号id  标id 投资金额
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    [self postStartInitiativeTenderWithLoanId:self.investDetailLoanId TransAmt:self.investMoneyTextField.text UserId:[defaults objectForKey:@"userId"]];
//                    
//                    }
//                }
//            
//        }else{
//            [MBProgressHUD showError:@"请输入合法的投资金额"];
//        }
//        
//    }
//    
//}
//
//
//

#pragma mark UITextFieldDelegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    return YES;
//}
//
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 1;
//    }
//    return 15;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            return 110;
//        }
//    }else if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            if (self.element) {
//                if ([self.element.prizeValue isEqualToString:@"-1"] && [self.element.prizeType isEqualToString:@"-1"]) {
//                    return 0;
//                }else{
//                    return 70;
//                }
//            }else{
//                    return 0;
//            }
//        }else if(indexPath.row == 1){
//            return 44;
//        }else if(indexPath.row == 2){
//            if (self.element) {
//                if ([self.element.prizeValue isEqualToString:@"-1"] && [self.element.prizeType isEqualToString:@"-1"]) {
//                    return 0;
//                }else{
//                    return 30;
//                }
//            }else{
//                return 0;
//            }
//        }else if(indexPath.row == 3){
//            return 40;
//        }else if(indexPath.row == 4){
//            return 44;
//        }
//    }
//    return 0;
//}
//
//
//- (void)makeRoundButton:(UIButton *)btn{
//    [btn.layer setCornerRadius:5];
//    [btn.layer setMasksToBounds:YES];
//}

//-(void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type{
//
//    if (isSuccess) {
//        if (type == MPPayTypeOpenAccount) { // 开户
//
//            [MBProgressHUD showSuccess:@"开户成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            
//        }else if(type == MPPayTypeInvestment || type == MPPayTypeInvestmentWithRedPact){// 投资
//            [MBProgressHUD showSuccess:@"投资成功"];
//            
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////            NSString *balance = [defaults objectForKey:@"AvlBal"];
//             NSString *balance = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
//            int cashMoney =  ([balance floatValue] - [self.investMoneyTextField.text intValue]);
//            NSString *string = [NSString stringWithFormat:@"%d",cashMoney];
//            [defaults setObject:string forKey:@"AvlBal"];
//            
//            NSDictionary *dict = @{@"investSuccess" : @"YES"};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"investClickSuccess" object:nil userInfo:dict];
//            
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
////            [self.navigationController popToRootViewControllerAnimated:YES];
//
//        }
//        
//    }else{
//        [MBProgressHUD showMessage:message delayTime:1];
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }
//}
//
///** POST获取用户信息 **/
//- (void)postAccountInfo
//{
//    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
//    info.serviceString = BXRequestAccountInfo;
//    info.dataParam = @{@"vobankIdTemp":@""};
//    
//    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
//        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];

//        BXAccountAssetsVC *accountUser = [BXAccountAssetsVC  objectWithKeyValues:dict[@"body"]];
//        if ([accountUser.cash doubleValue] > 0) {
//            NSString *accountStr = [NSString stringWithFormat:@"本人可用金额%@元",accountUser.cash];
//            
//            self.accountBalance.text = accountStr;
//        }else{
//            self.accountBalance.text = @"本人可用金额0.00元";
//        }
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:accountUser.cash forKey:@"AvlBal"];
//        
//        [self.tableView.header endRefreshing];
//
//        
//    } faild:^(NSError *error) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            // 3.干倒菊花
//            [self.tableView.header endRefreshing];
//            [MBProgressHUD showError:@"网络异常,请检查网络"];
//        });
//    }];
//}
//
///**
// * post投资
// **/
//- (void)postStartInitiativeTenderWithLoanId:(NSString *)loanId TransAmt:(NSString *)transAmt UserId:(NSString *)userId
//{
//    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
//    info.serviceString = BXRequestInitiativeTender;
//    
//    
//    //红包使用金额
//    float redPactNum = [self.investMoneyTextField.text doubleValue] - [self.actualPayment.text doubleValue];
//    NSString *redPactStr = [NSString stringWithFormat:@"%.2f",redPactNum];
//    if (self.checkboxButton.selected == YES) {
//        if (redPactNum) {
//            info.dataParam = @{@"loanId":loanId,@"transAmt":transAmt,@"userId":userId,@"redPact":redPactStr,@"vobankIdTemp":@""};
//        }else{
//            info.dataParam = @{@"loanId":loanId,@"transAmt":transAmt,@"userId":userId,@"vobankIdTemp":@""};
//        }
//    }else{
//        info.dataParam = @{@"loanId":loanId,@"transAmt":transAmt,@"userId":userId,@"vobankIdTemp":@""};
//    }
//    
//    
//    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
//        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];

//
//        BXWebRequesetInfo *info = [BXWebRequesetInfo objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
//        
//        NSString *borrowerDetailsStr = dict[@"body"][@"payReqToThird"][@"borrowerDetails"];
//        NSRange range =  NSMakeRange(1, borrowerDetailsStr.length - 2);
//        borrowerDetailsStr = [borrowerDetailsStr substringWithRange:range];
//        if (borrowerDetailsStr) {
//            NSDictionary *dic = [self parseJSONStringToNSDictionary:borrowerDetailsStr];
//            info.borrowerDetails = [BXBorrowerDetails objectWithKeyValues:dic];
//            
//            NSString *reqExt = dict[@"body"][@"payReqToThird"][@"reqExt"];
//            //附带红包才执行
//            if (reqExt) {
//                NSDictionary *reqExtDic = [self parseJSONStringToNSDictionary:reqExt];
//                info.vocher = [BXVocher objectWithKeyValues:reqExtDic[@"Vocher"]];
//            }
//            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
//            JumpThirdParty.title = @"立即投资";
//            JumpThirdParty.payDelegate = self;
//            JumpThirdParty.info = info;
//            if (self.checkboxButton.selected == YES) {
//                if ([self.investMoneyTextField.text doubleValue] - [self.actualPayment.text doubleValue]) {
//                    JumpThirdParty.payType = MPPayTypeInvestmentWithRedPact;
//                }else{
//                    JumpThirdParty.payType = MPPayTypeInvestment;
//                }
//            }else{
//                JumpThirdParty.payType = MPPayTypeInvestment;
//            }
//            [self.navigationController pushViewController:JumpThirdParty animated:YES];
//        }else{
//            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
//        
//        }
//        
//        
//        
//    } faild:^(NSError *error) {
//        BXLOG(@"%@",error);
//    }];
//}
//
//
////字符串转字典
//- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
//    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//    return responseJSON;
//}
//
///** post开通账户**/
//- (void)postStartUserRegisterWithUserId:(NSString *)userId
//{
//    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
//    info.serviceString = BXRequestUserRegister;
//    info.dataParam = @{@"userId":userId,@"vobankIdTemp":@""};
//    
//    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
//        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
//        

//        
//        BXWebRequesetInfo *info = [BXWebRequesetInfo objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
//        
//        BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
//        JumpThirdParty.title = @"开通第三方账户";
//        JumpThirdParty.payDelegate = self;
//        JumpThirdParty.info = info;
//        JumpThirdParty.payType = MPPayTypeOpenAccount;
//        [self.navigationController pushViewController:JumpThirdParty animated:YES];
//        
//    } faild:^(NSError *error) {
//        BXLOG(@"%@",error);
//    }];
//}



@end
