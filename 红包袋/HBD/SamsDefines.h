//
//  SamsDefines.h
//  TrigSAMSBSU
//
//  Created by szjxmac on 15/4/29.
//  Copyright (c) 2015年 Tianxy. All rights reserved.
//


// MARK:友盟
#define UM_APPKEY_NEW               @"5983e340c895762fe8001de4"
#define DDKeyLoginState             @"DDKeyLoginState"
#define DDUserVipState              @"DDUserVipState"

// 微信分享--
#define WXAPPID                 @"wxff1c1a26b9f47a08"
#define WXAPPSECRET             @"6000f36477766001075c69a9c8ce41d5"


#define BUGLYID                 @"5cbb914c02"
#define JGAppKey                @"d8451fdf3f0a9a453187f144"
#define JGSecret                @"d41ed1bd6deb3d15f688e870"

#define kAppStoreUrl            @"https://itunes.apple.com/cn/app/hong-bao-dai/id1090834403?mt=8"
#define kUpdateUrl              [NSString stringWithFormat:@"%@/version.xml",BXWebViewState]
#define kChannelId              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ChannelId"]
#define kPushToLogin            @"pushToLogin"
#define APPID                   @"1090834403"


#import "AppUtils.h"


// touchID标示
#define BXTouchIDEnabe  @"touchIDEnabe"

//-------app设置------------
#define APPNAME                 @"红包贷"
#define kShortVersion           @"CFBundleShortVersionString"
#define callService             @"telprompt://4006740088"


// 图片
#define NAVBG_IMG                   @"Snip20160419_1"
#define NAV_BACK_WHITE_IMG          @"icon_back"
#define NAV_BACK_BLACK_IMG          @"nav_fanhui"

// 高度
#define TABLECELL_H		   134     //我要出借cell
#define NAVBAR_H		   44      //导航栏
#define TABBAR_H           49      // 默认TabBar高度
#define kMagicViewHieght 41.0


// 空
#define EMPTY_STRING    @""
#define EMPTY_TEXT      @""
#define BXObjcNull           ((id)[NSNull null])

// 颜色

#define COLOUR_BTN_Orange           DDRGB(236.0f, 116.0f, 96.0f)  //深橘色
#define COLOUR_Gray_Loan            COLOUR_YELLOW  //立即出借按钮灰
#define COLOUR_Gray_Bg              DDRGB(250.0f, 250.0f, 250.0f) //浅灰背景
#define COLOUR_BTN_Gray             @"#d8d8d8" //立即出借列表按钮灰


#define COLOUR_BTN_BLUE_TITELCOLOR  DDRGB(45.0f, 65.0f, 94.0f) //文字的颜色


#define COLOUR_BTN_BLUE             DDRGB(231.0f, 51.0f, 61.0f) //app红色
#define COLOUR_BTN_BLUE_NEW         DDRGB(231.0f, 51.0f, 61.0f) //app新版蓝色
#define COLOUR_YELLOW              @"#F6AB00"     // 金黄色
#define COLOUR_GRAY                @"#888889"    //灰色

#define COLOUR_Black             [UIColor blackColor]
#define COLOUR_White             [UIColor whiteColor]
#define COLOUR_Clear             [UIColor clearColor]
#define COLOUR_Gray              [UIColor grayColor]
#define COLOUR_LightGray         [UIColor lightGrayColor]
#define COLOUR_GroupTbColor      [UIColor groupTableViewBackgroundColor]
#define COLOUR_Red               [UIColor redColor]
#define COLOUR_Green             [UIColor greenColor]
#define COLOUR_Yellow            [UIColor yellowColor]
#define COLOUR_Blue              [UIColor blueColor]
#define COLOUR_Orange            [UIColor orangeColor]

// 字体
#define FONT_11             [UIFont systemFontOfSize:11]
#define FONT_12             [UIFont systemFontOfSize:12]
#define FONT_14             [UIFont systemFontOfSize:14]
#define FONT_15             [UIFont systemFontOfSize:15]
#define FONT_16             [UIFont systemFontOfSize:16]

// 字体粗体
#define FONT_BOLD_11        [UIFont boldSystemFontOfSize:11]
#define FONT_BOLD_12        [UIFont boldSystemFontOfSize:12]
#define FONT_BOLD_14        [UIFont boldSystemFontOfSize:14]
#define FONT_BOLD_16        [UIFont boldSystemFontOfSize:16]

