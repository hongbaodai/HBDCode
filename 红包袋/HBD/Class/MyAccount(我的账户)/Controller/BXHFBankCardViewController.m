//
//  BXHFBankCardViewController.m
//  ump_xxx1.0
//
//  Created by echo on 15/11/27.
//  Copyright (c) 2015年 李先生. All rights reserved.
//   充值 第二步 快捷充值银行

#import "BXHFBankCardViewController.h"
#import "BankcardTableViewCell.h"
#import "QuotaImageTableViewCell.h"
#import "PrompttextViewCell.h"
#import "QuickrechargeTableViewCell.h"
#import "MYAlertView.h"
#import "BXJumpThirdPartyController.h"
#import "BXRechargeSuccessController.h"
#import "BXRechargeFailureController.h"
#import "UIImageView+WebCache.h"

@interface BXHFBankCardViewController ()<MYALertviewDelegate,PayThirdPartyProtocol, SDWebImageManagerDelegate>
{
    UIButton *_Quickrechargebtn;  //目前只支持快捷支付
    UIButton *_Personalbtn;  //暂不用
    UIButton *_Compnybtn;   //暂不用
    UILabel *_banknamelable;
    NSString *_bankname;
    NSString *_telnumberstr;
    UIButton *_clickwatchbtn; //
    
    //    快捷银行电话数组
    NSMutableArray *_Quicknumberarr;
    //    个人银行电话数组
    NSMutableArray *_personnumberarr;
    //    企业银行电话数组
    NSMutableArray *_companynumberarr;
    //    银行电话中转数组
    NSMutableArray *_telnumberarr;
    
    
    //    按钮上得快捷支付图标
    UIImageView *_smalimage;
    //    快捷充值银行数组
    NSMutableArray *_Quickbankarr;
    //    个人网银充值银行数组
    NSMutableArray *_personbankarr;
    //    企业网银充值银行数组
    NSMutableArray *_companybankarr;
    //    中转数字
    NSMutableArray *_BankDataarr;
    //    按钮数组
    NSMutableArray *_buttonarr;
    //    限额个人图片名数组
    NSMutableArray *_xianearr;
    //    限额快捷图片名数组
    NSMutableArray *_Quickxianearr;
    //    限额企业图片名数组
    NSMutableArray *_Companyxianearr;
    
    //    快捷银行名称数组
    NSMutableArray *_qukckbanknamearr;
    //    个人银行名称数组
    NSMutableArray *_personbanknamearr;
    //    企业银行名称数组
    NSMutableArray *_companybanknamearr;
    //    银行名称中转数组
    NSMutableArray *_banknamearr;
    
    //    银行简称字典
    NSDictionary   *_bankAbbreviationDic;
    //    银行全程字典
    NSDictionary   *_bankFullnameDic;
    //    充值类型简称字典
    NSDictionary   *_rechargetypeDic;
    //    银行对应联系电话字典
    NSDictionary   *_bankPhoneNumDic;
    
    
    BOOL IsWatch;
}

@property (nonatomic, copy) NSString *bankimgStr;
@property (nonatomic, strong) UIImage *bankImg;

@end

@implementation BXHFBankCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"充值";
    
    [self initviewData];
    [self initBankData];
    [self postBankLimitAmountWithYhdm:self.BankId];
}

//   创建表头
- (void)BuildtableViewHeadView
{
    //    设置表头
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 246)];
    headview.backgroundColor=[UIColor colorWithWhite:0.97 alpha:1.000];
    //    设置背景蓝条
    UIView *bluebackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 181)];
    bluebackground.backgroundColor = COLOUR_BTN_BLUE;
    [headview addSubview:bluebackground];
    //    金额显示lab
    UILabel *labMoney=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 45)];
    labMoney.center = CGPointMake(SCREEN_SIZE.width / 2, 65 + 22);
    labMoney.text=[NSString stringWithFormat:@"%.2lf",[self.Moneystr doubleValue]];
    labMoney.textColor=[UIColor whiteColor];
    labMoney.textAlignment=NSTextAlignmentCenter;
    labMoney.font=[UIFont systemFontOfSize:50];
    [bluebackground addSubview:labMoney];
    //    金额下方文字
    UILabel *labtext=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, 110, 150, 30)];
    labtext.text=@"充值金额(元)";
    labtext.textColor=[UIColor whiteColor];
    labtext.textAlignment=NSTextAlignmentCenter;
    labtext.font=[UIFont systemFontOfSize:14];
    [bluebackground addSubview:labtext];
    
    
