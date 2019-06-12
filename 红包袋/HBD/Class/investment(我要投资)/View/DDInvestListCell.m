//
//  DDInvestListCell.m
//  HBD
//
//  Created by hongbaodai on 2017/9/28.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestListCell.h"
#import "DDProgressView.h"
#import "NSDate+Setting.h"
#import "OYCountDownManager.h"

@interface DDInvestListCell () <DDInvestDelegate>

@property (nonatomic, strong) UIButton *investBtn;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation DDInvestListCell
{
    NSString *secondNum;
    NSString *daydjs;
    NSString *daynow;
    NSString *s1;
    NSString *s2;
    int ksecond;  //秒
    int kminute;
    int khouse;
    int kday;
    UIView *proView; //进度上小圆点
    UILabel *proLab;
    double progress_;
}

+ (instancetype)investListCellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DDInvestListCell";
    DDInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }

    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.width_ = SCREEN_WIDTH - 16;

    // Initialization code
    [self initInvestBtnProgress];
    //设置进度圆点
    [self addProYuanView];
    //设置进度lab
    [self addProLable];
}


- (void)fillDataWithInvestList:(BXInvestmentModel *)model {
    _model = nil;
    _model = model;

    if (_model.TXY.length > 0) { // 加息  年化利率
        NSString *str = [NSString stringWithFormat:@"%g%%+%g%%",[_model.TXZ doubleValue] ,[_model.TXY doubleValue]];
        NSAttributedString *attr = [str homeAttributedStringWithSmallStr:@"%" smallFont:[UIFont systemFontOfSize:10.0f] bigFont:[UIFont systemFontOfSize:26.0f]];
        self.IncreasesInInterestRates.hidden = NO;
        self.pecentLab.attributedText = attr;

    } else { // 不加息  年化利率
        self.IncreasesInInterestRates.hidden = YES;
        if (_model.NHLL) { // 年化收益

            NSString *str = [NSString stringWithFormat:@"%g%%",[_model.NHLL doubleValue]];
            NSAttributedString *attr = [str homeAttributedStringWithSmallStr:@"%" smallFont:[UIFont systemFontOfSize:10.0f] bigFont:[UIFont systemFontOfSize:26.0f]];
            self.pecentLab.attributedText = attr;

        } else { // 既不加息 也无年化收益的情况
            self.pecentLab.text = @"";
        }
    }

    if (model.schedule) {
        progress_ = [model.schedule doubleValue];
    }
    
    if (model.SFTYB) {
        if ([model.SFTYB isEqualToString:@"3"]){
            self.activityImg.image = IMG(@"NewStandard");
//            self.activityLab.text = @"新手标";

        } else {
            self.activityImg.image = nil;
//            self.activityLab.text = nil;
        }
    }
    if (model.HKFS) {
        if ([model.HKFS isEqualToString:@"3"]) {
            self.dengEBXIma.image = IMG(@"dengeBEnxi");
        } else {
            self.dengEBXIma.image = nil;
        }
    }
    if (model.JKBT) { //标题
        self.titleLab.text = model.JKBT;
    }else{
        self.titleLab.text = @"红包袋";
    }

    
    if (model.HKZQSL) { //项目期限
        self.limitdayLab.text = [NSString stringWithFormat:@"%@",model.HKZQSL];
        
    }else{
        self.limitdayLab.text = @"0";
    }
    if (model.HKZQDW) { //项目期限单位
        
        if([_model.HKZQDW isEqualToString:@"1"]){ //天
            
            self.limitdayUnitLab.text = @"天";
        }else if([_model.HKZQDW isEqualToString:@"2"]){ //周
            
            self.limitdayUnitLab.text = @"周";
        }else if ([_model.HKZQDW isEqualToString: @"3"]) { //月
            
            self.limitdayUnitLab.text = @"个月";
        } if([_model.HKZQDW isEqualToString:@"4"]){ //年
            
            self.limitdayUnitLab.text = @"年";
        }
    }
    
    if (model.ZE) { //借款总额
//        if ([_model.ZE doubleValue] >= 10000) {
//            NSString *amount = [NSString stringWithFormat:@"%g",([model.ZE doubleValue] / 10000)];
//
//            self.amountLab.text = amount;
//            self.amountUnitLab.text = @"万元";
//        }else{
            NSString *amountStr = [NSString stringWithFormat:@"%.2lf",[model.ZE doubleValue]];
            self.amountLab.text = amountStr;
            self.amountUnitLab.text = @"元";
//        }
    }else{
        self.amountLab.text = @"0.00";
    }
 
    
#pragma mark ---点击倒计时----  日用毫秒处理 时分秒用转换后的时间处理
    //转成年月日，截止到日
//    _model.DJSKBSJ = @"1543896000000";
//    _model.nowDate = @"1543889436100";
    daydjs = [NSDate transformStrToDay:model.DJSKBSJ];
    daynow = [NSDate transformStrToDay:model.nowDate];
    
    //截止到日转成秒  如果加入时分秒天数会不准
    s1 = [NSDate transformTimeToChuo:daydjs];
    s2 = [NSDate transformTimeToChuo:daynow];

    double tempmms = [s1 doubleValue] - [s2 doubleValue];
    double tempInt = ([model.DJSKBSJ doubleValue] - [model.nowDate doubleValue])/1000; //秒差

    ksecond = (int)tempInt %60;  //秒
    kminute = (int)tempInt /60 %60;
    khouse  = (int)tempInt /60 /60 %24;
    kday    = (int)tempmms /60 /60 /24;

    if (![model.DJSKBSJ isEqualToString:@""] && tempInt > 0) {

        if (kday > 0) {  //大于1天
            NSString *investStr = [NSString stringWithFormat:@"%d天后 %@开标",kday,[NSDate ConvertStrToTime:model.DJSKBSJ]];
            [_investBtn setTitle:investStr forState:UIControlStateNormal];
            [self setInvestBtnSyleProgressNoTitle];
            
        } else if (kday==0  && khouse >= 2) {  //大于2小时
            
            //比较日期是不是一天
            if ([daydjs isEqualToString:daynow]) {    //是一天显示今日
                NSString *investStr = [NSString stringWithFormat:@"今日 %@开标",[NSDate ConvertStrToTime:model.DJSKBSJ]];
               
                [_investBtn setTitle:investStr forState:UIControlStateNormal];
                
            } else {    //不是一天显示1天后
               
                NSString *investStr = [NSString stringWithFormat:@"1天后 %@开标",[NSDate ConvertStrToTime:model.DJSKBSJ]];
                
                [_investBtn setTitle:investStr forState:UIControlStateNormal];
            }
            
            [self setInvestBtnSyleProgressNoTitle];
            
        } else if (kday== 0 && khouse < 2) {   //小于2小时 开始执行倒计时
            
            //获取倒计时秒数
            long int tempS = khouse *60 *60 + kminute * 60 + ksecond;
            secondNum = [NSString stringWithFormat:@"%ld",tempS];
            
            // 手动调用通知的回调
            [self countDownNotification];
            
        }

    }  else {
        //不倒计时 给kday个>0的值
        kday = 10;
        
        if ([_model.schedule isEqualToString:@"1"] || ([_model.schedule integerValue] == 1)) {
            progress_ = 0.0;
            [self initInvestBtnProgress];

            [self setInvestBtnSyleComplete]; // 已经满标
        }else{
            
            if ([_model.schedule doubleValue] == 0) {

                progress_ = 0.0;
                [self initInvestBtnProgress];

                [self setInvestBtnSyleZero]; // 出借为0

            } else {

                [self setInvestBtnSyleProgress];

                [self loadInvestProgress];

            }
        }
    }
}


