    //
//  MYAlertView.m
//  zl
//
//  Created by a on 15/9/21.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "MYAlertView.h"
#import "UIColor+HexColor.h"
#import "NSString+Other.h"
@interface MYAlertView()

@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * text;
@property (strong,nonatomic)NSArray * textArr;
@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)UILabel * titleLabel;
@property (strong,nonatomic)UILabel * textLabel;


@end

@implementation MYAlertView
{
    int _ALLtextheigh;
}
- (instancetype)initWithTitle:(NSString *) title CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
              [self setUp];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *) title text:(NSString *)text CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.text =text;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        [self setUptitle];
    }
    return self;

}

- (instancetype)initWithblueTitle:(NSString *) title text:(NSArray *)textArr OkButton:(NSString *)okButton
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        if (!self.textArr) {
             self.textArr=[[NSArray alloc]init];
        }
        self.textArr =textArr;
        self.okButtonTitle = okButton;
        [self setUpWithBlueTitleandmanytexts];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancelBtn:(NSString *)cancelBtn okBtn:(NSString *)okBtn{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.cancelButtonTitle = cancelBtn;
        self.okButtonTitle = okBtn;
        [self setUpWithInputTextFieldWithPlaceholder:placeholder];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title text:(NSArray *)textArr cancelButton:(NSString *)cancelButton okButton:(NSString *)okButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        if (!self.textArr) {
            self.textArr=[[NSArray alloc]init];
        }
        self.textArr =textArr;
        self.okButtonTitle = okButton;
        self.cancelButtonTitle = cancelButton;
        [self setUpDoubleBtnAndTextArr];
    }
    return self;
}

- (void)setUp {
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];

    self.alertview = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150,[UIScreen mainScreen].bounds.size.height/2-120, 300, 200)];
    self.alertview.layer.cornerRadius = 5;
    self.alertview.backgroundColor = [UIColor whiteColor];

    [self.backgroundview addSubview:self.alertview];

    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.frame=CGRectMake(30,20,240,80);
    _titleLabel.text = self.title;
    _titleLabel.numberOfLines=0;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor=[UIColor orangeColor];
    _titleLabel.font=[UIFont systemFontOfSize:20];
    [self.alertview addSubview:_titleLabel];
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(30, 130, 100, 40)];
    cancelButton.backgroundColor=[UIColor grayColor];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.tag=1;
    cancelButton.layer.cornerRadius=3;
    [cancelButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertview addSubview:cancelButton];
    
    
    UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake(170, 130, 100, 40)];
    okButton.backgroundColor=[UIColor colorWithRed:0.114 green:0.506 blue:0.878 alpha:1.000];
    [okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    okButton.tag=2;
    okButton.layer.cornerRadius=3;
     [okButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:okButton];

}

- (void)setUptitle {
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150,[UIScreen mainScreen].bounds.size.height/2-120, 300, 200)];
    self.alertview.layer.cornerRadius = 5;
    self.alertview.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundview addSubview:self.alertview];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame=CGRectMake(30,30,240,30);
    _titleLabel.text = self.title;
    _titleLabel.numberOfLines=0;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor=[UIColor darkGrayColor];
    _titleLabel.font=[UIFont systemFontOfSize:22];
    [self.alertview addSubview:_titleLabel];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.frame=CGRectMake(30,70,240,50);
    _textLabel.text = self.text;
    _textLabel.numberOfLines=0;
    _textLabel.textAlignment=NSTextAlignmentCenter;
    _textLabel.textColor=[UIColor darkGrayColor];
    _textLabel.font=[UIFont systemFontOfSize:15];
    [self.alertview addSubview:_textLabel];
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(30, 140, 100, 40)];
    cancelButton.backgroundColor=[UIColor grayColor];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.tag=1;
    cancelButton.layer.cornerRadius=3;
    [cancelButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertview addSubview:cancelButton];
    UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake(170, 140, 100, 40)];
    okButton.backgroundColor=[UIColor colorWithRed:0.114 green:0.506 blue:0.878 alpha:1.000];
    [okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    okButton.tag=2;
    okButton.layer.cornerRadius=3;
    [okButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:okButton];
    
}

- (void)setUpWithBlueTitleandmanytexts {
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    self.alertview = [[UIView alloc] init];
    self.alertview.layer.cornerRadius = 5;
    self.alertview.backgroundColor = [UIColor whiteColor];
    [self.backgroundview addSubview:self.alertview];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame=CGRectMake(30,20,240,30);
    _titleLabel.text = self.title;
    _titleLabel.numberOfLines=0;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor=[UIColor colorWithRed:0.114 green:0.506 blue:0.878 alpha:1.000];
    _titleLabel.font=[UIFont systemFontOfSize:14];
    [self.alertview addSubview:_titleLabel];
    
    for (int i=0; i<self.textArr.count; i++) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = self.textArr[i];
         _textLabel.numberOfLines=0;
        _textLabel.textColor=[UIColor darkGrayColor];
        _textLabel.font=[UIFont systemFontOfSize:12];
//        CGSize titleSize = [_textLabel.text sizeWithFont:_textLabel.font constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:0];
        
        CGSize titleSize = [_textLabel.text sizeWithFont:_textLabel.font MaxSize:CGSizeMake(280, MAXFLOAT)];

//        CGSize titleSize = [_textLabel sizeThatFits:CGSizeMake(280, MAXFLOAT)];
        
        _textLabel.frame=CGRectMake(10,60+_ALLtextheigh,280,titleSize.height);
       
       
        [self.alertview addSubview:_textLabel];
        _ALLtextheigh=_ALLtextheigh+titleSize.height+15;
        
    }
    UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake(80,_ALLtextheigh+50+20, 140, 40)];
    okButton.backgroundColor=[UIColor colorWithRed:0.169 green:0.582 blue:0.918 alpha:1.000];
    [okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    okButton.layer.cornerRadius=1;
    [okButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:okButton];
    self.alertview.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-150,[UIScreen mainScreen].bounds.size.height/2-(_ALLtextheigh+50+20+60)/2, 300, _ALLtextheigh+50+20+60);
}

