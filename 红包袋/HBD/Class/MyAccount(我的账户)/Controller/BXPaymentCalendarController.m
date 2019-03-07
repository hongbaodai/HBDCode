//
//  BXPaymentCalendarController.m
//  
//
//  Created by echo on 16/2/25.
//
//      回款日历      

#import "BXPaymentCalendarController.h"
#import "BXPaymentCalendarCell.h"
#import "BXPaymentOneCell.h"
#import "BXPaymentTwoCell.h"
#import "BXPaymentCalendarModel.h"
#import "BXCalendarDefaultCell.h"

@interface BXPaymentCalendarController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
// 日历显示数组
@property (nonatomic, strong) NSArray  *calendarArray;
// 单日详情数组
@property (nonatomic, strong) NSArray  *paymentArray;
// 单日强请列表
@property (nonatomic, strong) NSDictionary  *dict;

// 选中的日期
@property (nonatomic, strong) NSString *selecDateStr;


@end

@implementation BXPaymentCalendarController
{
    NSDateFormatter *_formatter;
    BOOL isOpen;
    NSInteger _selectedIndex;
}

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *view = [[UIView alloc]initWithFrame:applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    _formatter = [[NSDateFormatter alloc]init];
    
    _calendarView = [[RDVCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 400)];
    _calendarView.dayCellHeight = 26.4;
//    _calendarView.dayCellHeight = 36.4;

    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    [_calendarView setDelegate:self];
    
    _formatter.dateFormat = @"yyyy年MM月";
    NSDate *date = [_formatter dateFromString:_calendarView.monthLabel.text];
    _formatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [_formatter stringFromDate:date];
    [self postReturnMoneyCalendarMonthWihtDate:dateStr];
    
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"回款计划";
    [[self.navigationController navigationBar] setTranslucent:NO];
    [[self calendarView] registerDayCellClass:[BXPaymentCalendarCell class]];
    
//    UIBarButtonItem *allButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"出借记录", nil)
//                                                                  style:UIBarButtonItemStylePlain
//                                                                 target:self
//                                                                 action:@selector(showAllRecords)];
//    [self.navigationItem setRightBarButtonItem:allButton];
}

//- (void)showAllRecords
//{
//
//}

- (void)calendarView:(RDVCalendarView *)calendarView didChangeHeaderViewHeight:(CGFloat)tablHeight
{
    CGRect fr = _calendarView.frame;
    fr.size.height = tablHeight;
    _calendarView.frame = fr;
    CGRect reec = _calendarView.topView.frame;
    reec.size.height = 102;
    _calendarView.topView.frame = reec;

    CGRect reecstate = _calendarView.stateView.frame;
    reecstate.size.height = 90;
    reecstate.origin.y = CGRectGetHeight(_calendarView.frame) - 90;
    _calendarView.stateView.frame = reecstate;
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
    NSString *date1 = [formatter stringFromDate:date];
    self.selecDateStr = date1;
    [self postReturnMoneyCalendarDayWithDate:date1];
}

- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell atIndex:(NSInteger)index
{
    BXPaymentCalendarCell *exampleCell = (BXPaymentCalendarCell *)dayCell;

    RDVCalendarView *exampleView = (RDVCalendarView *)calendarView;
    
    NSDate *date = [exampleView dateForIndex:index];
    _formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [_formatter stringFromDate:date];

    RDVCalendarView *calendarViwe = (RDVCalendarView *)exampleCell.superview;
    NSDate *newDa = calendarViwe.selectedDate;
    NSString *newDatime = [_formatter stringFromDate:newDa];


    [dayCell.textLabel setTextColor:[UIColor colorWithHex:@"#222222"]];

    if (![time isEqualToString:newDatime]) {
        for (NSDictionary *dict in self.calendarArray) {
            BXPaymentCalendarModel *model = [BXPaymentCalendarModel mj_objectWithKeyValues:dict];
            if ([model.HKRQ isEqual:time] && ![exampleCell.textLabel.text isEqualToString:@"今天"]) {
                //            [self some];
                [self setSomeShow:model cell:exampleCell];
                
                break;
            }
        }

    } else {
        exampleCell.stategroundView.hidden = YES;
    }
    
    if (([self weekdayByDate:date] == 1) || ([self weekdayByDate:date] == 7 )) {
        if ([exampleCell.textLabel.text isEqualToString:@"今天"]) {
            exampleCell.textLabel.textColor = COLOUR_BTN_BLUE_NEW; // colorWithHex:@"#038cff"
            if (self.dict == nil) {
                [self postReturnMoneyCalendarDayWithDate:time];
            }
        }
//        else {
//            exampleCell.textLabel.textColor = [UIColor colorWithHex:@"#666666"];
//        }

    } else {
        if ([exampleCell.textLabel.text isEqualToString:@"今天"]) {
            exampleCell.textLabel.textColor = COLOUR_BTN_BLUE_NEW; //
            if (self.dict == nil) {
                [self postReturnMoneyCalendarDayWithDate:time];
            }
        }
//        else {
//            exampleCell.textLabel.textColor = [UIColor colorWithHex:@"#222222"];
//        }
    }
}

