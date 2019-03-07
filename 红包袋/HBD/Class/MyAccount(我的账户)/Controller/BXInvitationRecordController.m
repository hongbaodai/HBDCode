//
//  BXInvitationRecordController.m
//  
//
//  Created by echo on 16/3/15.
//
//

#import "BXInvitationRecordController.h"
#import "BXInviteFriendsCell.h"
#import "BXInvestRecordsModel.h"
#import "HXRefresh.h"

@interface BXInvitationRecordController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView  *tableView;
@property (nonatomic, strong) NSArray  *dataArray;

@end

@implementation BXInvitationRecordController
{
    int intPage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"邀请记录";
    intPage = 1;
    
    [self settingFrame];
    [self setupRefresh];
    [self loadNewStatus];
}

// 添加下拉刷新
- (void)setupRefresh
{
    [HXRefresh setHeaderRefresnWithVC:self tableView:self.tableView headerAction:@selector(loadNewStatus)];
}

// 刷新方法
- (void)loadNewStatus
{
    intPage = 1;
    self.dataArray = nil;
    NSString *strPage = [NSString stringWithFormat:@"%d",intPage];
    [self postInviteFriendsListWithPageNum:strPage PageSize:@"20"];
}

// 添加上拉加载
- (void)setupLoadMore
{
    [HXRefresh setFooterRefreshWithVC:self tableView:self.tableView footerAction:@selector(loadMoreStatus)];
}

// 加载新数据
- (void)loadMoreStatus
{
    if (![self.tableView.mj_header isRefreshing]) {
        intPage += 1;
        NSString *strPage = [NSString stringWithFormat:@"%d",intPage];
        [self postInviteFriendsListWithPageNum:strPage PageSize:@"20"];
    }
}

- (void)settingFrame
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count) {
        BXInviteFriendsCell *cell;
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendsListCell" forIndexPath:indexPath];
        }
        if (indexPath.row == 0) {
            cell.inviteenicenameLab.text = @"直接好友";
            cell.inviteeregdateLab.text = @"注册时间";
            cell.inviteemoneyLab.text = @"邀请奖励";
            cell.inviteCountLab.text = @"间接好友人数";
            if (IS_IPHONE5 || IS_IPHONE4) {
                cell.inviteenicenameLab.font = [UIFont systemFontOfSize:11];
                cell.inviteeregdateLab.font = [UIFont systemFontOfSize:11];
                cell.inviteemoneyLab.font = [UIFont systemFontOfSize:11];
                cell.inviteCountLab.font = [UIFont systemFontOfSize:11];
            } else {
                cell.inviteenicenameLab.font = [UIFont systemFontOfSize:13];
                cell.inviteeregdateLab.font = [UIFont systemFontOfSize:13];
                cell.inviteemoneyLab.font = [UIFont systemFontOfSize:13];
                cell.inviteCountLab.font = [UIFont systemFontOfSize:13];
            }
            cell.inviteenicenameLab.textColor = [UIColor colorWithHex:@"#222222"];
            cell.inviteeregdateLab.textColor = [UIColor colorWithHex:@"#222222"];
            cell.inviteemoneyLab.textColor = [UIColor colorWithHex:@"#222222"];
            cell.inviteCountLab.textColor = [UIColor colorWithHex:@"#222222"];
            return cell;
        } else {
            BXInviteFriendsListModel *model = self.dataArray[indexPath.row - 1];
            [cell fillInWithInviteFriendsListModel:model];
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
        cell.backgroundColor = [UIColor colorWithHex:@"eeeeee"];
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView customCellForRowAtIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    } else {
        cell.backgroundColor = [UIColor colorWithHex:@"#f6f6f6"];
    }
    if (self.dataArray.count == 0) {
        cell.backgroundColor = [UIColor colorWithHex:@"#eeeeee"];
    }
    return cell;
}

/* 邀请好友列表 */
- (void)postInviteFriendsListWithPageNum:(NSString *)pageNum PageSize:(NSString *)pageSize
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestInviteFriends;
    info.dataParam = @{@"pageNum":pageNum,@"pageSize":pageSize,@"vobankIdTemp":@""};
    
    __weak BXInvitationRecordController *inviteSelfVC = self;
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        
        if (![dict[@"body"][@"resultcode"] intValue]) {
            
            NSArray *dataArray = [BXInviteFriendsListModel mj_objectArrayWithKeyValuesArray:dict[@"body"][@"pageData"][@"data"]];
            
            if (dataArray.count) {
//                if (intPage <= ([dict[@"body"][@"pageData"][@"totalCount"] intValue] / [pageSize intValue]) + 1) {
                    if (intPage <= ([dict[@"body"][@"pageData"][@"pageCount"] intValue])) {
                    NSMutableArray *temp = [NSMutableArray  array];
                    if (![temp isEqual:inviteSelfVC.dataArray]) {
                        [temp addObjectsFromArray:inviteSelfVC.dataArray];
                        [temp addObjectsFromArray:dataArray];
                        inviteSelfVC.dataArray = temp;
                        
                        if (inviteSelfVC.dataArray.count >= 20) {
                            [self setupLoadMore];
                        }
                    }
                    [inviteSelfVC.tableView.mj_footer endRefreshing];
                    [inviteSelfVC.tableView.mj_header endRefreshing];
                    self.tableView.scrollEnabled =YES;
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [inviteSelfVC.tableView.mj_footer endRefreshing];
                        [inviteSelfVC.tableView.mj_footer endRefreshingWithNoMoreData];
                        [inviteSelfVC.tableView.mj_header endRefreshing];
                        self.tableView.scrollEnabled =YES;
                    });
                }
                
                [inviteSelfVC.tableView reloadData];
            } else {
                //                [MBProgressHUD showError:@"暂无邀请记录"];
                [inviteSelfVC.tableView.mj_header endRefreshing];
                [inviteSelfVC.tableView reloadData];
            }
            
        } else {
            [inviteSelfVC.tableView.mj_footer endRefreshing];
            [inviteSelfVC.tableView.mj_header endRefreshing];
        }
        
    } faild:^(NSError *error) {
        //干掉菊花
        [self.tableView.mj_footer endRefreshing];
        // 3.干倒菊花
        [self.tableView.mj_header endRefreshing];
        self.tableView.scrollEnabled =YES;
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
