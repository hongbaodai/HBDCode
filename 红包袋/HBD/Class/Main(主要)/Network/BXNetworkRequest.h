//
//  BXNetworkRequest.h
//  ump _xxx1.0
//
//  Created by echo on 15/7/31.
//  Copyright (c) 2015年 caomaoxiaozi All rights reserved.


#import <Foundation/Foundation.h>

#ifdef DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil

#endif

////===============测试环境===================

//#define BXNETURL          @"https://graysrv.hongbaodai.com"  // 灰度环境
//#define DDWEBURL          @"https://gray.hongbaodai.com"     //

//#define BXNETURL          @"http://test.hongbaodai.com:39083"  //130
//#define DDWEBURL          @"http://test.hongbaodai.com:23081"
//#define DDNEWWEBURL       @"http://test.hongbaodai.com:23081/#" //新web页数据要www

//#define BXNETURL          @"http://v2.hongbaodai.com:29080"  // 143
//#define DDWEBURL          @"http://v2.hongbaodai.com:13080"
//#define DDNEWWEBURL       @"http://test.hongbaodai.com:23081/#"  //新web页数据要www

//#define BXNETURL          @"http://test1.hongbaodai.com:49080"  // 200
//#define DDWEBURL          @"http://test1.hongbaodai.com:43080"

//=========================================
//部分还款：http://192.168.1.125:29083      http://dev.hongbaodai.com:29083
//#define BXNETURL          @"http://192.168.1.125:29083"
//#define DDWEBURL          @"http://192.168.1.125:29083"
//#define DDNEWWEBURL       @"http://192.168.1.125:29083/#"

//===============生产环境===================
#define BXNETURL               @"https://service.hongbaodai.com"
#define DDWEBURL               @"https://www.hongbaodai.com"   //web页数据要www
#define DDNEWWEBURL            @"https://m.hongbaodai.com/#"   //新web页数据要www

//=========================================


/**更多数据 */
#define HXBankCiguan [NSString stringWithFormat:@"%@/wapBankDeposits",DDNEWWEBURL]
#define HXBankSafe [NSString stringWithFormat:@"%@/swiper",DDNEWWEBURL]
#define HXBankFivePage [NSString stringWithFormat:@"%@/m/about/proCompliance.html",DDWEBURL]
#define HXBankThreePage [NSString stringWithFormat:@"%@/shouquanshu",DDNEWWEBURL]


#define BXStatisticsState      @""

// 成功回调block
typedef void (^BXNetworkRequestSuccessBlock)(id responseObject);
// 重新发送成功回调black
typedef void (^BXReNetworkRequestSuccessBlock)(id responseObject);

#pragma 联动优势接口
//开户
static NSString *const DDRequestUserRegister = @"uc.umpayStartService.startUserRegister";
//充值
static NSString *const DDRequestRecharge = @"uc.umpayStartService.startRecharge";
//绑卡
static NSString *const DDRequestBindCard = @"uc.umpayStartService.startBindCard";
//提现
static NSString *const DDRequestCash = @"uc.umpayStartService.startCash";
//投标
static NSString *const DDRequestInitiativeTender = @"uc.umpayStartService.startInitiativeTender";
//债权转让
static NSString *const DDRequestCreditAssign = @"uc.umpayStartService.startCreditAssign";
//交易状态查询
static NSString *const DDRequestQueryTradeStatus = @"uc.umpayStartService.queryTradeStatus";
//开通e签宝
static NSString *const DDRequestOpenEqianbao = @"uc.user.openPersonSignAccount";

#pragma 银行接口
//开户
static NSString *const DDRequestlmUserRegister = @"uc.lmStartService.startUserRegister";
//充值
static NSString *const DDRequestlmRecharge = @"uc.lmStartService.startRecharge";
//提现
static NSString *const DDRequestlmCash = @"uc.lmStartService.startCash";
//投标
static NSString *const DDRequestlmInitiativeTender = @"uc.lmStartService.startInitiativeTender";
//交易状态查询
static NSString *const DDRequestlmQueryTradeStatus = @"uc.lmStartService.queryTradeStatus";
//升级账户
static NSString *const DDRequestlmUserActivated = @"uc.lmStartService.userActivated";
//修改交易密码
static NSString *const DDRequestlmChangeTransPwd = @"uc.lmStartService.changeTransPwd";
//绑定个人银行卡
static NSString *const DDRequestlmBindPersonCard = @"uc.lmStartService.startBindCard";
//修改银行预留手机号
static NSString *const DDRequestlmPhoneNum = @"uc.lmStartService.changeReserveMobile";
// 解绑银行卡
static NSString *const DDRequestlmUbindCark = @"uc.lmStartService.startUnbindCard";

