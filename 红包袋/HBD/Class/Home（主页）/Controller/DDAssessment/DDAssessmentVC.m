//
//  DDAssessmentVC.m
//  HBD
//
//  Created by hongbaodai on 17/5/5.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//  评估结果

#import "DDAssessmentVC.h"
#import "SZQuestionCheckBox.h"
#import "DDRiskAssessViewController.h"
#import "BXDebentureControllerNew.h"
#import "DDHomeVC.h"
#import "DDInvestListVC.h"
#import "BXMyAccountController.h"
#import "HXMoreFindVC.h"
#import "DDRiskPopView.h"
#import "HXRiskAssessModel.h"
#import "DDAccount.h"

@interface DDAssessmentVC ()<DDRiskPopViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *styleImg;

@property (weak, nonatomic) IBOutlet UILabel *detailLab;

/** 重新评估 */
@property (weak, nonatomic) IBOutlet UIButton *reassessBtn;
/** 立即出借 */
@property (weak, nonatomic) IBOutlet HXButton *goloanBtn;

@property (nonatomic, assign) NSInteger scoreNum;
//-----风险控制相关--------
@property (nonatomic, strong) UIButton *assessBtn;
@property (nonatomic, strong) NSArray *assessArray;
@property (nonatomic, strong) NSMutableArray *questionsArr;
@property (nonatomic, strong) NSMutableArray *answersArr;
@property (nonatomic, strong) NSMutableArray *answerArr;
@property (nonatomic, strong) NSMutableArray *scoresArr;
@property (nonatomic, strong) NSMutableArray *tagNumArr;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *optionArray;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) SZQuestionCheckBox *questionBox;
@property (nonatomic, strong) DDRiskAssessViewController *riskController;
//-----风险控制相关--------


@end

