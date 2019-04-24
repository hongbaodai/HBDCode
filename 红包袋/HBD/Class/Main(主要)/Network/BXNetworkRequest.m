//
//  BXNetworkRequest.m
//  HBD
//
//  Created by echo on 15/7/31.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.
//

#define APPID   @"1090834403"
#define kCookieUserDefaultKey @"cookies"

#import "BXNetworkRequest.h"
#import "BXSendMessage.h"
#import "DDAccount.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@implementation BXHTTPParamInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataParam = [[NSDictionary alloc]init];
        self.serviceString = [[NSString alloc]init];
        //        self.appendParam = [[NSArray alloc]init];
        
    }
    return self;
}

@end

@implementation BXNetworkRequest
{
    CGFloat _oldTime; // 防止多次模拟登陆发送多次登录统计标识
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.alert = [[UIAlertView alloc] initWithTitle:@"用户信息已失效" message:@"请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        });
        
        _oldTime = 0.0;
    }
    return self;
}

+ (instancetype)defaultManager
{
    
    static BXNetworkRequest *s_BXNetworkRequest;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        s_BXNetworkRequest = [[BXNetworkRequest alloc] init];
    });
    return s_BXNetworkRequest;
}

// 判断用户信息是否失效
- (BOOL)isExpired:(NSDictionary *)dict{
    
    if ([dict[@"body"][@"resultcode"] integerValue] ==  -1) {
        NSString *resultinfo = [NSString stringWithString:dict[@"body"][@"resultinfo"]];
        NSRange range = [resultinfo rangeOfString:@"用户信息失效"];
        if (range.location != NSNotFound) {
            
            return YES;
        }
    }
    
    return NO;
}

+ (AFHTTPRequestOperationManager *)postOperationManager
{
    static AFHTTPRequestOperationManager * nanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nanager = [AFHTTPRequestOperationManager manager];
        nanager.requestSerializer.timeoutInterval = 7;
        nanager.responseSerializer = [AFJSONResponseSerializer serializer];
//        nanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        nanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil];

        ((AFJSONResponseSerializer*)nanager.responseSerializer).removesKeysWithNullValues=YES;
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];// 上面这两句是打印出json数据需要添加的代码

    });
    return nanager;
}

//发送GET请求
-(void)getWithWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild
{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hongbaodai" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSArray *cerSet = [[NSArray alloc] initWithObjects:certData, nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/p2p/soa", BXNETURL];
    
    AFHTTPRequestOperationManager *manager = [BXNetworkRequest postOperationManager];
    [manager.securityPolicy setPinnedCertificates:cerSet];
    
    NSDictionary *body = [[NSDictionary alloc] initWithDictionary:info.dataParam];
    NSMutableDictionary *sendMessage = [BXSendMessage initWithHeadAndService:info.serviceString Body:body];
    
    [manager GET:urlString parameters:sendMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self isExpired:responseObject]) {
            [self reLoginForHeadInfomationWithHTTParamInfo:info SucceccResultWithDictionaty:^(id responseObject) {
                success(responseObject);
            } faild:^(NSError *error) {
                //                [self.alert show];
            }];
        }else{
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (faild) {
            faild(error);
        }
    }];
}

//发送POST请求
- (void)postWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild
{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hongbaodai" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSArray *cerSet = [[NSArray alloc] initWithObjects:certData, nil];
    NSString *urlString = [NSString stringWithFormat:@"%@/p2p/soa", BXNETURL];
   
    AFHTTPRequestOperationManager *manager = [BXNetworkRequest postOperationManager];
    [manager.securityPolicy setPinnedCertificates:cerSet];
    
    NSDictionary *body = [[NSDictionary alloc] initWithDictionary:info.dataParam];
    NSMutableDictionary *sendMessage = [BXSendMessage initWithService:info.serviceString Body:body];
    //    [self setSessionIDCookie];
    
    [manager POST:urlString parameters:sendMessage  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self isExpired:responseObject]) {
            
            [self reLoginForHeadInfomationWithHTTParamInfo:info SucceccResultWithDictionaty:^(id responseObject) {
                
                success(responseObject);
                
            } faild:^(NSError *error) {
                //                [self.alert show];
            }];
            
        }else{
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (faild) {
            faild(error);
        }
    }];
}