- (void)setSomeShow:(BXPaymentCalendarModel *)model cell:(BXPaymentCalendarCell *)exampleCell
{


    if ([model.YQSM integerValue] > 0) {  // 逾期数目
        [self seimgStr:@"greenS" cell:exampleCell];
    }

    if ([model.WHSM integerValue] > 0) { // 未回
        [self seimgStr:@"redS" cell:exampleCell];
    }

    if ([model.YSSM integerValue] > 0) { // 已回
        [self seimgStr:@"orginS" cell:exampleCell];

    }
}

- (void)seimgStr:(NSString *)imgStr cell:(BXPaymentCalendarCell *)exampleCell
{
    [exampleCell.stategroundView setHidden:NO];
    [exampleCell.stategroundView setImage:[UIImage imageNamed:imgStr]];
    [exampleCell.textLabel setTextColor:[UIColor whiteColor]];
}

/*

- (void)some
{
 // 原来这里关于逾期 已回 未回的逻辑判断
    if ([model.YQSM integerValue] > 0) {
        [[exampleCell upTypeLabel] setHidden:NO];
        [exampleCell upTypeLabel].text = [NSString stringWithFormat:@"逾期(%@)",model.YQSM];
        [exampleCell upTypeLabel].textColor = [UIColor colorWithHex:@"#ff0000"];


        [exampleCell.showStateImageView setHighlighted:NO];
        exampleCell.showStateImageView.image = [UIImage imageNamed:@"greenS"];

        if ([model.WHSM integerValue] > 0 && [model.YSSM integerValue] > 0) {
            [[exampleCell downTypeLabel] setHidden:NO];
            [exampleCell downTypeLabel].text = @"···";
            [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#038cff"];
        } else if ([model.WHSM integerValue] > 0){
            [[exampleCell downTypeLabel] setHidden:NO];
            [exampleCell downTypeLabel].text = [NSString stringWithFormat:@"未回(%@)",model.WHSM];
            [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#43b207"];


            exampleCell.showStateImageView.image = [UIImage imageNamed:@"redS"];

        } else if ([model.YSSM integerValue] > 0){
            [[exampleCell downTypeLabel] setHidden:NO];
            [exampleCell downTypeLabel].text = [NSString stringWithFormat:@"已回(%@)",model.YSSM];
            [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#666666"];


            exampleCell.showStateImageView.image = [UIImage imageNamed:@"orginS"];

        } else {
            // 下标签隐藏
        }
    } else {
        if ([model.WHSM integerValue] > 0) {
            [[exampleCell upTypeLabel] setHidden:NO];
            [exampleCell upTypeLabel].text = [NSString stringWithFormat:@"未回(%@)",model.WHSM];
            [exampleCell upTypeLabel].textColor = [UIColor colorWithHex:@"#43b207"];


            [exampleCell.showStateImageView setHighlighted:NO];
            exampleCell.showStateImageView.image = [UIImage imageNamed:@"redS"];

            if ([model.YSSM integerValue] > 0) {
                [[exampleCell downTypeLabel] setHidden:NO];
                [exampleCell downTypeLabel].text = [NSString stringWithFormat:@"已回(%@)",model.YSSM];
                [exampleCell downTypeLabel].textColor = [UIColor colorWithHex:@"#666666"];



                exampleCell.showStateImageView.image = [UIImage imageNamed:@"orginS"];

            } else {
                // 下标签隐藏
            }
        } else {
            if ([model.YSSM integerValue] > 0) {
                [[exampleCell upTypeLabel] setHidden:NO];
                [exampleCell upTypeLabel].text = [NSString stringWithFormat:@"已回(%@)",model.YSSM];
                [exampleCell upTypeLabel].textColor = [UIColor colorWithHex:@"#666666"];

                exampleCell.upTypeLabel.backgroundColor = [UIColor cyanColor];

                [exampleCell.showStateImageView setHighlighted:NO];
                exampleCell.showStateImageView.image = [UIImage imageNamed:@"orginS"];

            } else {
                // 上下标签都隐藏
            }
        }
    }
}
 */

