//
//  SettingBottomView.h
//  HBD
//
//  Created by hongbaodai on 2018/1/29.
//

#import <UIKit/UIKit.h>

typedef void(^QuitBlock)(void);

@interface SettingBottomView : UIView

/** 退出block */
@property (nonatomic, copy) QuitBlock quitBlock;

@end
