//
//  BXDebentureViewModel.m
//  HBD
//
//  Created by hongbaodai on 2017/10/9.
//

#import "BXDebentureViewModel.h"
#import "BXJumpThirdPartyController.h"
#import "DDAccount.h"

@interface BXDebentureViewModel()<PayThirdPartyProtocol>
{
    UIViewController *vcSelf;
}
@property (nonatomic, assign) DDSetStyle setStyle;


@end

@implementation BXDebentureViewModel

/** 获取用户绑卡信息 */
+ (void)postUserBankCardInfoWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = BXRequestBankcard;
    info.dataParam = @{@"vobankIdTemp":@""};
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        //缓存用户信息
        [DDAccount mj_objectWithKeyValues:dict[@"body"]];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //如果在登陆状态中变成vip
            if (dict[@"body"][@"currUser"][@"SF_Vip"] == nil) {    //是不是vip
                [defaults setObject:@"0" forKey:DDUserVipState];
            } else {
                [defaults setObject:dict[@"body"][@"currUser"][@"SF_Vip"] forKey:DDUserVipState];
            }
            
            DDAccount *accout = [DDAccount sharedDDAccount];
            accout.SXSJ = dict[@"body"][@"currUser"][@"SXSJ"];
            // 银行预留手机号
            accout.bankPhoneNum = dict[@"body"][@"currUser"][@"BANK_RESERVE_MOBILE"];
            
            successBlock(dict);
        }
    } faild:^(NSError *error) {}];
}

/** 修改银行手机号 */
- (void)postAmendPhoneNumWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    
    info.serviceString = DDRequestlmPhoneNum;
    info.dataParam = @{@"from":@"M"};
    [MBProgressHUD showMessage:@"加载中..." toView:vc.view];
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            //
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"修改银行预留手机号";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            
            self.setStyle = DDSetStyleYHYLSJH;
            
            [vc.navigationController pushViewController:JumpThirdParty animated:YES];
            
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
        [MBProgressHUD hideHUDForView:vc.view];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUDForView:vc.view];
    }];
}

/** 修改交易密码 */
- (void)postChangeTransPwdWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock
{
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    
    info.serviceString = DDRequestlmChangeTransPwd;
    info.dataParam = @{@"from":@"M"};
    [MBProgressHUD showMessage:@"加载中..." toView:vc.view];
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"修改交易密码";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            
            self.setStyle = DDSetStyleJYMM;
            
            [vc.navigationController pushViewController:JumpThirdParty animated:YES];
            
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        [MBProgressHUD hideHUDForView:vc.view];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUDForView:vc.view];
    }];
}

/** 绑定银行卡 */
- (void)postBlindCardWithVC:(UIViewController *)vc success:(SuccessBlock)successBlock
{
    vcSelf = vc;
    BXHTTPParamInfo *info = [[BXHTTPParamInfo alloc]init];
    info.serviceString = DDRequestlmBindPersonCard;
    info.dataParam = @{@"from":@"M"};
    [MBProgressHUD showMessage:@"加载中..." toView:vc.view];
    
    [[BXNetworkRequest defaultManager] postHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:responseObject];
        // 加载指定的页面去
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            BXWebRequesetInfo *info = [BXWebRequesetInfo mj_objectWithKeyValues:dict[@"body"][@"payReqToThird"]];
            //
            BXJumpThirdPartyController *JumpThirdParty = [[BXJumpThirdPartyController alloc] init];
            JumpThirdParty.title = @"绑定银行卡";
            JumpThirdParty.payDelegate = self;
            JumpThirdParty.info = info;
            JumpThirdParty.info.requestNo = dict[@"body"][@"requestNo"];
            
            self.setStyle = DDSetStyleYHKGL;
            
            [vc.navigationController pushViewController:JumpThirdParty animated:YES];
            
        } else {
            [MBProgressHUD showError:dict[@"body"][@"resultinfo"]];
        }
        
        [MBProgressHUD hideHUDForView:vc.view];
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUDForView:vc.view];
    }];
}

#pragma mark - payThirdDelegate
-(void)payThirdPartyFinish:(BOOL)isSuccess Message:(NSString *)message Type:(MPPayType)type Serial_number:(NSString *)serial_number
{
    if (self.setStyle == DDSetStyleYHCG) {
        
    } else if (self.setStyle == DDSetStyleYHKGL) {
        // 银行卡管理-银行卡绑卡
        [self makeBankCardIsSuccess:isSuccess message:message];
        
    } else if (self.setStyle == DDSetStyleYHYLSJH) {
        // 银行预留手机号
        [self isSuccess:isSuccess message:message];
    } else if (self.setStyle == DDSetStyleJYMM) {
        
        [self suceeseDo];
        if (isSuccess) {
            [AppUtils alertWithVC:vcSelf title:@"交易密码修改成功！" messageStr:nil enSureBlock:^{}];
        } else {
            [AppUtils alertWithVC:vcSelf title:@"修改失败，请稍后再试！" messageStr:nil enSureBlock:^{}];
        }
    }
}

- (void)showAlertWithStr:(NSString *)str
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)isSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        [self suceeseDo];
        [self showAlertWithStr:@"银行预留手机号修改成功!"];
    } else {
        [self suceeseDo];
        [self showAlertWithStr:@"修改失败，请稍后再试!"];
    }
}

// 银行卡绑卡
- (void)makeBankCardIsSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        if (self.succesBlindCardBlo) {
            self.succesBlindCardBlo(nil);
        }
        [self showAlertWithStr:@"绑卡成功!"];
        
    } else {
        [self suceeseDo];
        [self showAlertWithStr:@"绑卡失败，请稍后再试！"];
    }
}

- (void)suceeseDo
{
    if (self.succesBlo) {
        self.succesBlo(nil);
    }
}

@end