//设置出借进度
- (void)loadInvestProgress {
    
    //设置出借进度
    [self initInvestBtnProgress];
    [self addProLable];
    [self addProYuanView];

    double prod = progress_ *100;
    if (prod < 15) { // 10
        proLab.x_ = 5;
        proView.x_ = 18;  // 10
    } else if (prod > 85) { // 90
        proLab.x_ = SCREEN_WIDTH-50;
        proView.x_ = self.progresVeiw.progressW-10-4;  // - 10-4
    } else {
        proLab.x_ = self.progresVeiw.progressW-40;
        proView.x_ = self.progresVeiw.progressW-10-4;
    }
    
}


//小圆点进度lab
- (void)addProLable {
    
    proLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, 50, 20)];
    [self.probackView addSubview:proLab];
    
    NSString *labStr = [NSString stringWithFormat:@"%.2f", progress_ *100];
    proLab.text = [NSString stringWithFormat:@"%@%%",labStr];
    
    proLab.font = FONT_11;
    proLab.textAlignment = NSTextAlignmentCenter;
    
}

//画小圆点
- (void)addProYuanView {
    
    proView = [[UIView alloc] initWithFrame:CGRectMake(10, 20-4, 8, 8)];
    [self.probackView addSubview:proView];
    proView.backgroundColor = [UIColor colorWithHexString:@"#ed7120"];
    proView.layer.cornerRadius = 4;
    proView.layer.masksToBounds = YES;
    
}


