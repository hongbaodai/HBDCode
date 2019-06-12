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

#define APPID                   @"1090834403"
#import "AppUtils.h"

// touchID标示
#define BXTouchIDEnabe  @"touchIDEnabe"

//-------app设置------------
#define kShortVersion           @"CFBundleShortVersionString"
#define callService             @"telprompt://4006740088"
#define NAV_BACK_BLACK_IMG          @"nav_fanhui"

#define kMagicViewHieght 41.0

// 颜色
#define COLOUR_BTN_Orange           DDRGB(236.0f, 116.0f, 96.0f)  //深橘色
#define COLOUR_Gray_Loan            COLOUR_YELLOW  //立即出借按钮灰
#define COLOUR_Gray_Bg              DDRGB(250.0f, 250.0f, 250.0f) //浅灰背景
#define COLOUR_BTN_Gray             @"#d8d8d8" //立即出借列表按钮灰

//红色渐变
#define GRADIENTCOLOR_RED    @[(__bridge id)DDRGB(231.0f, 56.0f, 61.0f).CGColor, (__bridge id)DDRGB(244.0f, 105.0f, 113.0f).CGColor]

#define COLOUR_BTN_BLUE_TITELCOLOR  DDRGB(45.0f, 65.0f, 94.0f) //文字的颜色


#define COLOUR_BTN_BLUE             DDRGB(231.0f, 51.0f, 61.0f) //app红色
#define COLOUR_BTN_BLUE_NEW         DDRGB(231.0f, 51.0f, 61.0f) //app新版蓝色
#define COLOUR_YELLOW              @"#F6AB00"     // 金黄色
#define COLOUR_GRAY                @"#888889"    //灰色
#define COLOR_LINE_GRAY            [UIColor colorWithRed:230/255.0 green:230/255.0  blue:230/255.0  alpha:1]

#define COLOUR_White             [UIColor whiteColor]
#define COLOUR_Clear             [UIColor clearColor]
#define COLOUR_Gray              [UIColor grayColor]
#define COLOUR_GroupTbColor      [UIColor groupTableViewBackgroundColor]
#define COLOUR_Yellow            [UIColor yellowColor]

// 字体
#define FONT_11             [UIFont systemFontOfSize:11]
#define FONT_12             [UIFont systemFontOfSize:12]
#define FONT_14             [UIFont systemFontOfSize:14]
#define FONT_15             [UIFont systemFontOfSize:15]
#define FONT_16             [UIFont systemFontOfSize:16]

//-------常用宏------------
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SCREEN_SIZE  [UIScreen mainScreen].bounds.size
// 获得屏幕高度宽度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

// 加载图片
#define IMG(name)       [UIImage imageNamed:name]

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
// 颜色
#define DDRGB(r,g,b)			[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
// RGB转换成UIColor
#define DDColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

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