//    int w=([UIScreen mainScreen].bounds.size.width-20)/3;
    //    快捷充值按钮
    _Quickrechargebtn.frame=CGRectMake(10, 195, SCREEN_WIDTH-20, 40);
    //     _Quickrechargebtn.layer.cornerRadius=3;
    _Quickrechargebtn.layer.borderWidth = 0.5;
    _Quickrechargebtn.layer.borderColor = DDRGB(46, 178, 255).CGColor;
    _Quickrechargebtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [_Quickrechargebtn setTitle:@"快捷充值" forState:UIControlStateNormal];
    [_Quickrechargebtn addTarget:self action:@selector(ChoosePaymentmethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [_Quickrechargebtn addSubview:_smalimage];
    [headview addSubview:_Quickrechargebtn];
//    个人网银和企业网银充值暂不开通
//    //    个人网银充值按钮
//    _Personalbtn.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-(w/2)-1, 195, w + 7, 40);
//    //    _Personalbtn.layer.cornerRadius=3;
//    _Personalbtn.layer.borderWidth = 0.5;
//    _Personalbtn.layer.borderColor = DDRGB(46, 178, 255).CGColor;
//    _Personalbtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    
//    [_Personalbtn setTitle:@"个人网银充值" forState:UIControlStateNormal];
//    [_Personalbtn addTarget:self action:@selector(ChoosePaymentmethod:) forControlEvents:UIControlEventTouchUpInside];
//    [headview addSubview:_Personalbtn];
//    //    企业网银充值按钮
//    _Compnybtn.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width/2)+(w/2), 195, w + 2, 40);
//    //     _Compnybtn.layer.cornerRadius=3;
//    _Compnybtn.layer.borderWidth = 0.5;
//    _Compnybtn.layer.borderColor = DDRGB(46, 178, 255).CGColor;
//    _Compnybtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    [_Compnybtn setTitle:@"企业网银充值" forState:UIControlStateNormal];
//    [_Compnybtn addTarget:self action:@selector(ChoosePaymentmethod:) forControlEvents:UIControlEventTouchUpInside];
//    [headview addSubview:_Compnybtn];
//    [self Changebuttonstyle];
    //    把view赋值给表头
    self.tableViewBank.tableHeaderView=headview;
}

//创建表尾下一步按钮
-(void)BuildtableFooterView
{
    UIView *footerview=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-140, [UIScreen mainScreen].bounds.size.width, 95)];
    footerview.backgroundColor=[UIColor colorWithWhite:0.97 alpha:1.000];
    int w=[UIScreen mainScreen].bounds.size.width-20;
    _nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-(w/2), 10, w, 40)];
    _nextBtn.backgroundColor = COLOUR_BTN_BLUE;
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextstep) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.layer.cornerRadius=2;
    _nextBtn.enabled = YES;
    [footerview addSubview:_nextBtn];
    UILabel *wenzi=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, 53, 200, 20)];
    wenzi.text=@"银行存管，全面保障您的资金安全";
    wenzi.font=[UIFont systemFontOfSize:11];
    wenzi.textColor=[UIColor lightGrayColor];
    wenzi.textAlignment=NSTextAlignmentCenter;
    [footerview addSubview:wenzi];
    [self.view addSubview:footerview];
}

//下一步点击事件
-(void)nextstep
{
    if (_banknamelable.text.length) {
        if (self.IsFirst==YES&&[self.Rechargetype isEqualToString:@"快捷充值"]) { // 未绑定快捷充值
            MYAlertView *alert=[[MYAlertView alloc]initWithTitle:@"您设定的快捷卡将默认为您唯一的提现银行卡,是否设定该卡为唯一提现卡?" CancelButton:@"取消" OkButton:@"确定"];
            alert.delegate=self;
            alert.tag=1;
            [alert show];
        } else {
            /*
             这里写下一步充值方法********************************
             */
            [self postRechargeWithTransAmt:self.Moneystr GateBusiId:[_rechargetypeDic objectForKey:self.Rechargetype] OpenBankId:[_bankAbbreviationDic objectForKey:_bankname]];
            
        }
    } else if (self.IsFirst==NO&&[self.Rechargetype isEqualToString:@"快捷充值"]) { //已绑定快捷充值
        [MBProgressHUD showMessage:nil delayTime:5.0];
        [self postRechargeWithTransAmt:self.Moneystr GateBusiId:[_rechargetypeDic objectForKey:self.Rechargetype] OpenBankId:self.Bankname];
    } else {
        [MBProgressHUD showError:@"请选择银行"];
    }
}

