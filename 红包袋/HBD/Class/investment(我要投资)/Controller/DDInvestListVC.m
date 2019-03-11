//
//  DDInvestListVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/30.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestListVC.h"
#import "DDInvestListCell.h"
#import "OYCountDownManager.h"
#import "DDInvestFilttrateVC.h"
#import "HXRefresh.h"
#import "BXInvestmentModel.h"
#import "DDInvestSegmentVC.h"
#import "DDInvestSureVC.h"
#import "HXTabBarViewController.h"
#import "BXJumpThirdPartyController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DDRiskPopView.h"
#import "DDRiskAssessViewController.h"
#import "HXRiskAssessModel.h"
#import "HXPopUpViewController.h"
#import "DDEqbVC.h"
#import "TopButton.h"

#define rowHeigh (176.0+8.0)

@interface DDInvestListVC () <DDFilttrateDelegate, PayThirdPartyProtocol, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, DDRiskPopViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *elementMatrix;
@property (nonatomic, assign) int dataIndex;

@property (nonatomic, strong) TopButton *topBut;

@end

@implementation DDInvestListVC
{
    int intPage;
    NSString *filTime_;              // 出借期限
    NSString *filPercent_;           // 预期年化收益
    NSString *filType_;              // 项目类型
    NSDictionary  *userCardInfo;     // 用户绑卡信息
    BOOL isBankCard;                 // 是否绑定了银行卡
    UIView *noView_;
    int btnY;
}
#pragma mark life cycle
- (void)viewDidLoad
{   [super viewDidLoad];
    // 网络访问结束设置空页面数据源和代理方法
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = rowHeigh;
    self.tableView.scrollsToTop = YES;

    self.dataArray = [NSMutableArray array];
    filTime_ = @"0";
    filPercent_ = @"0";
    filType_ = @"0";
    [self addRightBarButtonItem];
    
    //     添加刷新控件
    [self addHeaderRefresh];
    
    //     启动倒计时管理
    [kCountDownManager start];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeClick) name:@"tabBarChangeNotifi" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //mj视图下移bug
    [self postUserBankCardInfo]; //用户信息
}
// 切换tabbabar，需要重新请求所有的数据，重置筛选条件。
- (void)noticeClick {
    filTime_ = @"0";
    filPercent_ = @"0";
    filType_ = @"0";
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

/** 筛选  */
- (void)addRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMG(@"loan_znx") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
}

- (void)rightBarBtnClick {
    DDInvestFilttrateVC *filVc = [[DDInvestFilttrateVC alloc] init];
    filVc.delgate = self;
    filVc.filTime = filTime_;
    filVc.filPercent = filPercent_;
    filVc.filType = filType_;
    [self.navigationController  pushViewController:filVc animated:YES];
}

