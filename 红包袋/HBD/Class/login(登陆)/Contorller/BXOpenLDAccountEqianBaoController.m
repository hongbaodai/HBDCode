//
//  BXOpenLDAccountEqianBaoController.m
//  HBD
//
//  Created by hongbaodai on 2018/7/3.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "BXOpenLDAccountEqianBaoController.h"
#import "DDActivityWebController.h"
#import "LADAccoutTVCell.h"

@interface BXOpenLDAccountEqianBaoController ()

@end

@implementation BXOpenLDAccountEqianBaoController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:@"BXOpenLDAccountController" bundle:nibBundleOrNil];
}

- (void)viewDidLoad {

    self.title = @"实名认证";
    [self addBackItemWithAction];
    [self setUpHeaderUI];
    [self postBankLimitAmount];
}

- (void)setUpHeaderUI
{
    CGRect framee = CGRectMake(0, 0, SCREEN_WIDTH, 430);
    self.headerVie = [LDAccountEQianBaoView createLDAccountViewWithFrame:framee];
    self.pageView = [[UIView alloc] initWithFrame:framee];
    [self.pageView addSubview:self.headerVie];

    self.tableView.tableHeaderView = self.pageView;

    WS(weakSelf);
    self.headerVie.sureBlock = ^{
        // 确认开户
        if (!weakSelf.headerVie.nameTextFiled.text.length) {
            [MBProgressHUD showError:@"请输入姓名"];
        } else if (![weakSelf isValidateIdentityCard:weakSelf.headerVie.numTextFiled.text]) {
            [MBProgressHUD showError:@"请输入合法的身份证号"];
        } else {
            [weakSelf postOpenAccountWithUserName:weakSelf.headerVie.nameTextFiled.text IdCard:weakSelf.headerVie.numTextFiled.text];
        }
    };

    self.headerVie.protoBlock = ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
        DDActivityWebController *weVc = [sb instantiateInitialViewController];
        weVc.webTitleStr = @"授权书";
        weVc.webUrlStr = [NSString stringWithFormat:@"%@/shouquanshu?hidden=1",DDNEWWEBURL];;
        [weakSelf.navigationController pushViewController:weVc animated:YES];
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   LADAccoutTVCell *cell = (LADAccoutTVCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row <= 2) {
        cell.backView.backgroundColor = [UIColor colorWithHex:@"#fff1d2"];
    } else {
        cell.backView.backgroundColor = [UIColor colorWithHex:@"#fafafa"];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
