//
//  DDRiskAssessViewController.m
//  HBD
//
//  Created by hongbaodai on 2017/5/10.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
// 评估问卷

#import "DDRiskAssessViewController.h"
#import "DDAssessmentVC.h"
#import "DDRiskAssessHeadView.h"
#import "BXDebentureControllerNew.h"
#import "DDHomeVC.h"
#import "DDInvestListVC.h"
#import "BXMyAccountController.h"
#import "HXMoreFindVC.h"



@interface DDRiskAssessViewController ()

@property (nonatomic, strong) UIButton *footBtn;
@property (nonatomic, strong) UILabel *headLab;

@property (nonatomic, strong) NSMutableArray *scoreArray;
@property (nonatomic, strong) NSMutableArray *tagNumArray;

@end

@implementation DDRiskAssessViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评估问卷";
    self.scoreArray = [NSMutableArray array];
    self.tagNumArray = [NSMutableArray array];

    //自定义返回item
    [self addBackItemWithAction];
    
    //添加footview
    [self addinitFootView];
    UIView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"DDRiskAssessHeadView" owner:self options:nil] lastObject];
    CGRect newFrame = headerView.frame;
    newFrame.size.height = 215;
    if (IS_IPHONE5) {
        newFrame.size.height = 245;
    }
    headerView.frame = newFrame;
    [self.tableView setTableHeaderView:headerView];
}

//自定义返回
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
}

- (void)addinitFootView
{
    //footView
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    footview.backgroundColor = [UIColor clearColor];
    self.footBtn = [[HXButton alloc] initWithFrame:CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width - 16, 44)];
    self.footBtn.center = footview.center;
    [self.footBtn setTitle:@"提交问卷" forState:UIControlStateNormal];
    [self.footBtn addTarget:self action:@selector(footBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.footBtn.backgroundColor = kColor_Red_Main;
    [footview addSubview:self.footBtn];
    self.tableView.tableFooterView = footview;
}

//    点击提交按钮
- (void)footBtnClick
{
    [self.scoreArray removeAllObjects];
    self.footBtn.enabled = NO;
    NSMutableArray *temp = nil;
    for (int i =0; i<self.resultArray.count; i++) {
        temp = self.resultArray[i];
        if (![temp containsObject:@1]) {
            NSString *str = [NSString stringWithFormat:@"第%d题未回答",i+1];
            [MBProgressHUD showError:str];
            self.footBtn.enabled = YES;
            return;
        }
    }
    [self initDatasArray];
}

- (void)initDatasArray
{
    [self.tagNumArray removeAllObjects];
    NSMutableArray *temp = nil;
    NSMutableArray *tempScore = nil;
    NSMutableArray *tempTagNum = nil;
    for (int i =0; i<self.resultArray.count; i++) {
        temp = self.resultArray[i];
        tempScore = self.pathScoreArr[i];
        tempTagNum = self.pathTagNumArr[i];
        for (int j=0; j<temp.count; j++) {
            if ([temp[j] isEqual:@1]) {
                [self.scoreArray addObject:tempScore[j]];
                [self.tagNumArray addObject:tempTagNum[j]];
            }
        }
    }
    //post通知后台评估结果
    NSString *tagStr = [self.tagNumArray componentsJoinedByString:@","];
    [self postRiskAssessResult:tagStr];
    
}

- (void)doBack
{
    /*  此方法让多级跳转直接回到首页  */
//    if (self.navigationController.viewControllers.count >3 ) {
    
//        AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        BXTabBarController *tabBarVC = [[BXTabBarController alloc]init];
//        dele.window.rootViewController = tabBarVC;
//        [tabBarVC loginStatusWithNumber:1];
//        tabBarVC.selectedIndex = 0;
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        ////popToview的方法
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
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
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - post
/** post提交评估结果**/
- (void)postRiskAssessResult:(NSString *)assessResult
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequsetAssessResult;
    info.dataParam = @{@"usrEval ":assessResult};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        self.footBtn.enabled = YES;
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDAssessmentVC" bundle:nil];
            DDAssessmentVC *asvc = [sb instantiateInitialViewController];
            asvc.dic = [NSDictionary dictionaryWithDictionary:dict[@"body"]];
            [self.navigationController pushViewController:asvc animated:YES];
 
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
    } faild:^(NSError *error) {
        self.footBtn.enabled = YES;

    }];
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