#pragma 99Bill
//快钱快捷绑卡请求短信
static NSString *const BXRequest99BillIndAuth = @"uc.99BillService.indAuth";
//快钱快捷绑卡校验
static NSString *const BXRequest99BillIndAuthVerify = @"uc.99BillService.indAuthVerify";
//快钱快捷充值短信
static NSString *const BXRequest99BillPurchaseMsg = @"uc.99BillService.purchaseMsg";
//快钱快捷充值校验
static NSString *const BXRequest99BillPurchase = @"uc.99BillService.purchase";


//  OPEN指不需要用户信息的服务，就是不需要登录就可以调用
#pragma user
//banner地址
static NSString *const BXRequestBanner = @"uc.medit.indexInfo_PC_OPEN";

//程序是否可用
static NSString *const BXAppIsAvailable = @"uc.app.appIsAvailable_OPEN";
//登录
static NSString *const BXRequestLogin = @"uc.user.login_OPEN";
//static NSString *const BXRequestLogin = @"a.b.c_OPEN";
//注册
static NSString *const BXRequestRegister = @"uc.user.register_OPEN";
//注册发送手机验证码
static NSString *const BXRequestRegisterVerifyCode = @"uc.user.sendPicCodeSV_OPEN";
//注册下一步校验
static NSString *const HBCheckMobileAndCode_OPEN = @"uc.user.checkMobileAndCode_OPEN";
//重置密码
static NSString *const BXRequestChangePassword = @"uc.user.findLoginPassword_OPEN";
//修改登录密码
static NSString *const BXRequestResetPassword = @"uc.user.resetPassword";
//找回密码发送手机验证码
static NSString *const BXRequestSendFindVerifyCode = @"uc.user.sendFindVerifyCode_OPEN";
//找回密码下一步验证
static NSString *const HBCheckFindMobileAndCode_OPEN = @"uc.user.checkFindMobileAndCode_OPEN";
//图片验证码
static NSString *const BXRequestPictureCheckCode = @"uc.user.getPictureCheckCode_OPEN";
//平台数据
static NSString *const BXRequestUserStatistics = @"uc.user.userStatistics_OPEN";



#pragma loanService
//我要出借标列表
static NSString *const BXRequestLoanList = @"uc.loanService.loanList_PC_OPEN";
//项目概要 （2个接口凑）
static NSString *const BXRequestLoanDetail = @"uc.loanService.loanDetail_PC_OPEN";
static NSString *const BXRequestLoanDetailTwo = @"uc.loanService.borrowerDetails_OPEN";
//下载相关文件
static NSString *const BXRequestCreatImage = @"uc.loanService.creatImage_OPEN";
//项目相关文件图片
static NSString *const BXRequestLoanImage = @"uc.loanService.loanImage_OPEN";
//出借记录
static NSString *const BXRequestLoanInvest = @"uc.loanService.loanInvest_OPEN";
//项目详情分页-出借记录
static NSString *const DDURL_ProjectInvestRecord = @"uc.loanService.loanInvest_PC_OPEN";

//首页置顶的标列表
static NSString *const BXRequestLoanTopList = @"uc.loanService.loanTopList_PC_OPEN";
//首页置顶新手标/精品推荐接口
static NSString *const BXRequestLoanNewList = @"uc.loanService.loan_Recommend_OPEN";
//出借列表唯我独尊还是一锤定音接口
static NSString *const BXRequestGetActivityAward = @"uc.activity.getActivityAward_OPEN";