-(void)myAlertView:(MYAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index
{
    if (index!=1) {
 
        [MBProgressHUD showMessage:nil delayTime:5.0];
        [self postRechargeWithTransAmt:self.Moneystr GateBusiId:[_rechargetypeDic objectForKey:self.Rechargetype] OpenBankId:[_bankAbbreviationDic objectForKey:_bankname]];
    }
}

#pragma mark -- tableViewData
//   设置区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.Rechargetype isEqualToString:@"快捷充值"]) {
        if (self.IsFirst==NO) {
            return 2;
        } else {
            return 3;
        }
    } else {
        return 2;
    }
}

//   设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        {
            if (self.IsFirst==NO&&[self.Rechargetype isEqualToString:@"快捷充值"]) {
                return 1;
            }else{
                return (_BankDataarr.count+2)/3;
            }
        }
    } else if (section==1){
        //   判断是否查看限额
        if (IsWatch==NO) {
            return 0;//隐藏第二个区
        } else {
            return 1;//显示第二个区
        }
    } else {
        return 1;
    }
}

//   设置单元格属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {//第一个区
        if (self.IsFirst==NO&&[self.Rechargetype isEqualToString:@"快捷充值"]) {//如果开通了快捷充值
            QuickrechargeTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
            cell.backgroundColor=[UIColor colorWithWhite:0.97 alpha:1.000];
            if (!cell)
            {
                cell=[[NSBundle mainBundle]loadNibNamed:@"QuickrechargeTableViewCell" owner:nil options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            // 设置已绑定快捷卡信息
            //银行名字
            cell.BankName.text=[_bankFullnameDic objectForKey:self.Bankname];
            //银行logo
            cell.BankLogoImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"银行标志_%@",[_bankFullnameDic objectForKey:self.Bankname]]];
            //银行尾号
            if (self.BankCardNumber.length > 4) {
                cell.FootCardnumber.text=[self.BankCardNumber substringFromIndex:self.BankCardNumber.length - 4];
            } else {
                cell.FootCardnumber.text = @"0000";
            }
            return  cell;
        } else {
            //如果没有开通快捷充值
            BankcardTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
            cell.backgroundColor=[UIColor colorWithWhite:0.97 alpha:1.000];
            if (!cell)
            {
                cell=[[NSBundle mainBundle]loadNibNamed:@"BankcardTableViewCell" owner:nil options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (int i = 0; i < 3; i ++) {
                UIView* view = [cell viewWithTag:99];
                if (view) {
                    [view removeFromSuperview];
                }
            }
            [cell.button1 setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.button2 setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.button3 setBackgroundImage:nil forState:UIControlStateNormal];
            int count = (int)indexPath.row * 3;
            for (int i = 0; i < 3; i ++)
            {
                //            加个判断
                if ((count + i) >= _BankDataarr.count) {
                    break;
                }
                UIButton* button = nil;
                switch (i) {
                    case 0:
                        //第一个button赋值
                    {
                        button = cell.button1;
                    }
                        break;
                    case 1:
                        //第二个button赋值
                    {
                        button = cell.button2;
                    }
                        break;
                    case 2:
                        //第三个button赋值
                    {
                        button = cell.button3;
                    }
                        break;
                    default:
                            break;
                }
                button.tag =count+i;
                button.selected=NO;
                [_buttonarr addObject:button];
                NSString *imagename=[NSString stringWithFormat:@"%@",[_BankDataarr objectAtIndex:button.tag]];
                [button setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickbankbtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            return  cell;
        }
    } else if (indexPath.section==1){//第二个区
        QuotaImageTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor=[UIColor colorWithWhite:0.97 alpha:1.000];
        if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"QuotaImageTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //注意此处不能用sd缓存策略，会导致图片不更新
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.bankimgStr]];
        cell.image.image  = [UIImage imageWithData: imageData];
        
        cell.tellab.text=_telnumberstr;
        
        return  cell;
    } else {//第三个区
        PrompttextViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor=[UIColor colorWithWhite:0.97 alpha:1.000];
        if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"PrompttextViewCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  cell;
    }
}

//设置区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    } else {
        return 0;
    }
}

