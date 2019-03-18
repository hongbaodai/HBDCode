//
//  HWAlertViewController.h
//  HBD
//
//  Created by 草帽~小子 on 2019/3/14.
//  Copyright © 2019 李先生. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickBtnBlock)(void);

@interface HWAlertViewController : UIViewController

@property (nonatomic, copy) ClickBtnBlock clickBtnBlock;

@end

NS_ASSUME_NONNULL_END
