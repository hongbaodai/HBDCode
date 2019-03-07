//
//  HXAlertAccount.m
//  HBD
//
//  Created by hongbaodai on 2017/12/13.
//

#import "HXAlertAccount.h"

@implementation HXAlertAccount
singletonImplementation(HXAlertAccount)

- (NSString *)filePath
{
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath = [temp stringByAppendingPathComponent:@"AlertAccount.cout"];
    return filePath;
}

/** 归档 */
- (void)encodeAlertAccout
{
    [NSKeyedArchiver archiveRootObject:self toFile:[self filePath]];
}

/** 解档 */
- (instancetype)coderAlertAccout
{
    HXAlertAccount *valus = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    return valus;
}

/** 解档 */
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        unsigned int cout;
        Ivar *ivars = class_copyIvarList([self class], &cout);
        
        for (int i = 0; i < cout; i ++) {
            Ivar ivar = ivars[i];
            const char *str = ivar_getName(ivar);
            NSString *name = [NSString stringWithUTF8String:str];
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
        free(ivars);
    }
    return self;
}
/** 归档 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int cout;
    Ivar *ivars = class_copyIvarList([self class], &cout);
    for (int i = 0; i < cout; i ++) {
        Ivar ivar = ivars[i];
        const char *str = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:str];
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
    }
    free(ivars);
}

// 获取当前控制器
//+ (UIViewController *)getCurrentVC
//{
//
//    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
//    if (!window) {
//        return nil;
//    }
//    UIView *tempView;
//    for (UIView *subview in window.subviews) {
//        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
//            tempView = subview;
//            break;
//        }
//    }
//    if (!tempView) {
//        tempView = [window.subviews lastObject];
//    }
//
//    id nextResponder = [tempView nextResponder];
//    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
//        tempView =  [tempView.subviews firstObject];
//
//        if (!tempView) {
//            return nil;
//        }
//        nextResponder = [tempView nextResponder];
//    }
//
//    return  (UIViewController *)nextResponder;
//}


//获取Window当前显示的ViewController
+ (UIViewController*)getCurrentVC{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

@end
