//
//  DDRegisterVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/13.
//

#import "DDRegisterVC.h"
#import "DDRegisterTwoVC.h"

@interface DDRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTxf;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet HXButton *nextBtn;

@end

@implementation DDRegisterVC
{
    UIButton *fhBtn_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tipLab.text = @"";
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //监听文本框改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTxfTextChange) name:UITextFieldTextDidChangeNotification object:self.phoneTxf];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isHomeVc) {
        fhBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(25, 25, 25, 25)];
        [fhBtn_ setImage:IMG(@"btn_cha") forState:UIControlStateNormal];
        [self.tabBarController.view addSubview:fhBtn_];
        fhBtn_.backgroundColor = [UIColor clearColor];
        [fhBtn_ addTarget:self action:@selector(fhBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneTxf endEditing:YES];
    [fhBtn_ removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
 
}


- (void)fhBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)phoneTxfTextChange {
    if (_phoneTxf.text.length == 0) {
        _tipLab.text = @"";
    }
}

- (void)nextBtnClick {
   
    if ([self canSubmitGo]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDRegisterTwoVC" bundle:nil];
        DDRegisterTwoVC *vc = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (BOOL)canSubmitGo {
    
    [self addLabelAnimationShake];
    
    if (!self.phoneTxf.text.length) {
        
        _tipLab.text = @"手机号不能为空";
        return NO;
    }
    if (![_phoneTxf.text n6_isMobile]) {

        _tipLab.text = @"请输入正确手机号";
        return NO;
    }

    return YES;
}

//添加文字抖动
- (void)addLabelAnimationShake {
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-5];
    shake.toValue = [NSNumber numberWithFloat:5];
    shake.duration = 0.1;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 2;//次数
    [self.tipLab.layer addAnimation:shake forKey:@"shakeAnimation"];
    self.tipLab.alpha = 1.0;
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.tipLab.alpha = 0.0; //透明度变0则消失
    } completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
