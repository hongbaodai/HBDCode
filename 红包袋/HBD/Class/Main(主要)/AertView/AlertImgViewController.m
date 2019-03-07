//
//  AlertImgViewController.m
//  HBD
//
//  Created by hongbaodai on 2017/12/29.
//
typedef void(^MoreBlock)(void);

#import "AlertImgViewController.h"
#import "HXAlertAccount.h"


@interface AlertImgViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageShowView;
@property (weak, nonatomic) IBOutlet UIButton *moreBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomConstraint;

@property (copy, nonatomic) MoreBlock moreBlock;

@end

@implementation AlertImgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/** 创建ImageAertView */
+ (instancetype)alertImgViewControllerWithImageStr:(NSString *)imageStr butColor:(UIColor *)butColor moreBlock:(void(^)(void))moreBlock
{
    AlertImgViewController *viewvc = [[AlertImgViewController alloc] initWithAlertImgViewControllerWithStr:imageStr butColor:butColor moreBlock:moreBlock];
    return viewvc;
}
/** 创建ImageAertView */
- (instancetype)initWithAlertImgViewControllerWithStr:(NSString *)imageStr butColor:(UIColor *)butColor moreBlock:(void(^)(void))moreBlock
{
    self = [[AlertImgViewController alloc] initWithNibName:@"AlertImgViewController" bundle:nil];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.imageShowView.image = [UIImage imageNamed:imageStr];
    [self.moreBut setBackgroundColor:butColor];
    if (!moreBlock) {
        self.moreBut.hidden = YES;
    }
    self.moreBlock = moreBlock;
    if ([imageStr isEqualToString:@"show1"] || [imageStr isEqualToString:@"show2"]) {
        self.layoutBottomConstraint.constant = 8;
    }
    
    [self show];
    
    return self;
}
- (void)show
{
//    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
//    [keywindow addSubview:self];
//
//    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
//    UISnapBehavior *sanp = [[UISnapBehavior alloc] initWithItem:self snapToPoint:self.center];
//
//    sanp.damping = 0.1;
//    //先移除，后添加
//    [animator removeAllBehaviors];
//    [animator addBehavior:sanp];
//    [self.window addSubview:self];
    
    
    UIViewController *vcc = [HXAlertAccount getCurrentVC];
    if (![vcc isKindOfClass:[HXTabBarViewController class]]) {
        UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([vc isKindOfClass:[HXTabBarViewController class]]) {
            vcc = vc;
        } else {
            vcc = vcc.tabBarController;
        }
    };
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [vcc presentViewController:self animated:NO completion:nil];
}

/** 更多按钮点击事件 */
- (IBAction)moreAction:(UIButton *)sender
{
    self.view.alpha = 0;
    if (self.moreBlock) {
        self.moreBlock();
    }
    [self dismidss];
}
- (IBAction)closeAction:(UIButton *)sender
{
    self.view.alpha = 0;
    [self dismidss];
}

- (void)dismidss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