//发送POST请求，附带head信息
- (void)postHeadWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild
{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hongbaodai" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSArray *cerSet = [[NSArray alloc] initWithObjects:certData, nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/p2p/soa", BXNETURL];
    AFHTTPRequestOperationManager *manager = [BXNetworkRequest postOperationManager];
    [manager.securityPolicy setPinnedCertificates:cerSet];
    
    NSDictionary *body = [[NSDictionary alloc] initWithDictionary:info.dataParam];
    
    NSMutableDictionary *sendMessage = [BXSendMessage initWithHeadAndService:info.serviceString Body:body];
    [manager POST:urlString parameters:sendMessage  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self isExpired:responseObject]) {
            
            [self reLoginForHeadInfomationWithHTTParamInfo:info SucceccResultWithDictionaty:^(id responseObject) {
                success(responseObject);
            } faild:^(NSError *error) {
                
                //                [self.alert show];
            }];
        }else{
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (faild) {
            faild(error);
        }
    }];
}

// 模拟登录并重新获取头信息
- (void)reLoginForHeadInfomationWithHTTParamInfo:(BXHTTPParamInfo *)info SucceccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BXHTTPParamInfo *infoForLogin = [[BXHTTPParamInfo alloc]init];
    infoForLogin.serviceString = BXRequestLogin;
    if ([defaults objectForKey:@"username"] == nil
        ||[defaults objectForKey:@"password"] == nil) {
        return;
    }
    infoForLogin.dataParam = @{@"userName":[defaults objectForKey:@"username"],@"password":[defaults objectForKey:@"password"]};
    
    [self postWithHTTParamInfo:infoForLogin succeccResultWithDictionaty:^(id responseObject) {
        
        NSDictionary *dict = [NSDictionary  dictionaryWithDictionary:responseObject];
        [DDAccount mj_objectWithKeyValues:dict];
        
        if ([dict[@"body"][@"resultcode"] integerValue] == 0) {
            
            [defaults setObject:dict[@"body"][@"_U"] forKey:@"userId"];
            [defaults setObject:dict[@"body"][@"_T"] forKey:@"_T"];
            [defaults setObject:dict[@"body"][@"roles"] forKey:@"roles"];
            [defaults setObject:dict[@"body"][@"usergroup"] forKey:@"usergroup"];
            [defaults setObject:dict[@"body"][@"mobile"] forKey:@"phoneNumber"];
            [defaults setObject:dict[@"body"][@"khfs"] forKey:@"khfs"];
            [defaults setObject:dict[@"body"][@"TS"] forKey:@"TS"];
            [defaults setObject:dict[@"body"][@"QP"] forKey:@"QP"];
            
            if (dict[@"body"][@"sessionId"]) {
                [defaults setObject:dict[@"body"][@"sessionId"] forKey:@"sessionId"];
            }
            
            [self rePostHeadWithHTTParamInfo:info succeccResultWithDictionaty:^(id responseObject) {
                success(responseObject);
                
            } faild:^(NSError *error) {
                
            }];
        }else{
            //            [self.alert show];
        }
    } faild:^(NSError *error) {
        
    }];
}

// 用户信息失效后，重新发送请求
- (void)rePostHeadWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXReNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild
{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hongbaodai" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSArray *cerSet = [[NSArray alloc] initWithObjects:certData, nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/p2p/soa", BXNETURL];
    
    AFHTTPRequestOperationManager *manager = [BXNetworkRequest postOperationManager];
    [manager.securityPolicy setPinnedCertificates:cerSet];
    
    NSDictionary *body = [[NSDictionary alloc] initWithDictionary:info.dataParam];
    
    NSMutableDictionary *sendMessage = [BXSendMessage initWithHeadAndService:info.serviceString Body:body];
    
    [manager POST:urlString parameters:sendMessage  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([self isExpired:responseObject]) {
            
            //            [self.alert show];
        } else{
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (faild) {
            faild(error);
        }
    }];
}

//postAppStoreInfo
- (void)postAppStoreInfosucceccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild{
    NSString *url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",APPID];
    //    NSString *urlString = @"https://itunes.apple.com/cn/app/hong-bao-dai/id1090834403?mt=8";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (faild) {
            faild(error);
            
        }
    }];
}


#pragma mark -alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        // 清除缓存
        [AppUtils clearLoginDefaultCachesAndCookieImgCaches:YES];
        
        AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
        //        BXTabBarController *tabBarVC = (BXTabBarController *)dele.window.rootViewController;
        HXTabBarViewController *tabBarVC = [[HXTabBarViewController alloc]init];
        dele.window.rootViewController = tabBarVC;
        [tabBarVC loginStatusWithNumber:0];
        tabBarVC.selectedIndex = 0;
        
    }
}


//---out-----------
//发送统计数据
-(void)getStatisticsWithWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/AccessRecordPortal", BXStatisticsState];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSDictionary *body = [[NSDictionary alloc] initWithDictionary:info.dataParam];
    
    [manager GET:urlString parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (faild) {
            faild(error);
            
        }
    }];
}



@end