//#pragma mark - 筛选代理
- (void)didClickFilttrateTermCount:(NSString *)termCount InterestRange:(NSString *)interestRange ProjType:(NSString *)projType {
    intPage = 1;
    filTime_ = termCount;
    filPercent_ = interestRange;
    filType_ = projType;
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

// 下拉刷新
- (void)addHeaderRefresh {
    WS(weakSelf);
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerBlock:^{
        [weakSelf postLoanListWithTermCount:filTime_ InterestRange:filPercent_ ProjType:filType_ AndHeader:YES];
    }];
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    [HXRefresh setFooterRefreshWithVC:self tableView:self.tableView footerBlock:^{
        [weakSelf postLoanListWithTermCount:filTime_ InterestRange:filPercent_ ProjType:filType_ AndHeader:NO];
    }];
    
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
- (void)didClickNowRiskBtn {
    //跳转到风险评估
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


#pragma mark -- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DDInvestListCell *cell = [DDInvestListCell investListCellWithTableView:tableView];
    BXInvestmentModel *investModel = self.dataArray[indexPath.row];
    [cell fillDataWithInvestList:investModel];
    
    cell.investBlock = ^{
        
        HXTabBarViewController * tabBarVC = (HXTabBarViewController *)self.tabBarController;
        if (tabBarVC.bussinessKind) { //登录
            
            if ([self isCanSubmit]) {
                
                UIStoryboard *segsb = [UIStoryboard storyboardWithName:@"DDInvestSureVC" bundle:nil];
                DDInvestSureVC *segVc=  [segsb instantiateInitialViewController];
                BXInvestmentModel *model = self.dataArray[indexPath.row];
                if (model.B_ID) {
                    segVc.loanId = model.B_ID;
                }
        
                segVc.levelName =  userCardInfo[@"body"][@"levelName"];
                [self.navigationController pushViewController:segVc animated:YES];
            }
            
            
        }else{ //未登录
            [self presentLoginVC];
        }
        
    };
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DDInvestSegmentVC *segVc = [[DDInvestSegmentVC alloc] init];
    
    BXInvestmentModel *model = self.dataArray[indexPath.row];
    if (model.B_ID) {
        segVc.loanID = model.B_ID;
    }
    segVc.tempModel = model;
    [self.navigationController pushViewController:segVc animated:YES];
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


#pragma mark - DZNEmptyDataSetSource
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"loan_huixiong"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂时没有符合要求的项目哦！";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:DDRGB(45, 65, 94)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}



- (NSString *)turnIndexWithInterestRange:(NSString *)interestRange {
    NSString *temtStr;
    if ([interestRange isEqualToString:@"0"]) {
        temtStr = @"0";
    } else if ([interestRange isEqualToString:@"1"]) {
        temtStr = @"5";
    } else if ([interestRange isEqualToString:@"2"]) {
        temtStr = @"6";
    } else if ([interestRange isEqualToString:@"3"]) {
        temtStr = @"7";
    } else if ([interestRange isEqualToString:@"4"]) {
        temtStr = @"2";
    } else if ([interestRange isEqualToString:@"5"]) {
        temtStr = @"8";
    }
    
    return temtStr;
}

/**
 出借期限：   termCount：    0->全部；1->3月以下； 2->3至6个月；3->6个月以上；
 预期年化收益：interestRange：0-全部；5->6%以下；6->6%至8%；7->8%至10%；2-> 10%至12%；8->12%以
 项目类型：   projType：     0-全部；1-红宝理；2-预付宝；3-优企宝；4-小包贷；
 */
#pragma mark -- post
/* 出借列表 */
- (void)postLoanListWithTermCount:(NSString *)termCount InterestRange:(NSString *)interestRange ProjType:(NSString *)projType AndHeader:(BOOL)header
{
    
    NSString *rangeStr = [self turnIndexWithInterestRange:interestRange]; // 预期年化收益字符转换
    
    if (header) {
        intPage = 1;
    }
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    NSString *pageStr = [NSString stringWithFormat:@"%d", intPage];
    
    info.dataParam = @{@"pageNum":pageStr, @"pageSize":@"20", @"termCount":termCount, @"interestRange":rangeStr, @"projectType":projType,@"loanStatus":@"0", @"vobankIdTemp":@"", @"isExperience":@"0"};
    info.serviceString = BXRequestLoanList;
    
    WS(weakSelf);
    
    [[BXNetworkRequest defaultManager] postWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            if (header) {
                [weakSelf.dataArray removeAllObjects];
            }
            
            NSArray *tempArray = [BXInvestmentModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];

            [weakSelf.dataArray addObjectsFromArray:tempArray];
         
            if ([dict[@"body"][@"pageData"][@"totalCount"] intValue] ==0) {
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer setHidden:YES];
            } else {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
            
            if ([dict[@"body"][@"pageData"][@"totalCount"] intValue] > 20) {
                intPage += 1;
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            
            if ([dict[@"body"][@"pageData"][@"totalCount"] intValue] < 20 && [dict[@"body"][@"pageData"][@"totalCount"] intValue] >0) {
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [kCountDownManager reload];
            [weakSelf.tableView reloadData];
        

        }else{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
    } faild:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"获取数据失败"];
    }];
}

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


/** 绑定银行卡 */
- (void)postBlindCard
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestlmBindPersonCard;
    info.dataParam = @{@"from":@"M"};
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] != 0) {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
        
        BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
        JumpThirdParty.title = @"绑定银行卡";
        JumpThirdParty.payDelegate = self;
        JumpThirdParty.info = info;
        JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
        
        [self.navigationController pushViewController:JumpThirdParty animated:YES];
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    [self.navigationController popViewControllerAnimated:YES];
    if (isSuccess) {
        [self showAlertWithStr:@"绑卡成功!"];
    } else {
        [self showAlertWithStr:@"绑卡失败，请稍后再试！"];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {

        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat ofY = offset.y + SCREEN_HEIGHT- 64 - 50;

        if (ofY >= rowHeigh * 4 ) {
            self.topBut.hidden = NO;
            CGFloat widthbut = 30;
            CGFloat xbut = SCREEN_WIDTH - 17 - widthbut;
            self.topBut.frame = CGRectMake(xbut, (self.tableView.frame.size.height - 150) + self.tableView.contentOffset.y , widthbut, widthbut);

        } else {
            self.topBut.hidden = YES;
        }

    }
}

- (void)showAlertWithStr:(NSString *)str
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)topAction:(TopButton *)but
{
     [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];  
}

- (TopButton *)topBut
{
    if (_topBut == nil) {
        CGFloat widthbut = 30;
        CGFloat xbut = SCREEN_WIDTH - 17 - widthbut;
        CGFloat ybut = SCREEN_HEIGHT - 73 - widthbut;
        _topBut = [[TopButton alloc] initWithFrame:CGRectMake(xbut, ybut, widthbut, widthbut)];
//        [_topBut setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
        [_topBut addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        _topBut.hidden = YES;
        [self.view addSubview:_topBut];
        [self.tableView bringSubviewToFront:_topBut];

        btnY = (int)_topBut.frame.origin.y;
    }
    return _topBut;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



