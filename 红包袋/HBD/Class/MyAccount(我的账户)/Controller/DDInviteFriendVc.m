//
//  DDInviteFriendVc.m
//  HBD
//
//  Created by hongbaodai on 17/3/7.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInviteFriendVc.h"
#import "BXInvitationRecordController.h"
#import "WXApi.h"
#import "BXSharePageView.h"
#import "DDInvitePopView.h"
#import "DDWebViewVC.h"
#import "QRCodeGenerator.h"


#define WXSHAREIMG               @"hbd_icon"


@interface DDInviteFriendVc ()<UIActionSheetDelegate, SharePageViewProtocol, DDInvitePopDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fsViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smViewW;

@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (weak, nonatomic) IBOutlet UIButton *baBaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *baShiBtn;
@property (weak, nonatomic) IBOutlet UIButton *baXiongBtn;
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLab;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

// 复制邀请码
@property (weak, nonatomic) IBOutlet UIButton *copycodeBtn;
// 好友链接
@property (weak, nonatomic) IBOutlet UIButton *sendLinkBtn;
// 二维码
@property (weak, nonatomic) IBOutlet UIButton *qrcodeBtn;




@end

@implementation DDInviteFriendVc
{
    BXSharePageView *_shareView;
    UIView *_bottomgraryView;
    NSString *_textStr;
    NSString *urlStr;
    UIImageView *codeImgView_;  //二维码
    UIButton * coverView_; //蒙版
    NSString *inviteCodeStr_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"邀请好友";
    
    [self settingFrame];
    [self initUIViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    
    [self postInviteCode];
    [self postInviteFriendsListWithPageNum:@"1" PageSize:@"0"];
    [self addAnimationShakeY];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    
}

//添加动画效果
- (void)addAnimationShakeY {
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shake.fromValue = [NSNumber numberWithFloat:-10];
    shake.toValue = [NSNumber numberWithFloat:10];
    shake.duration = 1.5;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 10000;//次数
    [self.baBaiBtn.layer addAnimation:shake forKey:@"shakeAnimation"];
    [self.baShiBtn.layer addAnimation:shake forKey:@"shakeAnimation"];
    [self.baXiongBtn.layer addAnimation:shake forKey:@"shakeAnimation"];
}


- (void)initUIViews
{
    [self.ruleBtn addTarget:self action:@selector(ruleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.copycodeBtn addTarget:self action:@selector(copycodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sendLinkBtn addTarget:self action:@selector(sendLinkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.qrcodeBtn addTarget:self action:@selector(qrcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.view1.layer.cornerRadius = 4;
    self.view1.layer.masksToBounds = YES;
    self.view2.layer.cornerRadius = 3;
    self.view2.layer.masksToBounds = YES;
    self.view3.layer.cornerRadius = 3;
    self.view3.layer.masksToBounds = YES;
    
    _baShiBtn.adjustsImageWhenHighlighted = NO;
    _baBaiBtn.adjustsImageWhenHighlighted = NO;
    _baXiongBtn.adjustsImageWhenHighlighted = NO;
}


/** 活动规则 */
- (void)ruleBtnClick
{
    DDInvitePopView *popView = [DDInvitePopView instanceInviteFriendPopView];
    
    if (IS_IPHONE5) {
        popView.frame = CGRectMake(25, 5, SCREEN_WIDTH-50, SCREEN_HEIGHT-64-10);
    } else if (IS_IPHONE6) {
        popView.frame = CGRectMake(25, 25, SCREEN_WIDTH-50, SCREEN_HEIGHT-64-60);
    } else if (IS_iPhoneX) {
        popView.frame = CGRectMake(25, 25, SCREEN_WIDTH-50, SCREEN_HEIGHT-64-180);
    }else {
        popView.frame = CGRectMake(25, 25, SCREEN_WIDTH-50, SCREEN_HEIGHT-64-100);
    }
    popView.delegate = self;
    [self.view addSubview:popView];
}

//规则 了解详情文字点击
- (void)didClickSeeDetail {
    
    DDWebViewVC *vc = [[DDWebViewVC alloc] init];
    vc.webType = DDWebTypeYQHYGZXQ;
    vc.navTitle = @"详情";
    [self.navigationController pushViewController:vc animated:YES];
}

/** 邀请记录 */
- (void)recordBtnClick
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil];
    BXInvitationRecordController *recordVC = [storyBoard instantiateViewControllerWithIdentifier:@"BXInvitationRecordVC"];
    [self.navigationController pushViewController:recordVC animated:YES];
}

/** 复制邀请码 */
- (void)copycodeBtnClick
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = inviteCodeStr_;
    [MBProgressHUD showSuccess:@"邀请码复制成功，粘贴分享给好友吧!"];
}

/** 发送邀请链接 */
- (void)sendLinkClick
{
    [self shareToWeixinWithCopyLink:inviteCodeStr_];
}

/** 二维码 */
- (void)qrcodeBtnClick
{
    [self creatCoverView];
    
}

-(void)creatCoverView {
    //创建蒙版
    coverView_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationController.view addSubview:coverView_];
    
    coverView_.frame = [UIScreen mainScreen].bounds;
    
    coverView_.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];// 设置透明度
    
    // 点击遮盖层
    [coverView_ addTarget:self action:@selector(closeBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 显示到窗体最上面
    [self.view bringSubviewToFront:coverView_];
    
    
    //添加二维码
    codeImgView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 175, 175)];
    codeImgView_.center = self.view.center;
    codeImgView_.centerY_ = codeImgView_.centerY_ -50;
    codeImgView_.backgroundColor = [UIColor whiteColor];
    codeImgView_.layer.cornerRadius = 4;
    codeImgView_.layer.masksToBounds = YES;
    
    
    [self createQRCode];
    [coverView_ addSubview:codeImgView_];
}

#pragma mark-> 二维码生成
- (void)createQRCode{
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/m/p2p/user/register.html?code=%@",DDWEBURL,inviteCodeStr_]; 旧的
    NSString *urlString = [NSString stringWithFormat:@"%@/registered?yqm=%@&hidden=1",DDNEWWEBURL,inviteCodeStr_];

    // Topimg；中心小图
    UIImage *tempImage = [QRCodeGenerator qrImageForString:urlString imageSize:500 Topimg:nil];
    
    codeImgView_.image=tempImage;
    
}

- (void)closeBtnBtnClick {
    
    [UIView animateWithDuration:0.5 animations:^{
        codeImgView_.alpha = 0;
        coverView_.alpha = 0;
    } completion:^(BOOL finished) {
        [codeImgView_ removeFromSuperview];
        [coverView_ removeFromSuperview];
    }];
}


- (void)settingFrame
{
    CGFloat tempH;
    if (IS_iPhoneX) {
        tempH = SCREEN_HEIGHT - 88;
    } else {
        tempH = SCREEN_HEIGHT - 64;
    }
    if (IS_IPHONE5) {
        self.headViewH.constant = tempH *0.7 +100;
        self.footViewH.constant = tempH *0.3 +50;
        self.fsViewW.constant = 137;
        self.smViewW.constant = 137;
    } else {
        self.headViewH.constant = tempH *0.7;
        self.footViewH.constant = tempH *0.3;
    }
    
    //自定义分享view
    _shareView = [BXSharePageView sharePageView];
    _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220);
    _shareView.SharePageDelegate = self;
    _shareView.backgroundColor = [UIColor whiteColor];
    
    _bottomgraryView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    _bottomgraryView.backgroundColor = [UIColor grayColor];
    _bottomgraryView.alpha=0.5;
    
    [self.view addSubview:_bottomgraryView];
    [self.view addSubview:_shareView];
}

