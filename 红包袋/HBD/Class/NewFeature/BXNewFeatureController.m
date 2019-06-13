//
//  BXNewFeatureController.m
//  sinvo
//
//  Created by 李先生 on 15/4/17.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#define BXImagePages  3

#import "BXNewFeatureController.h"
#import "UIImageView+WebCache.h"
#import "SMPageControl.h"
#import "HXTabBarViewController.h"

@interface BXNewFeatureController ()<UIScrollViewDelegate>

@property (nonatomic, strong) SMPageControl *pageControl;

@property (nonatomic, assign)int page;
@end

@implementation BXNewFeatureController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setupSrollViewWithImage:BXImagePages];
}

/**
 * 初始化UISrollView
 */
- (void)setupSrollViewWithImage:(int)imageArray
{
    // 1.添加UISrollView
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    scrollerView.frame = self.view.bounds;
    [self.view addSubview:scrollerView];
    scrollerView.delegate = self;
    int page = imageArray;
    self.page = page;
    // 2.添加图片
    CGFloat width = scrollerView.frame.size.width;
    CGFloat height = scrollerView.frame.size.height;
    
    // 添加页面控制器
    self.pageControl = [[SMPageControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 20)];
    self.pageControl.center = CGPointMake(SCREEN_SIZE.width * 0.5, SCREEN_SIZE.height * 0.94);
    self.pageControl.numberOfPages = imageArray;
    self.pageControl.indicatorDiameter = 7.0;
    [self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"IndicatorImage2"]];
    [self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"IndicatorImage1"]];
    [self.view addSubview:self.pageControl];
    
    self.pageControl.currentPage = 0;
    
    if (width == 320 && height == 480) {
        for (int i = 0; i < page; i++) {
            NSString *imageStr = [NSString stringWithFormat:@"new_feature_0%d_4s",i + 1];

            // 1.拼接图片名称
            UIImageView *iv = [[UIImageView alloc] init];
            iv.image = [UIImage imageNamed:imageStr];
            //        NSURL *imageUrl = [NSURL URLWithString:imageArray[i]];
            //        [iv  sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"startImage"]];
            
            // 3.设置frame
            
            CGFloat ivY = 0;
            CGFloat ivW = width;
            CGFloat ivH = height;
            CGFloat ivX = i * ivW;
            iv.frame = CGRectMake(ivX, ivY, ivW, ivH);
            
            // 4.添加UIImageView到scrollerView
            [scrollerView addSubview:iv];
            
            
            // 5.拿到最后一张图片添加按钮
            if (i == self.page - 1) {
                
                // 0.设置父控件可以交互
                iv.userInteractionEnabled = YES;
                
                // 1.添加开始按钮
                [self setupStartBtn:iv];
                
            }
        }
    }
    else
    {
    for (int i = 0; i < page; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"new_feature_0%d",i + 1];

        // 1.拼接图片名称
        UIImageView *iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:imageStr];
//        NSURL *imageUrl = [NSURL URLWithString:imageArray[i]];
//        [iv  sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"startImage"]];
        
        // 3.设置frame
       
        CGFloat ivY = 0;
        CGFloat ivW = width;
        CGFloat ivH = height;
        CGFloat ivX = i * ivW;
        iv.frame = CGRectMake(ivX, ivY, ivW, ivH);
        
        // 4.添加UIImageView到scrollerView
        [scrollerView addSubview:iv];
        
        
        // 5.拿到最后一张图片添加按钮
        if (i == self.page - 1) {
            
            // 0.设置父控件可以交互
            iv.userInteractionEnabled = YES;
            
            // 1.添加开始按钮
            [self setupStartBtn:iv];
            
        }
    }
    }
    // 设置UISrollView的其他属性
    // 设置contentsize
    scrollerView.contentSize = CGSizeMake(self.page * width, 0);
    // 设置分页
    scrollerView.pagingEnabled = YES;
    // 隐藏指示条
    scrollerView.showsHorizontalScrollIndicator = NO;
    // 设置没有弹簧效果
    scrollerView.bounces = NO;
}

/**
 * 添加开始按钮
 */
- (void)setupStartBtn:(UIImageView *)imageview;
{
    // 1.创建按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageview addSubview:startButton];

    startButton.backgroundColor = kColor_Red_Main;
    // 3.设置文字
    [startButton setTitle:@"立即进入" forState:UIControlStateNormal];
    
    [self makeRoundButton:startButton];
    
    // 4.设置frame
    if (SCREEN_SIZE.width == 320 && SCREEN_SIZE.height == 480) {
        startButton.frame = CGRectMake(0, 0, SCREEN_SIZE.width * 0.5, 40);
        startButton.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.79);    // 5.监听按钮点击事件
    } else {
        startButton.frame = CGRectMake(0, 0, SCREEN_SIZE.width * 0.5, 40);
        startButton.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.77);    // 5.监听按钮点击事件
    }
    
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

- (void)makeRoundButton:(UIButton *)btn
{
    [btn.layer setCornerRadius:20];
    [btn.layer setMasksToBounds:YES];
//    btn.layer.borderWidth = 1;
//    btn.layer.borderColor = [UIColor cyanColor].CGColor;
}
/**
 * 开始进入主页点击事件
 */
- (void)start
{
    AppDelegate* deleget = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HXTabBarViewController * tabBarVC = [[HXTabBarViewController alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaults objectForKey:@"password"];
    if ([defaults objectForKey:@"username"] && password.length > 0) {
        [tabBarVC loginStatusWithNumber:3];
    } else {
        [tabBarVC loginStatusWithNumber:0];
    }
    
    deleget.window.rootViewController = tabBarVC;
}

#pragma mark - UIScrollViewDelegate
/**
 scrollview滚动的时候调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW * 0.5) / scrollViewW;
    self.pageControl.currentPage = page;
}

#pragma mark - view视图方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
