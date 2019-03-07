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
    //    self.frame = [[UIApplication sharedApplication] keyWindow].frame;
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
//    [vcc presentViewController:self animated:NO completion:nil];
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

//- (UIViewController *)getCurrentVC {
//
//    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
//    if (!window) {
//        return nil;
//    }
//    UIView *tempView;
//    for (UIView *subview in window.subviews) {
//        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
//            tempView = subview;
//            break;
//        }
//    }
//    if (!tempView) {
//        tempView = [window.subviews lastObject];
//    }
//
//    id nextResponder = [tempView nextResponder];
//    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
//        tempView =  [tempView.subviews firstObject];
//
//        if (!tempView) {
//            return nil;
//        }
//        nextResponder = [tempView nextResponder];
//    }
//
//    return  (UIViewController *)nextResponder;
//}

@end
