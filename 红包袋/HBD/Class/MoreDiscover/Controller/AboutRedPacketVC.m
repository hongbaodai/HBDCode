//
//  AboutRedPacketVC.m
//  test
//
//  Created by hongbaodai on 2017/11/23.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "AboutRedPacketVC.h"
#import "HXWebVC.h"

@interface AboutRedPacketVC ()

@property (nonatomic, strong) NSArray *urlArr;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation AboutRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于红包袋";
    
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
    
    NSArray *dataAr = [self creatVCWithStr:@[@"公司简介", @"安全保障", @"产品介绍"]];

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
        __weak typeof(self)WeakSelf = self;
        
        item.option = ^(NSIndexPath *index) {
            [WeakSelf didSelectTableViewCellWithIndex:index];
        };
        
        [muArr addObject:item];
    }
    return [NSArray arrayWithArray:muArr];
}

- (void)didSelectTableViewCellWithIndex:(NSIndexPath *)indexPath
{
    HXWebVC *vc = [[HXWebVC alloc] init];
    vc.title = self.titleArr[indexPath.row];
    vc.urlStr = self.urlArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (NSArray *)urlArr
{
    if (_urlArr == nil) {
        
        NSString *aboutU1 = [NSString stringWithFormat:@"%@/Culture?hidden=1",DDNEWWEBURL];
        NSString *aboutU2 = [NSString stringWithFormat:@"%@/selfUs?hidden=1",DDNEWWEBURL];
        NSString *aboutU3 = [NSString stringWithFormat:@"%@/pIntroduction?hidden=1",DDNEWWEBURL];
        _urlArr = @[aboutU1, aboutU2, aboutU3];
        
    }
    return _urlArr;
}

- (NSArray *)titleArr
{
    if (_titleArr == nil) {
        _titleArr = @[@"公司简介", @"安全保障", @"产品介绍"];
    }
    return _titleArr;
}

@end
