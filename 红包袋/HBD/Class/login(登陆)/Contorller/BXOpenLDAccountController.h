//
//  BXOpenLDAccountController.h
//  HBD
//
//  Created by echo on 16/8/9.
//

#import <UIKit/UIKit.h>
#import "BaseNormolViewController.h"
#import "BXJumpThirdPartyController.h"

@interface BXOpenLDAccountController : BaseNormolViewController <PayThirdPartyProtocol,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) UIView *pageView;
// 判断入口，执行相应页面逻辑
@property (nonatomic, copy) NSString *type;


- (void)addBackItemWithAction;

- (void)postBankLimitAmount;

- (void)postOpenAccountWithUserName:(NSString *)userName IdCard:(NSString *)idCard;

@end
