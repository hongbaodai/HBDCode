//
//  BXMessagedetailController.h
//  
//
//  Created by echo on 16/2/29.
//
//  消息详情页

#import <UIKit/UIKit.h>
#import "BaseNormolViewController.h"

@interface BXMessagedetailController : BaseNormolViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

// 类型
@property (nonatomic, copy) NSString *type;
// ID
@property (nonatomic, copy) NSString *parameterId;
// 个人消息时间
@property (nonatomic, copy) NSString *messageTime;
// 标题
@property (nonatomic, copy) NSString *ZNZLX;

/** 创建控制器 **/
+ (instancetype)creatVCFromStroyboard;

@end
