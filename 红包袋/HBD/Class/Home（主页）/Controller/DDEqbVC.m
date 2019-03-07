//
//  DDEqbVC.m
//  HBD
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDEqbVC.h"
#import "DDActivityWebController.h"

@interface DDEqbVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTxf;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTxf;
@property (weak, nonatomic) IBOutlet MPCheckboxButton *isSelBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, strong) NSDictionary  *userCardDic;
@end

@implementation DDEqbVC

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通电子签章";
    self.isSelBtn.selected = YES;
    [self postUserBankCardInfo];
    [self setupBaseUI];
}

- (void)setupBaseUI{
    self.nameTxf.enabled = NO;
    self.cardNumTxf.enabled = NO;
        
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sureBtnClick {
    
    if ([self canSubmitGo]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *phoneNumber = [defaults objectForKey:@"username"]; //username  phoneNumber
       
        [self postOpenEqianbaoWithUserName:phoneNumber];
    }
}

- (void)detailBtnClick {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDActivityWebController" bundle:nil];
    DDActivityWebController *weVc = [sb instantiateInitialViewController];
    weVc.webTitleStr = @"授权书";
    weVc.webUrlStr = [NSString stringWithFormat:@"%@/shouquanshu?hidden=1",DDNEWWEBURL];;
    [self.navigationController pushViewController:weVc animated:YES];
}

- (BOOL)canSubmitGo {
    
    if (!self.isSelBtn.selected) {
        [MBProgressHUD showError:@"请知悉并同意《授权书》"];
        return NO;
    }
    return YES;
}

/** 获取用户绑卡信息 */
- (void)postUserBankCardInfo
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc] init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            _userCardDic = dict;
            self.nameTxf.text = _userCardDic[@"body"][@"currUser"][@"ZSXM"];
            self.cardNumTxf.text = _userCardDic[@"body"][@"currUser"][@"SFZH"];
        }
        
    } faild:^(NSError *error) {
    }];
}

#pragma - mark post
/** post开通e签宝**/
- (void)postOpenEqianbaoWithUserName :(NSString *)userName
{
    
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestOpenEqianbao;
    info.dataParam = @{@"userName":userName};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            [MBProgressHUD showSuccess:@"开通成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
 
    } faild:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nameTxf:(id)sender {
}

+ (instancetype)creatVCFromSB
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DDEqbVC" bundle:nil];
    DDEqbVC * eqbVc = [sb instantiateInitialViewController];
    return eqbVc;
}
@end