@implementation DDAssessmentVC
/*
 0-59  保守型
 您期望在风险较低的情况下，获得稳定的资产保值功能，追求出借金额的安全性。建议出借额度：5万元。
 60-69  稳健型
 您的风险承受能力高于保守型出借者，能接受小幅度的出借损失。建议选择低风险产品，出借额度：50万元。
 70-79  平衡型
 您善于均衡配置资产，具有一定的风险承受能力，同时追求较高收益。建议出借额度：100万元。
 80-89  进取型
 您对出借逾期利息要求相对较高，且拥有较高的风险承受能力，可适当配置高风险产品。建议出借额度：300万元。
 90-100 激进型
 您的风险承受能力非常高，资产配置可选择高风险品种，在短周期内获得最大化收益。建议出借额度：500万元。
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    self.title = @"风险承受能力";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addBackItemWithAction];
    
    self.detailLab.numberOfLines = 0;
    self.detailLab.font = [UIFont systemFontOfSize:14.0f];
    [self.reassessBtn addTarget:self action:@selector(reassessBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.goloanBtn addTarget:self action:@selector(goloanBtnClick) forControlEvents:UIControlEventTouchUpInside];

    self.reassessBtn.layer.cornerRadius = 22;
    self.reassessBtn.layer.masksToBounds = YES;
    [self.reassessBtn setBackgroundImage:[UIImage imageNamed:@"yellowBack"] forState:UIControlStateNormal];
    [self.reassessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.scoreNum = self.pathScore;
    
    [self addAlertView]; //🚫🚫🚫如果平台合规和风险评估合并一起，则这个需要打开
    
    [self addRiskAssess];
}

- (void)addAlertView
{
    DDAccount *account = [DDAccount sharedDDAccount];
    if (([self.dic[@"couponValue"] intValue] != 0)){ // 没有评估过
        NSString *str = [NSString stringWithFormat:@"%@元",self.dic[@"couponValue"]];
        DDRiskPopView  *rView = [[DDRiskPopView alloc] initWithImage:@"risk_lipn" Title:str BtnImg:@"risk_bt-sy"];
        rView.delegate = self;

        account.levelName = self.dic[@"levelName"];
    }
}

- (void)didClickNowRiskBtn
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:DDKeyLoginState];
    int numint = [num intValue];
    if (numint == 1) {
        [tabBarVC loginStatusWithNumber:3];
    } else {
        [tabBarVC loginStatusWithNumber:0];
    }
    tabBarVC.selectedIndex = 1;
}

//自定义返回
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
}

- (void)doBack
{
 
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isMemberOfClass:[BXDebentureControllerNew class]]) {
            
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
        
    }
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
 
        if ([temp isMemberOfClass:[DDHomeVC class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        if ([temp isMemberOfClass:[DDInvestListVC class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        if ([temp isMemberOfClass:[BXMyAccountController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        if ([temp isMemberOfClass:[HXMoreFindVC class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        
    }
}

- (void)addRiskAssess
{
    self.answersArr = [NSMutableArray array];
    self.answerArr = [NSMutableArray array];
    self.scoresArr = [NSMutableArray array];
    self.tagNumArr = [NSMutableArray array];
    
    for (int i = 0; i < self.assessArray.count; i++) {
        //答案数组
        NSString *str = self.assessArray[i][@"answers"];
        
        [self.answersArr addObject:str];
        //答案数组
        [self.answerArr addObject:[[self.answersArr objectAtIndex:i] valueForKey:@"answer"]];
        //分数数组
        [self.scoresArr addObject:[[self.answersArr objectAtIndex:i] valueForKey:@"score"]];
        //标识数组
        [self.tagNumArr addObject:[[self.answersArr objectAtIndex:i] valueForKey:@"tagNum"]];
    }
    
    self.titleArray = (NSArray *)self.questionsArr;
    self.optionArray = (NSArray *)self.answerArr;
}

- (void)reassessBtnClick
{
//    [self.navigationController popViewControllerAnimated:YES];
    SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:self.titleArray andOptionArray:self.optionArray andResultArray:self.resultArray andQuestonType:SZQuestionSingleChoice];
    
    //DIY样式
    SZConfigure *configure = [[SZConfigure alloc] init];
    configure.titleSideMargin = 20;
    configure.optionSideMargin = 25;
    configure.titleFont = 13;
    configure.optionFont = 13;
    configure.buttonSize = 20;
    configure.topDistance = 10;
    configure.checkedImage = @"ass_sel";
    configure.unCheckedImage = @"ass_nor";
    configure.buttonSize = 30;
    configure.oneLineHeight = 35;
    configure.titleTextColor = COLOUR_BTN_BLUE_TITELCOLOR;
    configure.optionTextColor = [UIColor darkGrayColor];
    configure.backColor = [UIColor clearColor];
    
    self.riskController = [[DDRiskAssessViewController alloc] initWithItem:item andConfigure:configure];
    
    self.riskController.pathScoreArr = self.scoresArr;
    self.riskController.pathTagNumArr = self.tagNumArr;
    [self.navigationController pushViewController:self.riskController animated:YES];
}

- (void)goloanBtnClick
{
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:1];
    tabBarVC.selectedIndex = 1;
}

//----------风险控制相关-------------
/** 获取用户绑卡信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
  
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            if (dict[@"body"][@"levelName"]) {
                //风险评估类型
                if ([dict[@"body"][@"levelName"] isEqualToString:@"保守型"]){
                    //0-59  保守型
                    self.styleImg.image = IMG(@"ass_bsx");
                } else if ([dict[@"body"][@"levelName"] isEqualToString:@"稳健型"]){
                    //60-69  稳健型
                    self.styleImg.image = IMG(@"ass_wjx");
                } else if ([dict[@"body"][@"levelName"] isEqualToString:@"平衡型"]){
                    //70-79  平衡型
                    self.styleImg.image = IMG(@"ass_phx");
                } else if ([dict[@"body"][@"levelName"] isEqualToString:@"进取型"]){
                    //80-89  进取型
                    self.styleImg.image = IMG(@"ass_jqx");
                }else if ([dict[@"body"][@"levelName"] isEqualToString:@"激进型"]){
                    //90-100 激进型
                    self.styleImg.image = IMG(@"ass_jjx");
                }else { }
            } else {
                self.styleImg.image = IMG(@"ass_bsx");
            }
            
            if (dict[@"body"][@"levelDesc"]) {
                
                NSAttributedString *att = [self attributedStr:[NSString stringWithFormat:@"%@",dict[@"body"][@"levelDesc"]]];
                self.detailLab.attributedText = att;
            } else {
                self.detailLab.attributedText = [self attributedStr:@"您期望在风险较低的情况下，获得稳定的资产保值功能，追求出借金额的安全性。建议出借额度：5万元。"];
            }
            
        }else{
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
    } faild:^(NSError *error) {}];
}

- (NSMutableAttributedString *)attributedStr:(NSString *)str
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    

    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return att;
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self postUserBankCardInfo];
}

/**
 创建DDAssessmentVC
 
 @return DDAssessmentVC
 */
+ (instancetype)creatVCFromStroyboard
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDAssessmentVC" bundle:nil];
    DDAssessmentVC * assVc = [sb instantiateInitialViewController];
    return assVc;
}


#pragma mark - getter
- (NSArray *)assessArray
{
    if (_assessArray == nil) {
        _assessArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AssessPlist.plist" ofType:nil]];
    }
    return _assessArray;
}

- (NSMutableArray *)questionsArr
{
    if (_questionsArr == nil) {
        _questionsArr = [NSMutableArray array];

        for (int i = 0; i < self.assessArray.count; i++) {

            NSString *str = self.assessArray[i][@"qusetion"];

            [_questionsArr addObject:str];
        }
    }
    return _questionsArr;
}

- (NSMutableArray *)answersArr
{
    if (_answersArr == nil) {
        _answersArr = [NSMutableArray array];

        for (int i = 0; i < self.assessArray.count; i++) {

            NSString *str = self.assessArray[i][@"answers"];

            [_answersArr addObject:str];
        }
    }
    return _answersArr;
}

- (NSMutableArray *)answerArr
{
    if (_answerArr == nil) {
        _answerArr = [NSMutableArray array];

        for (int i = 0; i < self.assessArray.count; i++) {

            NSString *str = self.assessArray[i][@"answer"];

            [_answerArr addObject:str];
        }
    }
    return _answerArr;
}

- (NSMutableArray *)tagNumArr
{
    if (_tagNumArr == nil) {
        _tagNumArr = [NSMutableArray array];
        for (int i = 0; i < self.assessArray.count; i++) {
            NSString *str = self.assessArray[i][@"tagNum"];
            [_tagNumArr addObject:str];
        }
    }
    return _tagNumArr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end








