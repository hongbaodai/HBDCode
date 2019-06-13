//
//  DDChooseCouponVC.m
//  HBD
//
//  Created by hongbaodai on 2018/3/5.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "DDChooseCouponVC.h"
#import "BXCouponModel.h"
#import "MJRefresh.h"
#import "DDChooseHbCell.h"

@interface DDChooseCouponVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView  *onetableView;
// 单选红包
@property (nonatomic, strong) NSArray *singleHbArr;
// 红包ID
@property (nonatomic, copy) NSString *redPactID;
@property (nonatomic, assign) NSInteger signleHbSelIndex;

@property (nonatomic, strong) UIView *sureBtnView;
@property (nonatomic, strong) NSMutableArray  *dikouNumArr;
@property (nonatomic, strong) UILabel *lab;

@end

@implementation DDChooseCouponVC

{
    NSInteger segIndex;
    UILabel *hbCanLab;
    CGFloat SYTJsum;
    
    CGFloat canUseMoney;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择奖券";
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#f3f3f3"];
    //--------------------------------------------
    self.singleHbArr = [NSMutableArray arrayWithArray:self.singleCouponArr];
    
    //初始化模型的选中状态和可用状态
    for (BXCouponModel *model in self.singleHbArr) {
        model.selectState = NO;
        model.isCanSelected = YES;
    }
    
    //--------------------------------------------
    
    self.dikouNumArr = [NSMutableArray array];
    
    [self addTableviewView];
    [self addSureBtns];
    segIndex = 0;
    _signleHbSelIndex = -1;
    
    _signleHbSelIndex = self.singleIndex;

    hbCanLab.text = [NSString stringWithFormat:@"返现金额(元)：%.2f",_singleModel.MZ];
    
    [self.onetableView reloadData];

    if (self.singleCouponArr.count == 0) {
        [self showNoddataLab];
    }
    
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    
    if (self.availbleHbArr.count == 0) {
        
        self.singleModel = nil;
        //初始化模型的选中状态和可用状态
        for (BXCouponModel *model in self.singleHbArr) {
            model.selectState = NO;
            model.isCanSelected = NO;
        }
     
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    
    [self.sureBtnView removeFromSuperview];
}

- (void)addTableviewView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 -64)];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollsToTop = YES;
    self.onetableView = tableView;
    [self.view addSubview:self.onetableView];
}


- (void)addSureBtns
{
    // 确定按钮
    self.sureBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 64)];
    self.sureBtnView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tabBarController.view addSubview:self.sureBtnView];
    
    hbCanLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH, 12)];
    hbCanLab.centerX_ = _sureBtnView.centerX_;
    hbCanLab.font = [UIFont systemFontOfSize:11];
    hbCanLab.textColor = [UIColor lightGrayColor];
    hbCanLab.textAlignment = NSTextAlignmentCenter;
    hbCanLab.text = [NSString stringWithFormat:@"返现金额(元)：0.00"];
    [self.sureBtnView addSubview:hbCanLab];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, self.sureBtnView.width_, 44)];
    sureBtn.backgroundColor = kColor_Red_Main;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtnView addSubview:sureBtn];
}

#pragma mark - 确定按钮点击
- (void)sureBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
   
    [self.delegate chooseCouponSureSingleHb:self.singleModel AndHbID:self.signleHbSelIndex];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _singleHbArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fooView = [[UIView alloc]initWithFrame:CGRectZero];
    fooView.backgroundColor = [UIColor clearColor];
    return fooView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        DDChooseHbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDChooseHbCell"];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"DDChooseHbCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        BXCouponModel *model = _singleHbArr[indexPath.row];
        model.inputMoney = [_investMoney floatValue];
        [cell fillWithCouponModel:model];
        
        if (![_availbleHbArr containsObject:model]) {//无红包可用
            
            if (indexPath.row==_signleHbSelIndex) {
                [cell.useBtn setTitle:@"立即选择" forState:UIControlStateNormal];
                cell.hbBackImg.image = IMG(@"RedPacketUnuse"); //蓝色
            } else {
                [cell.useBtn setTitle:@"立即选择" forState:UIControlStateNormal];
                [cell.useBtn setTitleColor:kColor_Gray forState:UIControlStateNormal];
                [cell.useBtn setBackgroundColor:kColor_sRGB(170, 189, 196)];
                cell.hbBackImg.image = IMG(@"RedPacketUsed"); //灰色
            }
            
        } else {
            if (indexPath.row==_signleHbSelIndex) {
                
                [cell.useBtn setTitle:@"已选择" forState:UIControlStateNormal];
                [cell.useBtn setTitleColor:kColor_Red_Main forState:UIControlStateNormal];
                [cell.useBtn setBackgroundColor:kColor_White];
                
            } else {
                [cell.useBtn setTitle:@"立即选择" forState:UIControlStateNormal];
                cell.useBtn.backgroundColor = kColor_White;
            }
        }
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    BXCouponModel *model = _singleHbArr[indexPath.row];
    
    if ([_availbleHbArr containsObject:model]) {
        
        self.singleModel = model;
        self.redPactID = model.YHQ_ID;
        
        if (_signleHbSelIndex == indexPath.row) {
            
            self.signleHbSelIndex = -1;
            self.singleModel = nil;
            hbCanLab.text = [NSString stringWithFormat:@"返现金额(元)：0.00"];
            [_onetableView reloadData];
        } else {
            
            self.signleHbSelIndex = indexPath.row;
            hbCanLab.text = [NSString stringWithFormat:@"返现金额(元)：%.2f",model.MZ];
            [_onetableView reloadData];
            
        }
    }
    
}

#pragma mark -- 计算多选抵扣金额
-(void)countDikouMoneyDikouArr:(NSMutableArray *)dikouArr
{
    double num = 0;
    BXCouponModel *model = nil;
    //
    for ( int i =0; i<dikouArr.count; i++)
    {
        //        model = [[BXCouponModel alloc] init];
        model = dikouArr[i];
        num += model.MZ;
        
    }
    self.dikouNum = num;
}

//显示无数据
- (void)showNoddataLab
{
    
    _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, 35)];
    _lab.text = @"暂无可用奖券";
    _lab.font = [UIFont systemFontOfSize:14];
    _lab.textColor = [UIColor lightGrayColor];
    _lab.textAlignment = NSTextAlignmentCenter;
    [self.onetableView  addSubview:_lab];
}

#pragma mark -- lazyload

-(void)setInvestMoney:(NSString *)investMoney
{
    _investMoney = investMoney;
    canUseMoney = [_investMoney floatValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