- (void)setUpWithInputTextFieldWithPlaceholder:(NSString *)placeholder {
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150,[UIScreen mainScreen].bounds.size.height/2-120, 300, 200 + 10)];
    self.alertview.layer.cornerRadius = 5;
    self.alertview.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundview addSubview:self.alertview];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = self.title;
    _titleLabel.numberOfLines=0;
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    _titleLabel.textColor=[UIColor colorWithHex:@"#222222"];
    _titleLabel.font=[UIFont systemFontOfSize:14];
//    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:0];
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font MaxSize:CGSizeMake(240, MAXFLOAT)];

    _titleLabel.frame=CGRectMake(30,30,240,titleSize.height);
    [self.alertview addSubview:_titleLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_titleLabel.frame)+25, 240, 35)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithHex:@"#bebebe"].CGColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 2.0;
    
    _inputTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(view.frame)-10, CGRectGetHeight(view.frame))];
    _inputTF.borderStyle = UITextBorderStyleNone;
    _inputTF.placeholder = [NSString stringWithFormat:@"%@",placeholder];
//     [_inputTF setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//    [_inputTF setValue:[UIColor colorWithHex:@"#bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    _inputTF.font = [UIFont boldSystemFontOfSize:15];
    _inputTF.textColor = [UIColor colorWithHex:@"#bebebe"];
    [view addSubview:_inputTF];
    [self.alertview addSubview:view];
    
    CGFloat btnY = CGRectGetMaxY(view.frame);
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(160,btnY + 27, 110, 35)];
    cancelButton.backgroundColor=[UIColor whiteColor];
    cancelButton.layer.borderColor = [UIColor colorWithHex:@"#158aff"].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 2.0;
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHex:@"#158aff"] forState:UIControlStateNormal];
    [cancelButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
     cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cancelButton.tag=2;
    [cancelButton addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertview addSubview:cancelButton];
    UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake(30, btnY + 27, 110, 35)];
    okButton.backgroundColor=[UIColor colorWithHex:@"#158aff"];
    [okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    okButton.tag=1;
    okButton.layer.cornerRadius=2.0;
    [okButton addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:okButton];

}


- (void)setUpDoubleBtnAndTextArr {
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    self.alertview = [[UIView alloc] init];
    self.alertview.layer.cornerRadius = 5;
    self.alertview.backgroundColor = [UIColor whiteColor];
    [self.backgroundview addSubview:self.alertview];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = self.title;
    _titleLabel.numberOfLines=0;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor=[UIColor colorWithHex:@"#222222"];;
    _titleLabel.font=[UIFont systemFontOfSize:16];
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font MaxSize:CGSizeMake(240, MAXFLOAT)];
//    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:0];
    _titleLabel.frame=CGRectMake(30,25,240,titleSize.height);
    [self.alertview addSubview:_titleLabel];
    
    
    for (int i=0; i<self.textArr.count; i++) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = self.textArr[i];
        _textLabel.numberOfLines=0;
        _textLabel.textColor=[UIColor colorWithHex:@"#666666"];
        _textLabel.font=[UIFont systemFontOfSize:14];
//        CGSize titleSize = [_textLabel.text sizeWithFont:_textLabel.font constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:0];
        CGSize titleSize = [_textLabel.text sizeWithFont:_textLabel.font MaxSize:CGSizeMake(280, MAXFLOAT)];

        //        CGSize titleSize = [_textLabel sizeThatFits:CGSizeMake(280, MAXFLOAT)];
        
        _textLabel.frame=CGRectMake(30,60+_ALLtextheigh,280,titleSize.height);
        
        
        [self.alertview addSubview:_textLabel];
        _ALLtextheigh=_ALLtextheigh+titleSize.height+15;
        
    }
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(160,_ALLtextheigh+50+20, 110, 35)];
    cancelButton.backgroundColor=[UIColor whiteColor];
    cancelButton.layer.borderColor = [UIColor colorWithHex:@"#158aff"].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 2.0;
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHex:@"#158aff"] forState:UIControlStateNormal];
    [cancelButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cancelButton.tag=2;
    [cancelButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertview addSubview:cancelButton];
    UIButton *okButton=[[UIButton alloc]initWithFrame:CGRectMake(30, _ALLtextheigh+50+20, 110, 35)];
    okButton.backgroundColor=[UIColor colorWithHex:@"#158aff"];
    [okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    okButton.tag=1;
    okButton.layer.cornerRadius=2.0;
    [okButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:okButton];
    
    self.alertview.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-150,[UIScreen mainScreen].bounds.size.height/2-(_ALLtextheigh+50+20+55)/2, 300, _ALLtextheigh+50+20+55);
}


- (void)click:(UIButton *)but
{
    [self.delegate myAlertView:self didClickButtonAtIndex:but.tag];
    self.alpha = 0.0;
    [self.alertview removeFromSuperview];
    [self.backgroundview removeFromSuperview];
}
- (void)click2:(UIButton *)but
{
    [self.delegate myAlertView:self didClickButtonAtIndex:but.tag];
    if (but.tag==1) {
        
    }else{
        self.alpha = 0.0;
        [self.alertview removeFromSuperview];
        [self.backgroundview removeFromSuperview];
    }
   
}
- (void)show {
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:self.center];
    sanp.damping = 0.7;
    [self.window addSubview:self.alertview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