#pragma myCenter
//读取用户的绑卡信息
static NSString *const BXRequestBankcard =  @"uc.myCenter.userVerify";
//读取用户信息
static NSString *const BXRequestAccountInfo = @"uc.myCenter.queryAccountInfo";
//出借记录
static NSString *const BXRequestInvestRecord = @"uc.myCenter.investRecordList";
//出借记录详情
static NSString *const BXRequestInvestRecordDetail = @"uc.myCenter.investRecordDetail";
//红包明细
static NSString *const BXRequestRedpacketInfo = @"uc.myCenter.getRedpacketInfo";
//红包转余额
static NSString *const DDRequestRedpacketTurnAmount = @"uc.umpayStartService.startHBTransferToAmount";
//邀请好友列表
static NSString *const BXRequestInviteFriends = @"uc.myCenter.inviteFriends";
//复制邀请码
static NSString *const BXRequestCopyLink = @"uc.myCenter.copyLink";
//资金流水
static NSString *const BXRequestCashFlowRecordList = @"uc.myCenter.cashFlowRecordList";
//快捷卡绑定信息
static NSString *const BXRequestQueryFasterCard = @"uc.myCenter.queryFasterCard";
//获取用户银行卡列表
static NSString *const BXRequestBankCardList = @"uc.myCenter.bankCardList";
//还款日历按月查
static NSString *const BXRequestRepaymentCalendarMonth = @"uc.myCenter.repaymentCalendarMonth";
//还款日历按天查
static NSString *const BXRequestRepaymentCalendarDay = @"uc.myCenter.repaymentCalendarDay";
//回款日历按月查
static NSString *const BXRequestReturnMoneyCalendarMonth = @"uc.myCenter.returnMoneyCalendarMonth";
//回款日历按天查
static NSString *const BXRequestReturnMoneyCalendarDay = @"uc.myCenter.returnMoneyCalendarDay";
//消息列表   参数 pageNum=1;pageSize=15
static NSString *const BXRequestMessageList = @"uc.myCenter.messageList";
//消息详情   参数 readId=56276
static NSString *const BXRequestGetInnerMailById = @"uc.myCenter.getInnerMailById";
//我的优惠券列表  参数 pageNum,pageSize,ZT:状态(1：未使用 2：冻结 3：已用 4：已过期)
static NSString *const BXRequestGetAllcouponList = @"uc.myCenter.getAllcouponList";
//选择可用优惠券  参数 TZJE:出借金额(可以不传)
static NSString *const BXRequestUseCouponList = @"uc.myCenter.useCouponList";

//公告列表   参数 pageNum=1;pageSize=15;belong_type=notice
static NSString *const BXRequestIndustry = @"uc.contactusService.industry_OPEN";
//公告详情   参数 id=430
static NSString *const BXRequestIndustryDetail = @"uc.contactusService.industryDetail_OPEN";
//我的奖励
static NSString *const DDMyRewardRecord = @"uc.myCenter.cashRewardRecord";
//企业提现接口
static NSString *const BXRequestStartECash = @"uc.umpayStartService.startECash";
//提交评估结果接口
static NSString *const DDRequsetAssessResult = @"uc.user.riskLevelEval";
//获取银行限额详情
static NSString *const DDRequestBankLimit = @"uc.bank.bankLimitInfo_OPEN";
//我的奖品
static NSString *const DDMyWinningRecord = @"uc.extension.getMyWinningRecord";



#pragma debtService
//债权转让列表
static NSString *const BXRequestDebtlist = @"uc.debtService.rightsList_OPEN";
//债权转让详情
static NSString *const BXRequestRightsDetail = @"uc.debtService.rightsDetail_OPEN";
//可转让债权列表
static NSString *const BXRequestCanBeSelledCreditRightsList = @"uc.myCenter.getCanBeSelledCreditRightsList";
//计算转出价格和手续费
static NSString *const BXRequestComputingFee = @"uc.myCenter.computingFee";
//转让中的标列表
static NSString *const BXRequestSellingCreditRightsList = @"uc.myCenter.getSellingCreditRightsList";
//债权转出服务
static NSString *const BXRequestSellCreditRights = @"uc.myCenter.sellCreditRights";
//撤销转让服务
static NSString *const BXRequestUnsellCreditRights = @"uc.myCenter.unsellCreditRights";


@interface BXHTTPParamInfo : NSObject

//数据参数
@property (nonatomic, strong) NSDictionary *dataParam;
//添加的urlstring
@property (nonatomic, copy) NSString *serviceString;

@end


@interface BXNetworkRequest : NSObject<UIAlertViewDelegate>
//
@property (nonatomic, strong) UIAlertView  *alert;

+ (instancetype)defaultManager;

//发送GET请求
-(void)getWithWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild;

//发送POST请求
- (void)postWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild;

//发送POST请求，附带head信息
- (void)postHeadWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild;

//获取AppStore信息
- (void)postAppStoreInfosucceccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild;

//发送统计数据  注意：不能删此方法，不然出借失败
-(void)getStatisticsWithWithHTTParamInfo:(BXHTTPParamInfo *)info succeccResultWithDictionaty:(BXNetworkRequestSuccessBlock)success faild:(void (^)(NSError *error))faild;


@end

