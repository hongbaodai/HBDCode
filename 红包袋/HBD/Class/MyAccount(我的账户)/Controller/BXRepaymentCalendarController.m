//
//  BXRepaymentCalendarController.m
//
//
//  Created by echo on 16/2/25.
//
//  还款日历

#import "BXRepaymentCalendarController.h"
#import "BXRepaymentCalendarCell.h"
#import "BXPaymentOneCell.h"
#import "BXRepaymentTwoCell.h"
#import "BXRepaymentCalendarModel.h"
#import "BXCalendarDefaultCell.h"
#import "BXHFRechargeController.h"

@interface BXRepaymentCalendarController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
// 日历显示数组
@property (nonatomic, strong) NSArray  *calendarArray;
// 单日详情数组
@property (nonatomic, strong) NSArray  *repaymentArray;
// 单日详情列表
@property (nonatomic, strong) NSDictionary  *dict;

@end

@implementation BXRepaymentCalendarController
{
    NSDateFormatter *_formatter;
    BOOL isOpen;
    NSInteger _selectedIndex;
    UIView *_topAltView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"还款日历";
    [[self.navigationController navigationBar] setTranslucent:NO];
    [[self calendarView] registerDayCellClass:[BXRepaymentCalendarCell class]];
}

// 顶部View
- (void)addTopAlterView
{
    _topAltView = [[UIView alloc]initWithFrame:CGRectMake(0, -39, SCREEN_SIZE.width, 39)];
    _topAltView.backgroundColor = [UIColor colorWithHex:@"#ffaf37"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width - 52 - 15, 9, 52, 21)];
    imageView.image = [UIImage imageNamed:@"calendar_chongzhi"];
    [_topAltView addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, SCREEN_SIZE.width-90, 21)];
    label.text = @"您的账户余额不足支付本次还款，请及时充值！";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    [_topAltView addSubview:label];
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    coverBtn.frame = _topAltView.bounds;
    coverBtn.titleLabel.text = @"";
    [coverBtn addTarget:self action:@selector(didRechargeBtn) forControlEvents:UIControlEventTouchUpInside];
    [_topAltView addSubview:coverBtn];
    
    [self.view addSubview:_topAltView];
    
    [UIView animateWithDuration:1.0 animations:^{
    _topAltView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 39);
    self.tableView.frame = CGRectMake(0, 39, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 39);
    }];
}

// 移除顶部按钮
- (void)removeTopAlterView
{
    [UIView animateWithDuration:1.0 animations:^{
        _topAltView.frame = CGRectMake(0, -39, SCREEN_SIZE.width, 39);
        self.tableView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64);
    }completion:^(BOOL finished) {
        [_topAltView removeFromSuperview];
    }];

}

// 点击充值按钮
- (void)didRechargeBtn
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    BXHFRechargeController *HFRecharge = [storyboard instantiateViewControllerWithIdentifier:@"BXHFRechargeVC"];
    [self.navigationController pushViewController:HFRecharge animated:YES];
}

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *view = [[UIView alloc]initWithFrame:applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    _formatter = [[NSDateFormatter alloc]init];
    
    _calendarView = [[RDVCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 400)];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    [_calendarView setDelegate:self];
    

    _formatter.dateFormat = @"yyyy年MM月";
    NSDate *date = [_formatter dateFromString:_calendarView.monthLabel.text];
    _formatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [_formatter stringFromDate:date];
    [self postRepaymentCalendarMonthWihtDate:dateStr];

    //    [self.view addSubview:_calendarView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = _calendarView;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    tableView.tableFooterView = footView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    _selectedIndex = 0;

    // 添加左右滑动手势
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_calendarView addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [_calendarView addGestureRecognizer:recognizer];
}

// 手势滑动事件
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [_calendarView showNextMonth];
        
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [_calendarView showPreviousMonth];
    }
}

- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index
{

}

- (void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date1 =[formatter stringFromDate:date];
    [self postRepaymentCalendarDayWithDate:date1];
}

- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell atIndex:(NSInteger)index
{
    BXRepaymentCalendarCell *exampleCell = (BXRepaymentCalendarCell *)dayCell;
    RDVCalendarView *exampleView = (RDVCalendarView *)calendarView;
    
    NSDate *date = [exampleView dateForIndex:index];
    _formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [_formatter stringFromDate:date];
    
    for (NSDictionary *dict in self.calendarArray) {
        BXRepaymentCalendarModel *model = [BXRepaymentCalendarModel mj_objectWithKeyValues:dict];
        if ([model.HKRQ isEqual:time]) {
            
            if ([model.YQSM integerValue] > 0) {
                [[exampleCell upTypeLabel] setHidden:NO];
                [exampleCell upTypeLabel].text = [NSString stringWithFormat:@"逾期(%@)",model.YQSM];
                [exampleCell upTypeLabel].textColor = [UIColor colorWithHex:@"#ff0000"];
                if ([model.WHSM integerValue] > 0 && [model.YHSM integerValue] > 0) {
                    [[exampleCell downTypeLabel] setHidden:NO];
                    [exampleCell downTypeLabel].text = @"···";
                    [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#038cff"];
                } else if ([model.WHSM integerValue] > 0){
                    [[exampleCell downTypeLabel] setHidden:NO];
                    [exampleCell downTypeLabel].text = [NSString stringWithFormat:@"未还(%@)",model.WHSM];
                    [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#038cff"];
                } else if ([model.YHSM integerValue] > 0){
                    [[exampleCell downTypeLabel] setHidden:NO];
                    [exampleCell downTypeLabel].text = [NSString stringWithFormat:@"已还(%@)",model.YHSM];
                    [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#666666"];
                } else {
                    // 下标签隐藏
                }
            } else {
                if ([model.WHSM integerValue] > 0) {
                    [[exampleCell upTypeLabel] setHidden:NO];
                    [exampleCell upTypeLabel].text = [NSString stringWithFormat:@"未还(%@)",model.WHSM];
                    [exampleCell upTypeLabel].textColor = [UIColor colorWithHex:@"#038cff"];
                    if ([model.YHSM integerValue] > 0) {
                        [[exampleCell downTypeLabel] setHidden:NO];
                        [exampleCell downTypeLabel].text = [NSString stringWithFormat:@"已还(%@)",model.YHSM];
                        [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#666666"];
                    } else {
                        // 下标签隐藏
                    }
                } else {
                    if ([model.YHSM integerValue] > 0) {
                        [[exampleCell upTypeLabel] setHidden:NO];
                        [exampleCell upTypeLabel].text = [NSString stringWithFormat:@"已还(%@)",model.YHSM];
                        [exampleCell upTypeLabel].textColor = [UIColor colorWithHex:@"#666666"];
                    } else {
                        // 上下标签都隐藏
                    }
                }
            }
            break;
        }
    }
    
    if (([self weekdayByDate:date] == 1) || ([self weekdayByDate:date] == 7 )) {
        if ([exampleCell.textLabel.text isEqualToString:@"今天"]) {
            exampleCell.textLabel.textColor = [UIColor colorWithHex:@"#038cff"];
            if (self.dict == nil) {
                [self postRepaymentCalendarDayWithDate:time];
            }
        } else {
            exampleCell.textLabel.textColor = [UIColor colorWithHex:@"#666666"];
        }
    } else {
        if ([exampleCell.textLabel.text isEqualToString:@"今天"]) {
            exampleCell.textLabel.textColor = [UIColor colorWithHex:@"#038cff"];
            if (self.dict == nil) {
                [self postRepaymentCalendarDayWithDate:time];
            }
        } else {
            exampleCell.textLabel.textColor = [UIColor colorWithHex:@"#222222"];
        }
    }
}

- (void)calendarView:(RDVCalendarView *)calendarView didChangeMonth:(NSDateComponents *)month
{
    _formatter.dateFormat = @"yyyy年MM月";
    NSDate *date = [_formatter dateFromString:_calendarView.monthLabel.text];
    _formatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [_formatter stringFromDate:date];
    [self postRepaymentCalendarMonthWihtDate:dateStr];
    
}

// 根据日期判断周几
- (NSInteger)weekdayByDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger _weekday = [weekdayComponents weekday];
    return _weekday;
}

#pragma tableView DelegateMethods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.repaymentArray.count == 0) {
        return 170;
    } else {
        if (indexPath.row == 0) {
            return 109;
        } else {
            if (indexPath.row == _selectedIndex) {
                if (isOpen == YES) {
                    return 150;
                } else {
                    return 44;
                }
            } else {
                return 44;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repaymentArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.repaymentArray.count == 0) {
        BXCalendarDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"BXCalendarDefaultCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell fillWithType:@"回款"];
        return cell;
    }else{
        if (indexPath.row == 0) {
            BXPaymentOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentOneCell"];
            if (!cell) {
                cell=[[NSBundle mainBundle]loadNibNamed:@"BXPaymentOneCell" owner:nil options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.upTypeLabel.text = @"本月剩余回款";
            cell.downTypeLabel.text = @"今日剩余回款";
            if (self.dict[@"body"][@"amountMonth"]) {
                cell.upAmoutLabel.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:self.dict[@"body"][@"amountMonth"]]];
            }else{
                cell.upAmoutLabel.text = @"￥0.00";
            }
            if (self.dict[@"body"][@"amountDay"]) {
                cell.downAmoutLabel.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:self.dict[@"body"][@"amountDay"]]];
            }else{
                cell.downAmoutLabel.text = @"￥0.00";
            }
            
            return cell;
        } else {
            
            BXRepaymentTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTwoCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"BXPaymentTwoCell" owner:nil options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            BXRepaymentModel *model = [BXRepaymentModel mj_objectWithKeyValues:self.repaymentArray[indexPath.row - 1]];
            [cell fillInWithRepaymentModel:model];
            if (indexPath.row == _selectedIndex) {
                //如果是展开
                if (isOpen == YES) {
                    //xxxxxx
                    cell.bottomView.hidden = NO;
                    cell.separationView.hidden = NO;
                }else{
                    //收起
                    cell.bottomView.hidden= YES;
                    cell.separationView.hidden = YES;
                }
                
                //不是自身
            } else {
                
            }
            return cell;
        }
        
    }
}

// 四舍五入并保留两位小数
- (NSString *)roundWithInput:(NSString *)input{
    
    double i = (double)([input doubleValue] * 100.0 + 0.5);
    int j = (int)i;
    double x = (double)(j / 100.0);
    
    NSString *result = [NSString stringWithFormat:@"%.2lf",x];
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        //将索引加到数组中
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        //判断选中不同row状态时候
        if (indexPath.row == _selectedIndex) {
            //将选中的和所有索引都加进数组中
            isOpen = !isOpen;
            
        }else if (indexPath.row != _selectedIndex) {
            NSIndexPath *ii = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
            indexPaths = [NSArray arrayWithObjects:indexPath,ii, nil];
            isOpen = YES;
        }
        //记下选中的索引
        _selectedIndex = indexPath.row;
        //刷新
        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 获取本月还款数据
- (void)postRepaymentCalendarMonthWihtDate:(NSString *)date
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestRepaymentCalendarMonth;
    info.dataParam = @{@"JZRQ":date};  // 格式2015-04
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];

        self.calendarArray = dict[@"body"][@"loanPhaseList"];
        
        [self judgeSelectedDateWithDict:self.calendarArray];

        [self.calendarView reloadData];
    } faild:^(NSError *error) {
        
    }];
}

