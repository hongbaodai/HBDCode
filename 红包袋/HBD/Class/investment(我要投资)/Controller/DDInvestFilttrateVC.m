//
//  DDInvestFilttrateVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/25.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//  筛选

#import "DDInvestFilttrateVC.h"
#import "RHFiltrateView.h"

@interface DDInvestFilttrateVC () <RHFiltrateViewDelegate>

@property (nonatomic, strong) HXButton *investBtn;
@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) UIScrollView *scorllView;
@end

@implementation DDInvestFilttrateVC
{
    RHFiltrateView * filtrate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    self.view.backgroundColor = kColor_BackGround_Gray;

    [self addRightBarButtonItem];
    [self addFiltrateBtn];
    [self addInvestBtn];
    
    
}

- (UIScrollView *)scorllView {
    if (_scorllView == nil) {
        _scorllView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scorllView.backgroundColor = [UIColor clearColor];
        
        if (IS_IPHONE5) {
            _scorllView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+80);

        } else {
            _scorllView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        
        [self.view addSubview:_scorllView];
    }
    return _scorllView;
}

- (void)addRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
}
// 重置所有选项
- (void)rightBarBtnClick {
    
    [filtrate didClickResertBtn];
    _filTime = @"0";
    _filPercent = @"0";
    _filType = @"0";
}

- (void)addInvestBtn {
    self.investBtn = [[HXButton alloc] initWithFrame:CGRectMake(10, 490, SCREEN_WIDTH-20, 44)];
    [self.investBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.investBtn addTarget:self action:@selector(investBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scorllView addSubview:self.investBtn];
}

/**
 点击确定
 */
- (void)investBtnClick {
    
    if ([_filTime isEqualToString:@"0"] || _filTime == 0) {
        _filTime = @"0";
    }
    if ([_filPercent isEqualToString:@"0"] || _filPercent == 0) {
        _filPercent = @"0";
    }
    if ([_filType isEqualToString:@"0"] || _filType == 0) {
        _filType = @"0";
    }
    
    //post后让出借列表刷新
    [self.delgate didClickFilttrateTermCount:_filTime InterestRange:_filPercent ProjType:_filType];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 添加筛选条件
 */
- (void)addFiltrateBtn {

    NSArray *arrTitle = @[@"出借期限", @"预期年化收益", @"产品类型"];
    NSArray *arr1 = @[@"全部", @"3个月以内", @"3至6个月", @"6个月以上"];
    NSArray *arr2 = @[@"全部", @"6%以下", @"6%至8%", @"8%至10%", @"10%至12%", @"12%以上"];
    //NSArray *arr3 = @[@"全部", @"红宝理", @"预付宝", @"优企宝", @"小包贷"];
    NSArray *arr3 = @[@"全部", @"智造类", @"消费类", @"惠农类", @"电商类"];
    filtrate = [[RHFiltrateView alloc] initWithTitles:arrTitle items:@[arr1, arr2, arr3]];
    
    filtrate.frame = self.view.bounds;
    filtrate.delegate = self;

    [self.scorllView addSubview:filtrate];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *tempArr = @[_filTime, _filPercent, _filType];
    filtrate.selectArr = tempArr;
    
}


#pragma mark - filetrate delegate
- (void)filtrateView:(RHFiltrateView *)filtrateView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        _filTime = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    
    if (indexPath.section == 1) {
        _filPercent = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    
    if (indexPath.section == 2) {
        _filType = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

