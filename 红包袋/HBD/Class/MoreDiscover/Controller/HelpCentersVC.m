//
//  HelpCentersVC.m
//  test
//
//  Created by hongbaodai on 2017/11/23.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HelpCentersVC.h"
#import "HXWebVC.h"

@interface HelpCentersVC ()

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation HelpCentersVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"帮助中心";
    [self setupGroups];
}

- (void)setupGroups
{
    // 0组
    [self setUpGroup0];
}

- (void)setUpGroup0
{
    HXProuductGroup *group0 = [self creatGoup];
    
    NSArray *arr = @[@"注册与登录", @"认证与安全", @"充值与提现", @"出借交易", @"法律保障", @"名词解释"];
    NSArray *dataAr = [self creatVCWithStr:arr];

    group0.items = [NSMutableArray arrayWithArray:dataAr];
    [self.datas addObject:group0];
}

- (HXProuductGroup *)creatGoup
{
    HXProuductGroup *group0 = [[HXProuductGroup alloc] init];
    group0.cellHeight = 51.0f;
    group0.headerHeight = 10.0f;
    group0.footerHeight = 0;
    
    return group0;
}

- (NSArray *)creatVCWithStr:(NSArray *)arr
{
    NSMutableArray *muArr = [NSMutableArray array];
    
    for (int i = 0; i < arr.count; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%@",arr[i]];
        
        HXArrowItem *item = [HXArrowItem itemWithTitle:str];
        __weak typeof(self)weakSelf = self;
        
        item.option = ^(NSIndexPath *index) {
            [weakSelf didSelectTableViewCellWithIndex:index];
        };
        
        [muArr addObject:item];
    }
    return [NSArray arrayWithArray:muArr];
}

- (void)didSelectTableViewCellWithIndex:(NSIndexPath *)indexPath
{
    HXWebVC *vc = [[HXWebVC alloc] init];
    vc.urlStr = self.dataArr[indexPath.row];
    vc.title = self.titleArr[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        NSString *str1 = [NSString stringWithFormat:@"%@/LogInstatic?hidden=1",DDNEWWEBURL];
        NSString *str2 = [NSString stringWithFormat:@"%@/AthenticSafe?hidden=1",DDNEWWEBURL];
        NSString *str3 = [NSString stringWithFormat:@"%@/rechargeDrawal?hidden=1",DDNEWWEBURL];
        NSString *str4 = [NSString stringWithFormat:@"%@/InvestmentTrading?hidden=1",DDNEWWEBURL];
        NSString *str5 = [NSString stringWithFormat:@"%@/legal?hidden=1",DDNEWWEBURL];
        NSString *str6 = [NSString stringWithFormat:@"%@/NameExplain?hidden=1",DDNEWWEBURL];
        
        _dataArr = @[str1, str2, str3, str4, str5, str6];
    }
    return _dataArr;
}

- (NSArray *)titleArr
{
    if (_titleArr == nil) {
        _titleArr = @[@"注册与登录", @"认证与安全", @"充值与提现", @"出借交易", @"法律保障", @"名词解释"];
    }
    return _titleArr;
}

@end
