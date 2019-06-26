//
//  HXBaseCustomTableVC.m
//  test
//
//  Created by hongbaodai on 2017/11/13.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXBaseCustomTableVC.h"
#import "HXProductCell.h"


@interface HXBaseCustomTableVC ()

@end

@implementation HXBaseCustomTableVC
//@synthesize datas = _datas;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];
    self.tableView.scrollEnabled = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)settingSwith:(UISwitch *)swi
{
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HXProuductGroup *group = self.datas[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXProuductGroup *g = self.datas[indexPath.section];
    HXItem *item = g.items[indexPath.row];
    WS(weakSelf);
    HXProductCell *cell = [HXProductCell hxProductCellWithTableView:tableView style:item.styleCell];
    cell.switchBlock = ^(UISwitch *swi) {
        [weakSelf settingSwith:swi];
    };
    cell.item = item;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.datas != nil && self.datas.count > 0) {
        
        HXProuductGroup *group = self.datas[section];
        return group.headerTitle;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.datas != nil && self.datas.count > 0) {
        HXProuductGroup *group = self.datas[section];
        return group.footerTitle;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil && self.datas.count > 0) {
        HXProuductGroup *group = self.datas[indexPath.section];
        return group.cellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.datas != nil && self.datas.count > 0) {
        HXProuductGroup *group = self.datas[section];
        return group.headerHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.datas != nil && self.datas.count > 0) {
        HXProuductGroup *group = self.datas[section];
        return group.footerHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil && self.datas.count > 0) {
        
        // 拿到对应行的模型
        HXProuductGroup *g = self.datas[indexPath.section];
        HXItem *item = g.items[indexPath.row];
        
        // 判断block里面是否保存了代理，要是保存，就执行
        if (item.option != nil) {
            // 如果block里面保存了代码，就执行
            item.option(indexPath);
            return;
        }
        
        // 创建控制器
        if ([item isKindOfClass:[HXArrowItem class]]) {
            // 类型强转
            HXArrowItem *arrowItem = (HXArrowItem *)item;
            UIViewController *vc = [[[arrowItem destVC] alloc] init];
            vc.title = arrowItem.title;
            
            // 将目标控制器压到栈里面
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        
        _datas = [NSMutableArray array];
    }
    return _datas;
}


@end
