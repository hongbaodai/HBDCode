//
//  AletStrViewController.m
//  HBD
//
//  Created by hongbaodai on 2017/12/28.
//

#import "AletStrViewController.h"
#import "NSString+Other.h"
#import "AppDelegate.h"
#import "HXAlertAccount.h"
#import "DDRegisterSuccessVC.h"

const CGFloat nums = 85.8;

typedef void(^SureDoneBlock)(void);

@interface AletStrViewController ()

@property (weak, nonatomic) IBOutlet UILabel *strLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;

@property (weak, nonatomic) IBOutlet UIButton *sureBut;


@property (copy, nonatomic) SureDoneBlock sureDoneBlock;

@end

@implementation AletStrViewController

#pragma mark -创建本类
- (instancetype)initWithCreatWithAttributedString:(NSAttributedString *)attrStr sureBlock:(void(^)(void))surevcBlock
{
    if (self == [super init]) {
        self = [[AletStrViewController alloc] initWithNibName:@"AletStrViewController" bundle:nil];
        [self alertStrWithAttributedString:attrStr sureBlock:surevcBlock];
        
    }
    return self;
}
// MARK:图片+文字
- (instancetype)initWithUIImageNamed:(NSString *)img attributedString:(NSAttributedString *)attrStr sureBlock:(void(^)(void))sureBlock{
    if (self = [super init]) {
        self = [[AletStrViewController alloc] initWithNibName:@"AletStrViewController" bundle:nil];
        [self alertUIImageNamed:img attributedString:attrStr sureBlock:sureBlock];
    }
    return self;
}

+ (instancetype)creatAlertVCTopImageNamed:(NSString *)img attributedString:(NSAttributedString *)attrStr sureBlock:(void(^)(void))sureBlock{
    AletStrViewController *alertVC = [[AletStrViewController alloc] initWithUIImageNamed:img attributedString:attrStr sureBlock:sureBlock];
    return alertVC;
}

+ (instancetype)creatAlertVCWithAttributedString:(NSAttributedString *)attrStr sureBlock:(void(^)(void))surevcBlock
{
    AletStrViewController *alertVC = [[AletStrViewController alloc] initWithCreatWithAttributedString:attrStr sureBlock:surevcBlock];
    return alertVC;
}

+ (instancetype)creatAlertVCWithAttributedString:(NSAttributedString *)attrStr sureStr:(NSString *)sureStr sureBlock:(void(^)(void))surevcBlock
{
    AletStrViewController *alertVC = [[AletStrViewController alloc] initWithCreatWithAttributedString:attrStr sureBlock:surevcBlock];
    [alertVC.sureBut setTitle:sureStr forState:UIControlStateNormal];

    return alertVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)alertStrWithAttributedString:(NSAttributedString *)attrStr sureBlock:(void(^)(void))surevcBlock
{
    if (!attrStr.string.length) return;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

    self.strLabel.attributedText = attrStr;
    self.sureDoneBlock = surevcBlock;
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat hei = [attrStr.string boundingRectWithSize:CGSizeMake(230, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
    self.layoutHeight.constant = hei + nums;
    
    [self showVC];
}

- (void)alertUIImageNamed:(NSString *)img attributedString:(NSAttributedString *)attrStr sureBlock:(void(^)(void))sureBlock{
    if (!attrStr.string.length) return;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.strLabel.attributedText = attrStr;
    self.sureDoneBlock = sureBlock;
    
    //图片540x680
    CGFloat width = SCREEN_WIDTH / 375 * 540 / 2;
    CGFloat height = width / 540 / 2 * 640;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - width - 30, 10 + height + 10 + 14 + 10 + 40)];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.center = self.view.center;
    [self.view addSubview:backView];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:img];
    imgV.frame = CGRectMake(10, 10, width, height);
    [backView addSubview:imgV];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(imgV.left, imgV.bottom + 10, imgV.width, 14)];
    lab.text = attrStr.string;
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:lab];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(0, backView.bottom - 40, backView.width, 40);
    sure.layer.cornerRadius = 10;
    sure.layer.masksToBounds = YES;
    sure.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sure.layer.borderWidth = 1;
    [backView addSubview:sure];
    [sure addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self showVC];
    
}

- (void)sureClick:(UIButton *)buttonf {
    if (self.sureDoneBlock) {
        self.sureDoneBlock();
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark -创建本类
/** 创建ImageAertView */
+ (instancetype)creatAlertStrWithStr:(NSString *)str sureBlock:(void(^)(void))surevcBlock
{
    AletStrViewController *alertVC = [[AletStrViewController alloc] initWithAlertStrWithStr:str sureBlock:surevcBlock];
    return alertVC;
}
- (instancetype)initWithAlertStrWithStr:(NSString *)str sureBlock:(void(^)(void))surevcBlock
{
    if (self == [super init]) {
        self = [[AletStrViewController alloc] initWithNibName:@"AletStrViewController" bundle:nil];
        [self alertStrWithStr:str sureBlock:surevcBlock];
    }
    return self;
}

/** 创建ImageAertView */
- (void)alertStrWithStr:(NSString *)str sureBlock:(void(^)(void))surevcBlock
{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.strLabel.text = str;
    self.sureDoneBlock = surevcBlock;
    CGFloat hei = [str sizeWithFontNum:14.0 MaxSize:CGSizeMake(270, 0)];
    self.layoutHeight.constant = hei + nums;
    [self showVC];
}

- (void)showVC
{
    UIViewController *vcc = [HXAlertAccount getCurrentVC];

    UIViewController *newvc = vcc;
    if (![newvc isKindOfClass:[DDRegisterSuccessVC class]]) {
        if (![newvc isKindOfClass:[HXTabBarViewController class]]) {
            newvc = newvc.tabBarController;
        }
    }
    if (newvc) {
        vcc = newvc;
    }
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [vcc presentViewController:self animated:NO completion:nil];
}

- (IBAction)sureDoAction:(UIButton *)sender
{
    if (self.sureDoneBlock) {
        self.sureDoneBlock();
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


@end