//设置区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *clickwatch=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        clickwatch.backgroundColor=[UIColor colorWithWhite:0.96 alpha:1.000];
        
        //        显示银行名
        _banknamelable.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-120, 14, 120, 16);
        _banknamelable.textColor=[UIColor colorWithRed:0.961 green:0.439 blue:0.106 alpha:1.000];
        _banknamelable.text=_bankname;
        _banknamelable.font=[UIFont systemFontOfSize:13];
        _banknamelable.textAlignment=NSTextAlignmentRight;
        [clickwatch addSubview:_banknamelable];
        
        //     查看限额按钮
        
        if (_banknamelable.text.length) {
            _clickwatchbtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 14, 60, 16);
        } else {
            _clickwatchbtn.frame = CGRectMake(0, 0, 0, 0);
        }
        // 页面有显示 支付限额 bug 先设为空试试
        [_clickwatchbtn setTitle:@"支付限额" forState:UIControlStateNormal];
        [_clickwatchbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _clickwatchbtn.titleLabel.font=[UIFont systemFontOfSize:13];
//        [_clickwatchbtn addTarget:self action:@selector(watchtableClick) forControlEvents:UIControlEventTouchUpInside];
        [clickwatch addSubview:_clickwatchbtn];
        return clickwatch;
    } else {
        //    把第一个区头去掉
        UIView *clickwatch=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        return clickwatch;
    }
}

//点击查看限额按钮
-(void)watchtableClick
{
    IsWatch=!IsWatch;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableViewBank reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if(self.IsFirst==NO&&[self.Rechargetype isEqualToString:@"快捷充值"])
        {
            return 170;
        } else {
            
            int width=([UIScreen mainScreen].bounds.size.width-20)/3*0.565;
            return width;
        }
    }
    else if (indexPath.section==1){
    
        return 120;
    }
else {
        return 200;
    }
}

//点击每个银行logo按钮
-(void)clickbankbtn:(UIButton *)btn
{
    for (UIButton *selectbtn in _buttonarr) {
        if (selectbtn.tag==btn.tag) {
            selectbtn.selected=YES;
        } else {
            selectbtn.selected=NO;
            
        }
        if (selectbtn.selected==YES) {
            
            [selectbtn setImage:[UIImage imageNamed:@"充值选中银行状态角标"] forState:UIControlStateNormal];
            _clickwatchbtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, 60, 30);
            
        } else {
            [selectbtn setImage:nil forState:UIControlStateNormal];
        }
    }
    
  
    _banknamelable.text=_bankname;
    
    IsWatch=NO;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    
    [self.tableViewBank reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self watchtableClick];
}


- (void)initviewData
{
    //    初始化三个按钮
    _Quickrechargebtn=[[UIButton alloc]init];
    _clickwatchbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _smalimage=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 30, 10)];
    _Quickrechargebtn.tag=1;
    self.tableViewBank.backgroundColor=[UIColor colorWithWhite:0.97 alpha:1.000];
    _Personalbtn=[[UIButton alloc]init];
    _Personalbtn.tag=2;
    _Compnybtn=[[UIButton alloc]init];
    _buttonarr=[[NSMutableArray alloc]init];
    _Compnybtn.tag=3;
    _banknamelable=[[UILabel alloc]init];
    
//    _Quotaimage=[[UIImage alloc]init];
    //    去掉表多余行
    self.tableViewBank.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    去掉单元格下划线
    self.tableViewBank.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.navigationController.automaticallyAdjustsScrollViewInsets = false;
}