// 判断选中为哪天
- (void)judgeSelectedDateWithDict:(NSArray *)array
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月";
    NSDate *calendarMonth = [formatter dateFromString:self.calendarView.monthLabel.text];
    NSDate *currentMouth = [NSDate date];
    NSString *nowStr=[formatter stringFromDate:currentMouth];
    NSDate *nowDate = [formatter dateFromString:nowStr];
    
    if ([calendarMonth compare:nowDate] == NSOrderedSame) {
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *todayStr = [formatter stringFromDate:currentMouth];
        NSDate *todayDate = [formatter dateFromString:todayStr];
        self.calendarView.selectedDate = todayDate;
        [self postRepaymentCalendarDayWithDate:todayStr];
        
    } else {
        if (array.count != 0) {
            BXRepaymentCalendarModel *model = [BXRepaymentCalendarModel mj_objectWithKeyValues:array.firstObject];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSDate *selectedDate = [formatter dateFromString:model.HKRQ];
            self.calendarView.selectedDate = selectedDate;
            [self postRepaymentCalendarDayWithDate:model.HKRQ];
        } else {
            formatter.dateFormat = @"yyyy-MM";
            NSString *monthStr = [formatter stringFromDate:calendarMonth];
            NSString *firstDayStr = [NSString stringWithFormat:@"%@-01",monthStr];
            formatter.dateFormat = @"yyyy-MM-dd";
//            NSDate *firstDate = [formatter dateFromString:firstDayStr];
//            self.calendarView.selectedDate = firstDate;
            [self postRepaymentCalendarDayWithDate:firstDayStr];
        }
    }
}

// 获取某一天的还款数据
- (void)postRepaymentCalendarDayWithDate:(NSString *)date
{
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestRepaymentCalendarDay;
    info.dataParam = @{@"JZRQ":date};  // 格式2015-04-05
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];

        self.dict = dict;
        self.repaymentArray= dict[@"body"][@"loanList"];
        _selectedIndex = 0;
        [self.tableView reloadData];
        if ([self.dict[@"body"][@"repaymentAmout"] doubleValue] > [self.dict[@"body"][@"cash"] doubleValue]) {
            if (!_topAltView || _topAltView.frame.origin.y != 0) {
                [self addTopAlterView];
            }
        } else {
            if (_topAltView && _topAltView.frame.origin.y == 0) {
                [self removeTopAlterView];
            }
        }
        
    } faild:^(NSError *error) {
        
    }];
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    
    if ([self clearsSelectionOnViewWillAppear]) {
        [[self calendarView] deselectDayCellAtIndex:[[self calendarView] indexForSelectedDayCell] animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

+ (instancetype)creatVCFromStroyboard
{
    return [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"BXRepaymentCalendarVC"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