//初始化按钮和按钮进度
- (void)initInvestBtnProgress {
    self.progressBgView.frame = CGRectMake(8, 20, SCREEN_WIDTH-16, 44);

//    self.progressBgView.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
//    self.progressBgView.backgroundColor = [UIColor blueColor];
//    self.gradientLayer = [CAGradientLayer layer];
//    self.gradientLayer.frame = self.progressBgView.bounds;
//    [self.progressBgView.layer addSublayer:self.gradientLayer];
//
//    //设置渐变区域的起始和终止位置（范围为0-1）
//    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
//    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
//
//    //设置颜色数组
//    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:234.0/255.0 green:174.0/255.0 blue:59.0/255.0 alpha:1].CGColor,
//                                  (__bridge id)[UIColor colorWithRed:245.0/255.0 green:214.0/255.0 blue:71.0/255.0 alpha:1].CGColor];
//
//    //设置颜色分割点（范围：0-1）
//    self.gradientLayer.locations = @[@(0.5f), @(1.0f)];

    self.progressBgView.layer.cornerRadius = 22;
    self.progressBgView.layer.masksToBounds = YES;

    //[self.progresVeiw removeFromSuperview];
    self.progresVeiw = [[DDProgressView alloc] initWithFrame:CGRectMake(0, 0, self.progressBgView.width_, self.progressBgView.height_)];
    self.progresVeiw.progressW = (SCREEN_WIDTH-10) *progress_; //设置进度
    [self.progressBgView addSubview:self.progresVeiw];
    
 
    _investBtn = [[UIButton alloc] init];
    [self.progresVeiw addSubview:_investBtn];
    _investBtn.frame = self.progresVeiw.frame;
    [_investBtn addTarget:self action:@selector(investBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_investBtn setTitle:@"立即出借" forState:UIControlStateNormal];
    _investBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;//设置文字位置
//    [_investBtn setBackgroundColor:COLOUR_Clear];  // 这里是立即出借后面的颜色
    [_investBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
    [_investBtn setTitleColor:COLOUR_White forState:UIControlStateNormal];
    
}

//- (DDProgressView *)progresVeiw
//{
//    if (!_progresVeiw) {
//        _progresVeiw = [[DDProgressView alloc] initWithFrame:CGRectMake(0, 0, self.progressBgView.width_, self.progressBgView.height_)];
//
//        [self.progressBgView addSubview:self.progresVeiw];
//    }
//    return _progresVeiw;
//}

- (void)investBtnClick {

    if (self.investBlock) {
        self.investBlock();
    }
}



// ----------------倒计时------------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    
    if ([_model.DJSKBSJ isEqualToString:@""]
        || [_model.nowDate doubleValue] > [_model.DJSKBSJ doubleValue]
        ||kday > 0
        ||(kday==0 && khouse >= 2)){
        
        return;
    }
    

    
    /// --------------------------------------------------------
    /// 计算倒计时
    NSInteger countDown = [secondNum integerValue] - kCountDownManager.timeInterval;
    
    /// 当倒计时到了进行回调
    if (countDown <= 0) {
        
        [self setInvestBtnSyleProgress];
        
        if (self.countDownZero) {
            self.countDownZero();
        }
        
        return;
    }
    
    /// 重新赋值
    NSString *investStr = [NSString stringWithFormat:@"%01zd小时%02zd分%02zd秒", countDown/3600, (countDown/60)%60, countDown%60];
    [_investBtn setTitle:investStr forState:UIControlStateNormal];
     [self setInvestBtnSyleProgressNoTitle];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//出借中
- (void)setInvestBtnSyleProgress {
    
    [_investBtn setTitle:@"立即出借" forState:UIControlStateNormal];
//    [_investBtn setBackgroundColor:COLOUR_White];
    [_investBtn setTitleColor:COLOUR_White forState:UIControlStateNormal];
    [_investBtn setBackgroundImage:[UIImage imageNamed:@"yellowBack"] forState:UIControlStateNormal];


    [proLab removeFromSuperview];
    [proView removeFromSuperview];
}
//出借中不设titile
- (void)setInvestBtnSyleProgressNoTitle {
    
    [_investBtn setBackgroundImage:[UIImage imageNamed:@"garyBack"] forState:UIControlStateNormal];
    [_investBtn setTitleColor:COLOUR_Gray forState:UIControlStateNormal];

    [proLab removeFromSuperview];
    [proView removeFromSuperview];
}
//出借为0
- (void)setInvestBtnSyleZero {
    
    [_investBtn setTitle:@"立即出借" forState:UIControlStateNormal];
//    [_investBtn setBackgroundColor:COLOUR_BTN_BLUE_NEW];
    [_investBtn setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];

    [_investBtn setTitleColor:COLOUR_White forState:UIControlStateNormal];
    [proLab removeFromSuperview];
    [proView removeFromSuperview];
}
//满标
- (void)setInvestBtnSyleComplete {
    
    [_investBtn setTitle:@"已经满标" forState:UIControlStateNormal];
//    [_investBtn setBackgroundColor:[UIColor colorWithHexString:COLOUR_YELLOW]];
    [_investBtn setBackgroundImage:[UIImage imageNamed:@"yellowBack"] forState:UIControlStateNormal];
    [_investBtn setTitleColor:COLOUR_White forState:UIControlStateNormal];
    [proLab removeFromSuperview];
    [proView removeFromSuperview];
}


@end