//   选择支付方式
-(void)ChoosePaymentmethod:(UIButton *)btn
{
    switch (btn.tag) {
        case 1://快捷充值
        {
            _Quickrechargebtn.selected=YES;
            _Personalbtn.selected=NO;
            _Compnybtn.selected=NO;
            _bankname=@"";
            _banknamelable.frame = CGRectMake(0, 0, 0, 0);
            _clickwatchbtn.frame = CGRectMake(0, 0, 0, 0);
            _bankname=[_bankFullnameDic objectForKey:self.Bankname];
            _telnumberstr=[NSString stringWithFormat:@"%@",[_bankPhoneNumDic objectForKey:_bankname]];

            _banknamelable.text=_bankname;
            IsWatch=NO;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            
            [self.tableViewBank reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self watchtableClick];
            
        }
            break;
        case 2://个人网银充值
        {
            _Quickrechargebtn.selected=NO;
            _Personalbtn.selected=YES;
            _Compnybtn.selected=NO;
            IsWatch=NO;
            _bankname=@"";
            _clickwatchbtn.frame = CGRectMake(0, 0, 0, 0);
        }
            break;
        case 3://企业网银充值
        {
            _Quickrechargebtn.selected=NO;
            _Personalbtn.selected=NO;
            _Compnybtn.selected=YES;
            IsWatch=NO;
            _bankname=@"";
            _clickwatchbtn.frame = CGRectMake(0, 0, 0, 0);
        }
            break;
            
        default:
            break;
    }
    self.Rechargetype=btn.titleLabel.text;
    if ([self.Rechargetype isEqualToString:@"个人网银充值"]) {
        _BankDataarr=_personbankarr;
        _banknamearr=_personbanknamearr;
        _telnumberarr=_personnumberarr;
    }
    else if([self.Rechargetype isEqualToString:@"企业网银充值"]){
        _BankDataarr=_companybankarr;
        _banknamearr=_companybanknamearr;
        _telnumberarr=_companynumberarr;
        
    } else {
        _BankDataarr=_Quickbankarr;
        _banknamearr=_qukckbanknamearr;
        _telnumberarr=_Quicknumberarr;
    }
    [self Changebuttonstyle];
    [self.tableViewBank reloadData];
    
}

