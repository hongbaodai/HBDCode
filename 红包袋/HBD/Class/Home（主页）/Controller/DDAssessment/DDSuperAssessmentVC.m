//
//  DDSuperAssessmentVC.m
//  HBD
//
//  Created by hongbaodai on 2017/5/16.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDSuperAssessmentVC.h"
#import "DDAssessmentVC.h"
#import "SZQuestionCheckBox.h"
#import "DDRiskAssessViewController.h"
#import "BXAccountAssetsVC.h"
#import "DDAccount.h"


@interface DDSuperAssessmentVC ()

@property (nonatomic, copy) NSString *loanStyle;

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

@implementation DDSuperAssessmentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    self.view.backgroundColor = [UIColor colorWithHex:@"FAFAFA"];
    
    [self addRiskAssess];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //添加风险评估按钮
    [self addAssessBtn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.loanStyle = [defaults objectForKey:@"khfs"];
    if ([self.loanStyle isEqualToString:@"2"]) { //1个人 2企业借款
        [self.assessBtn removeFromSuperview];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除
    [self.assessBtn removeFromSuperview];
}


#pragma mark - 添加风险评估
- (void)addAssessBtn
{
    /////assesss
    CGFloat btnw = 40;
    CGFloat butY = SCREEN_HEIGHT - 48 - btnw;
    if (IS_iPhoneX) {
        butY = SCREEN_HEIGHT - 49 - 34 -btnw;
    }
    self.assessBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnw-8, butY, btnw, btnw)];
    [self.assessBtn setImage:IMG(@"ass_fxpg") forState:UIControlStateNormal];
    [self.assessBtn addTarget:self action:@selector(assessBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:self.assessBtn];
}

- (void)assessBtnClick
{
    HXTabBarViewController * tabBarVC = (HXTabBarViewController *)self.tabBarController;
    if (tabBarVC.bussinessKind) {
        
        //-----用web页面-----
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDRiskAssessVC" bundle:nil];
        //        DDRiskAssessVC *riVc = [sb instantiateInitialViewController];
        //        [self.navigationController pushViewController:riVc animated:YES];
        //        //-----自己代码-----
        [self initQuestionVC];
        
    } else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXLoginView" bundle:nil];
        BXLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.isPresentedWithMyAccount = 0;
        BXNavigationController *Nav = [[BXNavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

- (void)initQuestionVC
{
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
    // Dispose of any resources that can be recreated.
}



@end