// 弹出分享页面
- (void)popupSharePage
{
    if (_shareView && _bottomgraryView) {
        _bottomgraryView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [UIView animateWithDuration:0.5 animations:^{
            _shareView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
        }];
    }
}

#define 分享页面的代理方法
// 点击微信好友
- (void)didClickWXHYBtn
{
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
}

// 点击朋友圈
- (void)didClickWXPYQBtn
{
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
}

// 点击取消分享
- (void)didClickCancelShareBtn
{
    _bottomgraryView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat height = CGRectGetHeight(_shareView.frame);
        _shareView.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, height);
    }];
}

- (void)shareToWeixinWithCopyLink:(NSString *)copyLink
{
    NSString *url = [NSString stringWithFormat:@"%@/registered?yqm=%@&hidden=1",DDNEWWEBURL,inviteCodeStr_];
    _textStr = @"红包袋践行“诚信、透明、公开、创新”的核心理念。解决中小企业借款难题，推动直接借款、践行普惠金融。";
    urlStr = url;
    //友盟分享
    if (![WXApi isWXAppInstalled]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url;
        [MBProgressHUD showSuccess:@"链接复制成功，粘贴分享给好友吧"];
    } else {
        [self popupSharePage];
    }
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = WXSHAREIMG;
    NSString *title = @"邀好友一起赚~注册奖券免费送！";
    UIImage *img = [UIImage imageNamed:thumbURL];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:_textStr thumImage:img];
    //设置网页地址
    shareObject.webpageUrl = urlStr;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                //                UMSocialShareResponse *resp = data;
                //                //分享结果消息
                //                UMSocialLogInfo(@"response message is %@",resp.message);
                //                //第三方原始返回的数据
                //                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                [self didSuccese];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
- (void)didSuccese
{
    _bottomgraryView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat height = CGRectGetHeight(_shareView.frame);
        _shareView.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, height);
    }];
    WS(weakSelf);
    [AppUtils alertWithVC:self title:@"分享成功" messageStr:nil enSureBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

/* 复制邀请码 */
- (void)postInviteCode
{
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.dataParam = @{@"vobankIdTemp":@""};
    info.serviceString = BXRequestCopyLink;
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [MBProgressHUD hideHUD];
        if (dict) {
            if (![dict[@"body"][@"resultcode"] intValue]) {
                
                inviteCodeStr_ = dict[@"body"][@"copy"];
                if (inviteCodeStr_.length <= 0) {
                    inviteCodeStr_ = @" ";
                }
                self.inviteCodeLab.text = inviteCodeStr_;
            }
        }
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

/* 邀请好友列表 */
- (void)postInviteFriendsListWithPageNum:(NSString *)pageNum PageSize:(NSString *)pageSize
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestInviteFriends;
    info.dataParam = @{@"pageNum":pageNum,@"pageSize":pageSize,@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if (![dict[@"body"][@"resultcode"] intValue]) {
            //            self.totallabel.text = [NSString stringWithFormat:@"您已获得%@元奖励",dict[@"body"][@"hbze"]];
        }
        
    } faild:^(NSError *error) {
    }];
}


+ (instancetype)creatVCFromStroyboard
{
    return [[UIStoryboard storyboardWithName:@"BXMyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"DDInviteFriendVc"];
}

@end

