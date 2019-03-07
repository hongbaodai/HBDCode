//
//  HXPopUpViewController.m
//  HBD
//
//  Created by hongbaodai on 2017/12/28.
//

#import "HXPopUpViewController.h"
#import "DDActivityWebController.h"
#import "HXAlertAccount.h"

typedef void(^SureBlock)(void);
typedef void(^DeleteBlock)(void);


@interface HXPopUpViewController ()
/** 文字描述label */
@property (weak, nonatomic) IBOutlet UILabel *textStr;
/** 最底部按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bottomBut;
/** 中间图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 删除按钮 */
@property (weak, nonatomic) IBOutlet UIButton *deleteBut;
/** tip按钮:什么是银行存管 */
@property (weak, nonatomic) IBOutlet UIButton *tipBut;

/** 确定按钮事件 */
@property (copy, nonatomic) SureBlock sureBlock;
/** 叉号按钮事件 */
@property (copy, nonatomic) DeleteBlock deleteBlock;

@property (weak, nonatomic) UIViewController *target;
@end

@implementation HXPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


/** 创建弹框MYPopupView */
+ (instancetype)popUpVCInitWithTitle:(NSString *)titleStr sureButton:(NSString *)sureButton imageStr:(NSString *)imageStr isHidden:(BOOL)isHidden sureBlock:(void(^)(void))sureBlock deletBlock:(void (^)(void))deleteBlock
{
    HXPopUpViewController *vc = [[HXPopUpViewController alloc] initWithTitleStr:titleStr sureButton:sureButton imageStr:imageStr isHidden:isHidden sureBlock:sureBlock deletBlock:deleteBlock vc:nil];
    return vc;
}

/** 创建弹框MYPopupView */
- (instancetype)initWithTitleStr:(NSString *)titleStr sureButton:(NSString *)sureButton imageStr:(NSString *)imageStr isHidden:(BOOL)isHidden sureBlock:(void(^)(void))sureBlock deletBlock:(void (^)(void))deleteBlock vc:(UIViewController *)vc
{
    self = [[HXPopUpViewController alloc] initWithNibName:@"HXPopUpViewController" bundle:nil];
    self.view.backgroundColor = [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:0.55];
    
    self.tipBut.hidden = YES; // 这个需要注掉
    self.tipBut.hidden = isHidden; // 🚫🚫🚫如果平台合规和风险评估合并一起，则这个需要打开
    self.textStr.text = titleStr;
    self.sureBlock = sureBlock;
    self.deleteBlock = deleteBlock;
    [self.bottomBut setTitle:sureButton forState:UIControlStateNormal];
    self.imageView.image = [UIImage imageNamed:imageStr];
    self.target = vc;
    
    [self.tipBut addTarget:self action:@selector(hiddHilight:) forControlEvents:UIControlEventAllTouchEvents];
    
    [self show];
    return self;
}

- (void)show
{

    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    UIViewController *vcc = [HXAlertAccount getCurrentVC];
    if (![vcc isKindOfClass:[HXTabBarViewController class]]) {
        vcc = vcc.tabBarController;
    }
    [vcc presentViewController:self animated:NO completion:nil];
}

/** 底部按钮点击事件 */
- (IBAction)buttomAction:(UIButton *)sender
{
    self.view.alpha = 0;
    
    if (self.sureBlock) {
        self.sureBlock();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteAction:(UIButton *)sender
{
    self.view.alpha = 0;
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hiddHilight:(UIButton *)but
{
    but.highlighted = NO;
}

/** tip按钮：什么是银行存管 */
- (IBAction)tipAction:(UIButton *)sender
{
    if (self.tipBut.hidden == YES) return;
    self.view.alpha = 0;
    
    if (self.littlButBlock) {
        self.littlButBlock();
    }
    //    [self pushVC];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)pushVC
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
    DDActivityWebController *weVc = [sb instantiateInitialViewController];
    
    NSString *bannerUrl;
    NSString *urlSt = [NSString stringWithFormat:@"%@/wapBankDeposits?hidden=1",DDNEWWEBURL];
    //    NSString *urlSt = [NSString stringWithFormat:@"%@/m/pageHtml/BankDeposits/BankDeposits.html",DDWEBURL];
    
    HXTabBarViewController *tabbar = (HXTabBarViewController *)self.target.tabBarController;
    
    if (tabbar.bussinessKind){
        bannerUrl = [self urlWithPersonalInfo:urlSt WithState:@"1"];
    } else {
        bannerUrl = [self urlWithPersonalInfo:urlSt WithState:@"0"];
    }
    
    weVc.webUrlStr = bannerUrl;
    weVc.webTitleStr = @"银行存管上线";
    
    [self.target.navigationController pushViewController:weVc animated:YES];
}

//登录状态下拼接参数
- (NSString *)urlWithPersonalInfo:(NSString *)url WithState:(NSString *)state
{
    
    NSString *finalUrl = nil;
    if ([state isEqualToString:@"1"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *username = [defaults objectForKey:@"username"];
        NSString *_U = [defaults objectForKey:@"userId"];
        NSString *_T = [defaults objectForKey:@"_T"];
        NSString *roles = [defaults objectForKey:@"roles"];
        NSString *hidden = @"1";
        
        if ([url rangeOfString:@"?"].location != NSNotFound) {
            finalUrl = [NSString stringWithFormat:@"%@&t=%@&u=%@&nickname=%@&roles=%@&hidden=%@",url,_T,_U,username,roles,hidden];
        } else {
            finalUrl = [NSString stringWithFormat:@"%@?t=%@&u=%@&nickname=%@&roles=%@&hidden=%@",url,_T,_U,username,roles,hidden];
        }
    } else {
        NSString *hidden = @"1";
        if ([url rangeOfString:@"?"].location != NSNotFound) {
            finalUrl = [NSString stringWithFormat:@"%@&t=null&u=null&nickname=null&roles=null&hidden=%@",url,hidden];
        }else{
            finalUrl = [NSString stringWithFormat:@"%@?t=null&u=null&nickname=null&roles=null&hidden=%@",url,hidden];
        }
    }
    
    return finalUrl;
}

- (void)dealloc
{
    NSLog(@" ==");
}

@end
