//
//  BXReminderPageController.h
//  HBD
//
//  Created by echo on 15/9/21.
//  Copyright © 2015年 caomaoxiaozi All rights reserved.
//

#import "ViewController.h"

enum {
    BXRemindeTypeRegisteredSuccess=1,  //注册成功
    BXRemindeTypeOpenSuccess=2,      //开通成功
    BXRemindeTypeOpenFailure=3      //开通失败
};
typedef NSUInteger BXRemindeType;

@interface BXReminderPageController : ViewController

// 页面类型
@property (nonatomic, assign) BXRemindeType remindeType;
// 提示图片
@property (nonatomic, weak) IBOutlet UIImageView *remindImage;
// 主提示
@property (nonatomic, weak) IBOutlet UILabel *remindTitle;
// 副提示
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
// 按钮
@property (nonatomic, weak) IBOutlet UIButton *yesBtn;

// 开通汇付所需参数
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *password;

- (void)settingFrameWithBXRemindeType:(BXRemindeType)remindeType;

- (IBAction)didClickYesBtn:(id)sender;

+ (instancetype)creatVCFromSB;


@end