//   改变按钮后按钮样式
-(void)Changebuttonstyle
{
    if (_Quickrechargebtn.selected==YES) {
        _Quickrechargebtn.backgroundColor=[UIColor colorWithRed:0.125 green:0.522 blue:0.996 alpha:1.000];
        [_Quickrechargebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _smalimage.image=[UIImage imageNamed:@"快捷充值_02"];
    }else{
        _Quickrechargebtn.backgroundColor=[UIColor whiteColor];
        [_Quickrechargebtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _smalimage.image=[UIImage imageNamed:@"快捷充值_01"];
        
    }
    if (_Personalbtn.selected==YES) {
        _Personalbtn.backgroundColor=[UIColor colorWithRed:0.125 green:0.522 blue:0.996 alpha:1.000];
        [_Personalbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        _Personalbtn.backgroundColor=[UIColor whiteColor];
        [_Personalbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    if (_Compnybtn.selected==YES) {
        _Compnybtn.backgroundColor=[UIColor colorWithRed:0.125 green:0.522 blue:0.996 alpha:1.000];
        [_Compnybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        _Compnybtn.backgroundColor=[UIColor whiteColor];
        [_Compnybtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - POST
-(void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    
    if (isSuccess) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *balance = [[defaults objectForKey:@"AvlBal"] stringByReplacingOccurrencesOfString :@"," withString:@""];
            NSString *string = [NSString stringWithFormat:@"%.2lf",[balance doubleValue] + [self.Moneystr doubleValue]];
            [defaults setObject:string forKey:@"AvlBal"];
            
            NSDictionary *dict = @{@"rechargeSuccess" : @"YES"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeSuccess" object:nil userInfo:dict];
            
            BXRechargeSuccessController *next = [[BXRechargeSuccessController alloc]init];
            [self.navigationController pushViewController:next animated:YES];

        
    } else {
        
        BXRechargeFailureController *next = [[BXRechargeFailureController alloc]init];
        next.responseMsg = message;
        [self.navigationController pushViewController:next animated:YES];
    }
}

/** post充值**/
- (void)postRechargeWithTransAmt:(NSString *)transAmt GateBusiId:(NSString *)gateBusiId OpenBankId:(NSString *)openBankId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"transAmt":transAmt, @"GateBusiId":gateBusiId, @"OpenBankId":openBankId, @"rtUrl":@"/m/commons/pages/callback.html", @"payWay":@"SWIFT", @"from":@"M"};
//    info.serviceString = DDRequestRecharge;
    info.serviceString = DDRequestlmRecharge;
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        _nextBtn.enabled = NO;
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.title = @"充值";
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            JumpThirdParty.payType = MPPayTypeHKBank;
            [self.navigationController pushViewController:JumpThirdParty animated:YES];
            
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
            
        }
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

/** post获取银行限额详情**/
- (void)postBankLimitAmountWithYhdm:(NSString *)Yhdm
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestBankLimit;
    info.dataParam = @{@"YHDM":Yhdm, @"from":@"M"};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
  
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            NSDictionary *dic = [dict[@"body"][@"limitInfos"] firstObject];

            
           NSString *urlstr = [self getImageUrlWithFilePath:dict[@"body"][@"filePath"] PictureStr:dic[@"XETP_APP"]];//图片
            
            self.bankimgStr = urlstr;

        } else {
        }
        [self.tableViewBank reloadData];
        
    } faild:^(NSError *error) {

    }];
}

//转换成url格式
- (NSString *)getImageUrlWithFilePath:(NSString *)filePath PictureStr:(NSString *)str
{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/p2p/SourcePortal?", BXNETURL];
    NSString *path = [NSString stringWithFormat:@"%@/bankInfo/%@",filePath,str];
    
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@service=%@&body={\"imgPath\":\"%@\"}",baseUrl,BXRequestCreatImage,path];
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    return url;
    return urlStr;
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    
    //    初始化三个按钮的点击状态
    _Quickrechargebtn.selected = YES; //快捷支付
    _Personalbtn.selected = NO; //个人网银
    _Compnybtn.selected = NO;   //企业网银
    IsWatch=NO;
    self.Rechargetype = @"快捷充值";
    [self BuildtableViewHeadView];
    [self BuildtableFooterView];
    [self.tableViewBank reloadData];
    [self ChoosePaymentmethod:_Quickrechargebtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 初始化数据界面
- (void)initBankData
{
    
    if (!_qukckbanknamearr) {
        _qukckbanknamearr=[NSMutableArray arrayWithObjects:@"中国银行", @"中国建设银行",@"中国光大银行",@"兴业银行",@"中信银行",@"上海银行",@"渤海银行",@"平安银行",@"中国邮政储蓄银行",@"浦东发展银行",@"中国工商银行",@"中国农业银行",@"招商银行",@"交通银行",@"中国民生银行",@"广发银行",@"北京银行",@"华夏银行",nil];
    }
    
    if (!_Quicknumberarr) {
        _Quicknumberarr=[NSMutableArray arrayWithObjects:@"95566", @"95533",@"95595",@"95561",@"95558",@"021-962888",@"4008888811",@"40066-99999",@"95580",@"95528",@"95588",@"95599",@"95555",@"95559",@"95568",@"95508",@"95526",@"95577",nil];
    }
    
    if (!_Quickbankarr) {
        _Quickbankarr=[NSMutableArray arrayWithObjects:@"银行标志_中国10", @"银行标志_建设05",@"银行标志_光大12",@"银行标志_兴业04",@"银行标志_中信20",@"银行标志_上海06",@"银行标志_渤海13",@"银行标志_平安17",@"银行标志_邮政19",@"银行标志_浦发15",@"银行标志_工商08",@"银行标志_农业07",@"银行标志_招商09",@"银行标志_交通14",@"银行标志_民生03",@"银行标志_广发21",@"银行标志_北京银行22",@"银行标志_华夏银行1",nil];
    }
    
    if (!_bankAbbreviationDic) {
        _bankAbbreviationDic=[NSDictionary dictionaryWithObjectsAndKeys:
                              @"ABOC",@"中国农业银行",
                              @"BOC",@"中国银行",
                              @"CCB",@"中国建设银行",
                              @"CEB",@"中国光大银行",
                              @"CIB",@"兴业银行",
                              @"CITIC",@"中信银行",
                              @"BOS",@"上海银行",
                              @"CBHB",@"渤海银行",
                              @"SPAN",@"平安银行",
                              @"PSBC",@"中国邮政储蓄银行",
                              @"SPDB",@"浦东发展银行",
                              @"BJRCB",@"北京农村商业银行",
                              @"COMM",@"交通银行",
                              @"CMB",@"招商银行",
                              @"ICBC",@"中国工商银行",
                              @"SDB",@"深圳发展银行",
                              @"CMBC",@"中国民生银行",
                              @"FDB",@"富滇银行",
                              @"SRCB",@"上海农村商业银行",
                              @"GDB",@"广发银行",
                              @"BJCN",@"北京银行",
                              @"HXBK",@"华夏银行",nil];
    }
    
    if (!_bankFullnameDic) {
        _bankFullnameDic=[NSDictionary dictionaryWithObjectsAndKeys:
                          @"中国农业银行",@"ABOC",
                          @"中国银行",@"BOC",
                          @"中国建设银行",@"CCB",
                          @"中国光大银行",@"CEB",
                          @"兴业银行",@"CIB",
                          @"中信银行",@"CITIC",
                          @"上海银行",@"BOS",
                          @"渤海银行",@"CBHB",
                          @"平安银行",@"SPAN",
                          @"中国邮政储蓄银行",@"PSBC",
                          @"浦东发展银行",@"SPDB",
                          @"北京农村商业银行",@"BJRCB",
                          @"交通银行",@"COMM",
                          @"招商银行",@"CMB",
                          @"中国工商银行",@"ICBC",
                          @"深圳发展银行",@"SDB",
                          @"中国民生银行",@"CMBC",
                          @"富滇银行",@"FDB",
                          @"上海农村商业银行",@"SRCB",
                          @"广发银行",@"GDB",
                          @"北京银行",@"BJCN",
                          @"华夏银行",@"HXBK",nil];
    }
    
    if (!_bankPhoneNumDic) {
        _bankPhoneNumDic=[NSDictionary dictionaryWithObjectsAndKeys:
                          @"95599",@"中国农业银行",
                          @"95566",@"中国银行",
                          @"95533",@"中国建设银行",
                          @"95595",@"中国光大银行",
                          @"95561",@"兴业银行",
                          @"95558",@"中信银行",
                          @"021-962888",@"上海银行",
                          @"4008888811",@"渤海银行",
                          @"40066-99999",@"平安银行",
                          @"95580",@"中国邮政储蓄银行",
                          @"95528",@"浦东发展银行",
                          @"96198",@"北京农村商业银行",
                          @"95559",@"交通银行",
                          @"95555",@"招商银行",
                          @"95588",@"中国工商银行",
                          @"95501",@"深圳发展银行",
                          @"95568",@"中国民生银行",
                          @"400-889-6533",@"富滇银行",
                          @"4006962999",@"上海农村商业银行",
                          @"95508",@"广发银行",
                          @"95526",@"北京银行",
                          @"95577",@"华夏银行", nil];
    }
    
    if (!_personnumberarr) {
        _personnumberarr=[NSMutableArray arrayWithObjects:@"021-962888", @"95533",@"95595",@"95561",@"95588",@"95580",@"4006962999",nil];
    }
    
    if (!_companynumberarr) {
        _companynumberarr=[NSMutableArray arrayWithObjects:@"95559",@"95533",nil];
    }
    
    if (!_personbanknamearr) {
        _personbanknamearr=[NSMutableArray arrayWithObjects:@"上海银行", @"中国建设银行",@"中国光大银行",@"兴业银行",@"中国工商银行",@"中国邮政储蓄银行",@"上海农村商业银行",nil];
    }
    
    if (!_companybanknamearr) {
        _companybanknamearr=[NSMutableArray arrayWithObjects:@"交通银行",@"中国建设银行",nil];
    }
    
    if (!_personbankarr) {
        _personbankarr=[NSMutableArray arrayWithObjects:@"银行标志_上海06", @"银行标志_建设05",@"银行标志_光大12",@"银行标志_兴业04",@"银行标志_工商08",@"银行标志_邮政19",@"银行标志_上海农商18",nil];
    }
    if (!_companybankarr) {
        _companybankarr=[NSMutableArray arrayWithObjects:@"银行标志_交通14",@"银行标志_建设05",nil];
    }
    
    if (!_rechargetypeDic) {
        _rechargetypeDic=[NSDictionary dictionaryWithObjectsAndKeys:@"QP",@"快捷充值",@"B2C",@"个人网银充值",@"B2B",@"企业网银充值", nil];
    }
    
    if (!_BankDataarr) {
        _BankDataarr=[[NSMutableArray alloc]init];
    }
    
    if (!_banknamearr) {
        _banknamearr=[[NSMutableArray alloc]init];
    }
    
    if (!_telnumberarr) {
        _telnumberarr=[[NSMutableArray alloc]init];
    }
    
    if ([self.Rechargetype isEqualToString:@"个人网银充值"]) {
        _BankDataarr=_personbankarr;
        _banknamearr=_personbanknamearr;
        _telnumberarr=_personnumberarr;
    } else if([self.Rechargetype isEqualToString:@"企业网银充值"]){
        _BankDataarr=_companybankarr;
        _banknamearr=_companybanknamearr;
        _telnumberarr=_companynumberarr;
        
    } else {
        _BankDataarr=_Quickbankarr;
        _banknamearr=_qukckbanknamearr;
        _telnumberarr=_Quicknumberarr;
        
    }
}


@end
