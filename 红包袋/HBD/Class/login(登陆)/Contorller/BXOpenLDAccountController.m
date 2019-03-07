//
//  BXOpenLDAccountController.m
//  HBD
//
//  Created by echo on 16/8/9.
//  实名认证

#import "BXOpenLDAccountController.h"
#import "HXTabBarViewController.h"
#import "LADAccoutTVCell.h"
#import "LADAccoutModel.h"
#import "LDAccountView.h"

@interface BXOpenLDAccountController ()

@property (strong, nonatomic) LDAccountView *headerView;

@end

@implementation BXOpenLDAccountController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"实名认证";
    
    [self addBackItemWithAction];

    [self setUpHeaderUI];
    [self postBankLimitAmount];
}

- (void)setUpHeaderUI
{
    CGRect framee = CGRectMake(0, 0, SCREEN_WIDTH, 473);
    self.headerView = [LDAccountView createLDAccountViewWithFrame:framee];
    self.pageView = [[UIView alloc] initWithFrame:framee];
    
    [self.pageView addSubview:self.headerView];
    
    
    self.tableView.tableHeaderView = self.pageView;

    WS(weakSelf);
    self.headerView.sureBlock = ^{
      // 确认开户
        if (!weakSelf.headerView.nameTextFiled.text.length) {
            [MBProgressHUD showError:@"请输入姓名"];
        } else if (![weakSelf isValidateIdentityCard:weakSelf.headerView.numTextFiled.text]) {
            [MBProgressHUD showError:@"请输入合法的身份证号"];
        } else {
            [weakSelf postOpenAccountWithUserName:weakSelf.headerView.nameTextFiled.text IdCard:weakSelf.headerView.numTextFiled.text];
        }
    };
}

/** post获取银行限额详情**/
- (void)postBankLimitAmount
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestBankLimit;
    info.dataParam = @{@"from":@"M"};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            NSMutableArray *tempArray = [LADAccoutModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"limitInfos"]];
            self.arr = tempArray;
            self.tableView.scrollEnabled = NO;
            [self setUpHeaderWithArr:tempArray];
            [self.tableView reloadData];
             self.tableView.scrollEnabled = YES;
        }
        
    } faild:^(NSError *error) {}];
}

- (void)setUpHeaderWithArr:(NSMutableArray *)arr
{
    self.headerView.dataArr = [NSArray arrayWithArray:arr];
}

//自定义返回
- (void)addBackItemWithAction
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhuianniu"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
}

- (void)doBack
{
    /*  此方法让多级跳转直接回到首页  */
    if (self.navigationController.viewControllers.count > 3) {
        
        AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
        HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
        dele.window.rootViewController = tabBarVC;
        [tabBarVC loginStatusWithNumber:1];
        tabBarVC.selectedIndex = 0;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    if (isSuccess) {
        // 开户成功，根据type 或者业务逻辑处理页面逻辑
        [MBProgressHUD showSuccess:@"开户成功"];
    } else {
        [MBProgressHUD showSuccess:@"开户失败"];
    }
    AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc] init];
    dele.window.rootViewController = tabBarVC;
    [tabBarVC loginStatusWithNumber:4];
}

// 统一开户
- (void)postOpenAccountWithUserName:(NSString *)userName IdCard:(NSString *)idCard
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
//    info.serviceString = DDRequestUserRegister;
    info.serviceString = DDRequestlmUserRegister;
    info.dataParam = @{@"userName":userName, @"idCard":idCard, @"form":@"M"};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject){
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {

            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            //
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"开户";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
//            JumpThirdParty.payType = MPPayTypeOpenAccount;
            [self.navigationController pushViewController:JumpThirdParty animated:YES];
            

        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
            
        }
    
    } faild:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arr.count > 0) {
        return self.arr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LADAccoutTVCell *cell = [LADAccoutTVCell creatLADAccoutTVCellWithTableView:tableView];
    if (self.arr.count > 0) {
        cell.model = self.arr[indexPath.row];
    }
    return cell;
}

@end
