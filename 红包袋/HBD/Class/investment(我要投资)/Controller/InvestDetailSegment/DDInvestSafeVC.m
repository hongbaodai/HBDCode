//
//  DDInvestSafeVC.m
//  HBD
//
//  Created by hongbaodai on 2017/10/12.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestSafeVC.h"
#import "ZYPhoto.h"
#import "DDProjectDetailModel.h"
#import "HXTextAndButModel.h"

@interface DDInvestSafeVC ()
// 还款来源
@property (weak, nonatomic) IBOutlet UILabel *paymentLab;
// 承付保障view
@property (weak, nonatomic) IBOutlet UIView *safeguardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeguardViewH;
// 相关材料view
@property (weak, nonatomic) IBOutlet UIView *materialView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialViewH;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *riskControlLab;
// 还款来源
@property (weak, nonatomic) IBOutlet UIView *sourceOfRepaymentView;
// 风险控制
@property (weak, nonatomic) IBOutlet UIView *riskControlView;

// 风险结果
@property (weak, nonatomic) IBOutlet UILabel *riskResults;

// 贷后管理
// 借款资金运用情况
@property (weak, nonatomic) IBOutlet UILabel *postLoanOne;

// 借款人经营状况及财务状况
@property (weak, nonatomic) IBOutlet UILabel *postLoanTwo;

// 借款人还款能力变化
@property (weak, nonatomic) IBOutlet UILabel *postLoanThree;

// 借款人逾期情况
@property (weak, nonatomic) IBOutlet UILabel *postLoanFour;

// 借款人申诉情况
@property (weak, nonatomic) IBOutlet UILabel *postLoanFive;

// 借款人受行政处罚情况
@property (weak, nonatomic) IBOutlet UILabel *postLoanSix;


@property(nonatomic, strong) NSMutableArray <ZYPhotoModel *> *photoModelArr;
@property(nonatomic, strong) NSMutableArray <ZYPhotoModel *> *photo2ModelArr;

@property (nonatomic, strong) DDProjectDetailModel *model;

@end

@implementation DDInvestSafeVC
{
    NSMutableArray *photoBZArr_;
    NSMutableArray *photoCLArr_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupPhotoView];
    photoCLArr_ = [NSMutableArray array];
    photoBZArr_ = [NSMutableArray array];
    
    [HXTextAndButModel hxProjectItem:self.sourceOfRepaymentView strImgViewFrame:self.sourceOfRepaymentView.bounds status:TextAndImgStatusSourceOfRepayment];
    [HXTextAndButModel hxProjectItem:self.riskControlView strImgViewFrame:self.riskControlView.bounds status:TextAndImgStatusRiskControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self postLoanDetailWithLoanId:self.loanId];
}


- (void)setupPhotoView {
    
    /*
     注意！如果是利用约束来布局界面的  ZYPhotoCollectionView的创建方法initWithFrame也需要传入宽度width并且是正确的宽度。因为图片的布局都是依赖这个width来进行布局的。  然后在这里约束ZYPhotoCollectionView的顶部距离，左边距离和宽度。而高度则在ZYPhotoCollectionView里面进行约束。  已经在ZYPhotoCollectionView.m文件中该约束的地方 写好注释了，进去查看即可。
     */
    
    self.photoModelArr  = [NSMutableArray array];
    self.photo2ModelArr  = [NSMutableArray array];
    
    //调用方法 继续创建其他7张图片模型
    [self setupPhotoModel];
    
    float imgH = (float)self.photoModelArr.count /3;
    float imgH2 = (float)self.photo2ModelArr.count /3;
    float imgW = SCREEN_WIDTH /3;
    // 图片高度
    int h1 = (int)ceil(imgH) * imgW; //向上取整
    int h2 = (int)ceil(imgH2) * imgW;
    
    //注意 这里的width一定需要传值，后续的界面布局 都是依赖这个width进行计算布局
    ZYPhotoCollectionView *photoView = [[ZYPhotoCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h1)];
    photoView.backgroundColor = [UIColor clearColor];

    ZYPhotoCollectionView *photoView2 = [[ZYPhotoCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h2)];
    photoView2.backgroundColor = [UIColor clearColor];

    photoView.photoModelArray = self.photoModelArr.copy;
    photoView2.photoModelArray = self.photo2ModelArr.copy;


    [self.safeguardView addSubview:photoView];

    if (self.photoModelArr && self.photoModelArr.count == 0) {
        self.safeguardViewH.constant = 0;
    } else {
        self.safeguardViewH.constant = photoView.height_;
    }

    [self.materialView addSubview:photoView2];


    if (self.photo2ModelArr && self.photo2ModelArr.count == 0) {
        self.materialViewH.constant = 0;
    } else {
        self.materialViewH.constant = photoView2.height_;
    }
    
    self.footView.height_ = self.safeguardViewH.constant + self.materialViewH.constant + self.riskControlLab.height_ + 230 + 370 + self.riskResults.height_ + self.postLoanOne.height_ + self.postLoanTwo.height_ + self.postLoanThree.height_ + self.postLoanFour.height_ + self.postLoanFive.height_ + self.postLoanSix.height_;
//    self.footView.height_ = self.safeguardViewH.constant + self.materialViewH.constant + self.riskControlLab.height_ + 230;
}


