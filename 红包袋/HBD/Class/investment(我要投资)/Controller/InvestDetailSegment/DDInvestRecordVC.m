//
//  DDInvestRecordVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/12.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestRecordVC.h"
#import "DDInvestRecordModel.h"
#import "DDInvestRecordCell.h"
#import "HXRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DDInvestRcdView.h"

@interface DDInvestRecordVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
//{
//    BOOL isOnlyMe; // yes：唯我独尊 no:一锤定音
//}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DDInvestRcdView *stateView;

@property (nonatomic, assign) NSString *onlyMe; // 1：唯我独尊 2:一锤定音 0:没有数据

@end

@implementation DDInvestRecordVC
{
    int intPage_;
    
    NSString *loginStatus;//状态码字段  statusCode
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 网络访问结束设置空页面数据源和代理方法
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.backgroundColor = kColor_BackGround_Gray;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addHeaderRefresh];
}

- (void)showStartView {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *str = [def objectForKey:@"username"];
    if (str && str != nil) {
        _islogin = YES;
    } else {
        _islogin = NO;
    }
    _stateView = [[DDInvestRcdView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 200, SCREEN_WIDTH, 250) isLogin:_islogin];
    _stateView.backgroundColor = kColor_BackGround_Gray;
    WS(weakSelf);
    _stateView.investRcdBlock = ^{
    
        [weakSelf.ddelegate didClickLoginVc];
    };
    [self.tableView addSubview:_stateView];
}


/** 添加刷新控件 */
- (void)addHeaderRefresh
{
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerBlock:^{
        
        [self postInvestRecordWithLoanId:_loanId AndHeader:YES];
        [self postIsOnlyMeOrNot:_loanId];
    }];
    [self.tableView.mj_header beginRefreshing];
}

/** 添加上拉加载 */
- (void)addFooterRefresh
{
    [HXRefresh setFooterRefreshWithVC:self tableView:self.tableView footerBlock:^{
        
        [self postInvestRecordWithLoanId:_loanId AndHeader:NO];
    }];
    
}


#pragma mark -- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDInvestRecordCell *cell = [DDInvestRecordCell initCellWithTableView:tableView];
 
    DDInvestRecordModel *model = self.dataArray[indexPath.row];
    
    cell.only = self.onlyMe;
    [cell fillDataWithInvestRecordModel:model indexpath:indexPath];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
//设置分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 41;
}
//设置分区头视图  (自定义分区头 一定要设置分区头高度)
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    headerview.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, SCREEN_WIDTH/3, 30)];
    [headerview addSubview:lab1];
    lab1.text = @"出借用户";
    lab1.font = FONT_14;
    lab1.textColor = kColor_sRGB(45, 65, 94);
    lab1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 6, SCREEN_WIDTH/3, 30)];
    [headerview addSubview:lab2];
    lab2.text = @"出借金额（元）";
    lab2.font = FONT_14;
    lab2.textColor = kColor_sRGB(45, 65, 94);
    lab2.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 6, SCREEN_WIDTH/3, 30)];
    [headerview addSubview:lab3];
    lab3.text = @"出借时间";
    lab3.font = FONT_14;
    lab3.textColor = kColor_sRGB(45, 65, 94);
    lab3.textAlignment = NSTextAlignmentCenter;
    
    return headerview;
    
}



#pragma mark - DZNEmptyDataSetSource
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"loan_huixiong"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无出借记录！";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:kColor_sRGB(45, 65, 94)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


#pragma mark -- post


/* 是一锤定音还是唯我独尊 */
- (void)postIsOnlyMeOrNot:(NSString *)loanId
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"loanId":loanId};
    info.serviceString = BXRequestGetActivityAward;
    
    WS(weakSelf);
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dict[@"body"][@"jlmc"] isEqualToString:@"唯我独尊"]) {
            weakSelf.onlyMe = @"1";
        } else if ([dict[@"body"][@"jlmc"] isEqualToString:@"一锤定音"]){
            weakSelf.onlyMe = @"2";
        } else if ([dict[@"body"][@"jlmc"] isEqualToString:@""] || [dict[@"body"][@"jlmc"] isEqualToString:@"不展示"]){ // 这里是根据web端做的区分
             weakSelf.onlyMe = @"";
        }

        [self.tableView reloadData];
    } faild:^(NSError *error) {
        
        [self endRefresh];
    }];
}


/* 出借记录 */
- (void)postInvestRecordWithLoanId:(NSString *)loanId AndHeader:(BOOL)header
{
    if (header) {
        intPage_ = 1;
        [self.dataArray removeAllObjects];
    } else {
        intPage_++;
    }
    NSString *pageNum = [NSString stringWithFormat:@"%d",intPage_];
    
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    
    info.dataParam = @{@"loanId":loanId, @"pageNum":pageNum, @"pageSize":@"20"};
    info.serviceString = DDURL_ProjectInvestRecord;
    
    WS(weakSelf);
 
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [weakSelf endRefresh];
        
        if ([dict[@"body"][@"resultcode"] integerValue] != 0)  {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
            return ;
        }
        if ([dict[@"body"][@"pageData"][@"totalCount"] intValue] > 20) {
            [weakSelf addFooterRefresh];
        }
        
        if (intPage_ == [dict[@"body"][@"pageData"][@"pageCount"] intValue] && intPage_ != 1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        NSArray *tempArray = [DDInvestRecordModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
        
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:weakSelf.dataArray];
        [temp addObjectsFromArray:tempArray];
        weakSelf.dataArray = temp;
        
        DDLog(@"----statusCode：%@", dict[@"body"][@"pageData"][@"statusCode"]);
        
        //状态码字段  statusCode  -1 表示用户已登录未出借   0表示用户未登陆  1表示正常    仅针对还款中和已完成的标，其它标不改变
        if (!([dict[@"body"][@"pageData"][@"statusCode"] intValue] == 1)) {
            [self showStartView];   //出借记录需求
        }
        
        [weakSelf.tableView reloadData];
        
        
        
    } faild:^(NSError *error) {
        
        [self endRefresh];
    }];
}

/** 结束刷新 */
- (void)endRefresh
{
    WS(weakSelf);
    if ( intPage_ != 1) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }
    [weakSelf.tableView.mj_header endRefreshing];
}


#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tablew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64-44) style:UITableViewStylePlain];
        tablew.delegate = self;
        tablew.dataSource = self;
        tablew.separatorStyle = UITableViewCellSeparatorStyleNone;
        tablew.backgroundColor = kColor_BackGround_Gray;
        tablew.rowHeight = 63;
        _tableView = tablew;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end


