//
//  AlertThreeViewController.m
//  HBD
//
//  Created by hongbaodai on 2018/3/29.
//

#import "AlertThreeViewController.h"
#import "HXAlertAccount.h"

@interface AlertThreeViewController ()
// 顶部背景
@property (weak, nonatomic) IBOutlet UIImageView *backTopImaeView;
// 文字
@property (weak, nonatomic) IBOutlet UILabel *textLab;

// 左边按钮：不了谢谢
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
// 右边
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;



@end

@implementation AlertThreeViewController


+ (instancetype)createAlertThreeViewControllerWithTextStr:(NSString *)texStr imgStr:(NSString *)imgStr
{
    return [[self alloc] initWithAlertThreeViewControllerWithTextStr:texStr imgStr:imgStr];
}

- (instancetype)initWithAlertThreeViewControllerWithTextStr:(NSString *)texStr imgStr:(NSString *)imgStr
{
    if (self == [super init]) {
        self = [[AlertThreeViewController alloc] initWithNibName:@"AlertThreeViewController" bundle:nil];
        [self setUIWithStr:texStr imgStr:imgStr];
    }
    return self;
}

- (void)setUIWithStr:(NSString *)textStr imgStr:(NSString *)imgStr
{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.textLab.text = [NSString stringWithFormat:@"%@",textStr];
    self.backTopImaeView.image = [UIImage imageNamed:imgStr];
    [self show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBtn.layer.borderWidth = 1;
    self.leftBtn.layer.borderColor = [UIColor colorWithHexString:COLOUR_YELLOW].CGColor;
    //self.rightBtn.layer.cornerRadius = self.rightBtn.height_ / 2;
    //self.rightBtn.layer.masksToBounds = YES;
}

- (void)show
{
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

- (void)closeVC {
    self.view.alpha = 0;
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 关闭按钮
- (IBAction)closeAction:(UIButton *)sender {
    [self closeVC];
   
}

// 左边按钮
- (IBAction)leftAction:(UIButton *)sender {
    if (self.leftBtnBlock) {
        self.leftBtnBlock();
    }
    [self closeVC];
}

// 右边按钮
- (IBAction)rightAction:(UIButton *)sender {
    if (self.rightBtnBlock) {
        self.rightBtnBlock();
    }
    [self closeVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