/** 创建图片模型 */
- (void)setupPhotoModel {

    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<photoBZArr_.count; i++) { //承付保障

        NSString *str = [NSString stringWithFormat:@"%@", photoBZArr_[i]];
        ZYPhotoModel *model = [[ZYPhotoModel alloc] initWithsmallImageURL:str bigImageURL:str];
        
        [temp addObject:model];
    }
   
    if (photoBZArr_ && photoBZArr_.count == 0) {
        [self.photoModelArr addObjectsFromArray:@[]]; //承付保障暂时为空
    } else {
        [self.photoModelArr addObjectsFromArray:@[]];
    }

    
    NSMutableArray *temp2 = [NSMutableArray array];
    for (int i=0; i<photoCLArr_.count; i++) { //风控措施
        
        NSString *str = [NSString stringWithFormat:@"%@", photoCLArr_[i]];
        ZYPhotoModel *model = [[ZYPhotoModel alloc] initWithsmallImageURL:str bigImageURL:str];
        
        [temp2 addObject:model];
    }
    
    if (photoCLArr_ && photoCLArr_.count == 0) {
        [self.photo2ModelArr addObjectsFromArray:@[]];
    } else {
        [self.photo2ModelArr addObjectsFromArray:temp2];
    }
    
    
}

- (void)fillViewData {
    
    if (_model.HKLY) {
        self.paymentLab.text = _model.HKLY;
    } else {
        self.paymentLab.text = @"--";
    }
    self.paymentLab.backgroundColor = kColor_BackGround_Gray;
    self.riskResults.backgroundColor = kColor_BackGround_Gray;
    self.postLoanOne.backgroundColor = kColor_BackGround_Gray;
    self.postLoanTwo.backgroundColor = kColor_BackGround_Gray;
    self.postLoanThree.backgroundColor = kColor_BackGround_Gray;
    self.postLoanFour.backgroundColor = kColor_BackGround_Gray;
    self.postLoanFive.backgroundColor = kColor_BackGround_Gray;
    self.postLoanSix.backgroundColor = kColor_BackGround_Gray;

    [self.paymentLab sizeToFit];
    self.tableView.tableHeaderView.height_ = self.paymentLab.height_ +65;

    if (_model.RiskResults) {
        self.riskResults.text = _model.RiskResults;
    }

    if (_model.FinancialSituation) {
        self.postLoanTwo.text = _model.FinancialSituation;
    }
    if (_model.RepaymentAbility) {
        self.postLoanThree.text = _model.RepaymentAbility;
    }
    if (_model.OverdueNumber) {
        self.postLoanFour.text = _model.OverdueNumber;
    }

    if (_model.Representation) {
        self.postLoanFive.text = _model.Representation;
    }

    if (_model.PunishPenalty) {
        self.postLoanSix.text = _model.PunishPenalty;
    }

    if (_model.UseFunds) {
        self.postLoanOne.text = _model.UseFunds;
    }

    [self.riskResults sizeToFit];
    [self.postLoanOne sizeToFit];
    [self.postLoanTwo sizeToFit];
    [self.postLoanThree sizeToFit];
    [self.postLoanFour sizeToFit];
    [self.postLoanFive sizeToFit];
    [self.postLoanSix sizeToFit];


    if (_model.FKCS) {
        self.riskControlLab.text = _model.FKCS;
    } else {
        self.riskControlLab.text = @"--";
    }
    self.riskControlLab.backgroundColor = kColor_BackGround_Gray;
    [self.riskControlLab sizeToFit];
}


//转换成url格式
- (NSURL *)getImageUrlWithFilePath:(NSString *)filePath PictureStr:(NSString *)str
{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/p2p/SourcePortal?", BXNETURL];
//    NSString *path = [NSString stringWithFormat:@"%@",filePath];
    
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@service=%@&body={\"imgPath\":\"%@\"}",baseUrl,BXRequestCreatImage,filePath];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}


#pragma mark - post
/** POST项目详情  */
- (void)postLoanDetailWithLoanId:(NSString *)loanId {
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestLoanDetail;
    info.dataParam = @{@"loanId":loanId};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            DDProjectDetailModel *model  = [DDProjectDetailModel mj_objectWithKeyValues:dict[@"body"][@"loan"]];
            _model = model;
            
             [self postProjectImageWithRZFWXY_ID:model.RZSQ_ID]; //????参数对？？？
        }
        
       
        [self fillViewData];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

/** POST项目详情图片 */
- (void)postProjectImageWithRZFWXY_ID:(NSString *)RZFWXY_ID {
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestLoanImage;
    info.dataParam = @{@"RZFWXY_ID":RZFWXY_ID};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [photoCLArr_ removeAllObjects];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            NSURL *url = nil;
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in dict[@"body"][@"loanImage"]) {
                
                [tempArr addObject:dic];
            }
            
            for (NSDictionary *dic in tempArr) {
                
                url = [self getImageUrlWithFilePath:dic[@"fileName"] PictureStr:nil];//图片
                [photoCLArr_ addObject:url];
        
            }
            
        }
    
        [self setupPhotoView];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}




@end