- (void)calendarView:(RDVCalendarView *)calendarView didChangeMonth:(NSDateComponents *)month
{
    _formatter.dateFormat = @"yyyy年MM月";
    NSDate *date = [_formatter dateFromString:_calendarView.monthLabel.text];
    _formatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [_formatter stringFromDate:date];
    [self postReturnMoneyCalendarMonthWihtDate:dateStr];

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
    if (self.paymentArray.count == 0) {
        return 170;
    }  else {
//        if (indexPath.row == 0) {
//            return 109;
//        } else {
            if (indexPath.row == _selectedIndex) {
                if (isOpen == YES) {
                    return 151;
                } else {
                    return 44;
                }
            } else {
                return 44;
            }
//        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.paymentArray.count + 1;
    if (self.paymentArray.count <= 0) {
        return 1;
    }
    return self.paymentArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.paymentArray.count == 0) {
        BXCalendarDefaultCell *cell = [BXCalendarDefaultCell bxCalendarDefaultCellWithTableView:tableView];
        [cell fillWithType:@"回款"];
        return cell;
    } else {
//        if (indexPath.row == 0) {
//            BXPaymentOneCell *cell = [BXPaymentOneCell bxPaymentOneCellWithTableView:tableView];
//            [cell makeUIWithReturnMoney:self.dict];
//                       return cell;
//        } else {
            BXPaymentTwoCell *cell = [BXPaymentTwoCell bxPaymentTwoCellWithTableView:tableView];
//            BXPaymentModel *model = [BXPaymentModel mj_objectWithKeyValues:self.paymentArray[indexPath.row - 1]];
        BXPaymentModel *model = [BXPaymentModel mj_objectWithKeyValues:self.paymentArray[indexPath.row]];

            [cell fillInWithPaymentModel:model];
            [cell makeUIWithSelecIndex:_selectedIndex index:indexPath open:isOpen];
            return cell;
//        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row != 0) {
        //将索引加到数组中
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        //判断选中不同row状态时候
        if (indexPath.row == _selectedIndex) {
            //将选中的和所有索引都加进数组中
            isOpen = !isOpen;
            
        } else if (indexPath.row != _selectedIndex) {
            NSIndexPath *ii = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
            indexPaths = [NSArray arrayWithObjects:indexPath,ii, nil];
            isOpen = YES;
        }
        //记下选中的索引
        _selectedIndex = indexPath.row;
        
        //刷新
        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    }
}

// 获取本月回款数据
- (void)postReturnMoneyCalendarMonthWihtDate:(NSString *)date
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestReturnMoneyCalendarMonth;
    info.dataParam = @{@"JZRQ":date};  // 格式2015-04
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];

        self.calendarArray = dict[@"body"][@"plantList"];
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
        [self postReturnMoneyCalendarDayWithDate:todayStr];
    } else {
        if (array.count != 0) {
            BXPaymentCalendarModel *model = [BXPaymentCalendarModel mj_objectWithKeyValues:array.firstObject];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSDate *selectedDate = [formatter dateFromString:model.HKRQ];
            self.calendarView.selectedDate = selectedDate;
            [self postReturnMoneyCalendarDayWithDate:model.HKRQ];
        } else {
            formatter.dateFormat = @"yyyy-MM";
            NSString *monthStr = [formatter stringFromDate:calendarMonth];
            NSString *firstDayStr = [NSString stringWithFormat:@"%@-01",monthStr];
            formatter.dateFormat = @"yyyy-MM-dd";

            NSDate *firstDate = [formatter dateFromString:firstDayStr];
            self.calendarView.selectedDate = firstDate;
            [self postReturnMoneyCalendarDayWithDate:firstDayStr];
        }
    }
}

// 获取某一天的回款数据
- (void)postReturnMoneyCalendarDayWithDate:(NSString *)date
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestReturnMoneyCalendarDay;
    info.dataParam = @{@"JZRQ":date};  // 格式2015-04-05
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];

        self.dict = dict;
        self.paymentArray= dict[@"body"][@"plantList"];
        _selectedIndex = 0;
        [self.tableView reloadData];
        [self setReloadData];
        
    } faild:^(NSError *error) {
        
    }];
}

- (void)setReloadData
{
    if (self.dict[@"body"][@"amountMonth"]) {
        self.calendarView.topView.mouthMoneyLab.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:self.dict[@"body"][@"amountMonth"]]];

    } else {
        self.calendarView.topView.mouthMoneyLab.text = @"￥0.00";
    }
    if (self.dict[@"body"][@"amountDay"]) {
        self.calendarView.topView.dayMoneyLab.text = [NSString stringWithFormat:@"￥%@",[self roundWithInput:self.dict[@"body"][@"amountDay"]]];

    } else {
        self.calendarView.topView.dayMoneyLab.text = @"￥0.00";
    }
}

// 四舍五入并保留两位小数
- (NSString *)roundWithInput:(NSString *)input
{
    double i = (double)([input doubleValue] * 100.0 + 0.5);
    int j = (int)i;
    double x = (double)(j / 100.0);

    NSString *result = [NSString stringWithFormat:@"%.2lf",x];
    return result;
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:self.title];
    
    if ([self clearsSelectionOnViewWillAppear]) {
        [[self calendarView] deselectDayCellAtIndex:[[self calendarView] indexForSelectedDayCell] animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)creatVCFromStroyboard
{
    return [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"BXPaymentCalendarController"];
}

@end