// 一周7天时间秒值 60*60*1*24*7
#define ONE_WEEK_SECONDS        604800

//-------常用宏------------
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define SCREEN_SIZE  [UIScreen mainScreen].bounds.size
// 获得屏幕高度宽度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT_NODH   [[UIScreen mainScreen] bounds].size.height-64

// 获得应用程序高度宽度
#define APP_HEIGHT      [[UIScreen mainScreen] applicationFrame].size.height
#define APP_WIDTH       [[UIScreen mainScreen] applicationFrame].size.width

// 获得状态栏高度
#define APP_STATUS_HEIGHT       [[UIApplication sharedApplication] statusBarFrame].size.height

// 加载图片
#define IMG(name)       [UIImage imageNamed:name]
// 加载大图片
#define IMG_CACHE(name)      [UIImage imageWithContentsOfFile:name]

// 获得资源中本地字符串
#define LOCALIZED_STRING(name)  NSLocalizedStringFromTable(name, @"InfoPlist", nil)

// 自定义Log
#ifdef DEBUG
# define DDLog(format, ...) NSLog((@"[FUNCTION:%s][LINE:%d]" format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DDLog(...);
#endif

// 快速生成颜色
#define BXCustomColor(r , g, b, a) [[UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0  alpha:(a)/255.0 ] CGColor]
//
#define BXColor(r , g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0  alpha:(a)/255.0 ]
//// 颜色
#define DDRGB(r,g,b)			[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

// RGB转换成UIColor
#define DDColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// RGB转换成UIColor 带透明度
#define DDColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define DDRandomColor DDColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//十六进制转换成UIColor
#define DDHex2Rgb(hexValue) [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16)/255.0 green:((hexValue & 0xFF00) >> 8)/255.0 blue:((hexValue & 0xFF))/255.0 alpha:1.0]

#define DDAngle2Rotation(angle)    (((angle) / 180.0) * M_PI)


// 当前系统版本号 & 版本号
#define SYSTEM_VERSION              [[[UIDevice currentDevice] systemVersion] floatValue]

#define IS_VERSION_GREATER_IOS7		[[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IS_VERSION_LESS_IOS7        [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0

#define IS_VERSION_GREATER_IOS8     [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define IS_VERSION_LESS_IOS8        [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0

#define IS_IOS9_UP		      [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define IS_IOS9_DOWN          [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0

#define IS_IOS10_UP           [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0
#define IS_IOS10_DOWN         [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0

#define IS_IOS11_UP           [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0
#define IS_IOS11_DOWN         [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0


// 判断机型4/4S, 5/5S/5C, 6/6S, 6P/6SP
#define IS_IPHONE4      [[UIScreen mainScreen] bounds].size.height == 480
#define IS_IPHONE5      [[UIScreen mainScreen] bounds].size.height == 568
#define IS_IPHONE6      [[UIScreen mainScreen] bounds].size.height == 667
#define IS_IPHONE6P      [[UIScreen mainScreen] bounds].size.height == 736
//#define IS_IPHONEX      [[UIScreen mainScreen] bounds].size.height == 736
// iPhone X 尺寸 375*812
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_iPhoneX (IS_IPHONE && SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f)

//-----


//----单例---
#ifndef SLModelProject_Singleton_h
#define SLModelProject_Singleton_h
#define singletonInterface(className)   + (instancetype)shared##className;

#if __has_feature(objc_arc)
/**
 *  ARC Version
 */
#define singletonImplementation(className)  \
static id instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone {  \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
if (instance == nil) {  \
instance = [super allocWithZone:zone];  \
}   \
}); \
return instance;    \
}   \
+ (instancetype)shared##className { \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
instance = [[self alloc] init]; \
}); \
return instance;    \
}   \
- (id)copyWithZone:(NSZone *)zone { \
return instance;    \
}
#else
/**
 *  MRC Version
 */
#define singletonImplementation(className)  \
static id instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone {  \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
if (instance == nil) {  \
instance = [super allocWithZone:zone];  \
}   \
}); \
return instance;    \
}   \
+ (instancetype)shared##className { \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
instance = [[self alloc] init]; \
}); \
return instance;    \
}   \
- (id)copyWithZone:(NSZone *)zone { \
return instance;    \
}   \
- (oneway void)release {}   \
- (instancetype) retain {return instance;}  \
- (instancetype) autorelease {return instance;} \
- (NSUInteger) retainCount {return ULONG_MAX;}


#endif
#endif


