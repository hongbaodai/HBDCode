//
//  BXMessageModel.h
//  
//
//  Created by echo on 16/2/23.
//
//  消息中心列表个人model

#import <Foundation/Foundation.h>

@interface BXMessageModel : NSObject
/*
 data =             (
 {
 FJR = 1;
 FSSJ = "2016-09-30 16:00:29";
 SFYD = 1;
 "ZNX_ID" = 65175;
 ZNZLX = 199;
 senderName = "\U7ea2\U5305\U8d37";
 timeOrder = "-1";
 title = "\U5e86\U5341\U4e00\Uff0c\U667a\U888b\U718a\U9001\U60a888\U5143\U7ea2\U5305\Uff0c\U8be6\U89c1 \U201c\U6211\U7684\U8d26\U6237\U201d - \U201c\U6211\U7684...";
 }
 */
// 类型
@property (nonatomic, copy) NSString *ZNZLX;
// 时间
@property (nonatomic, copy) NSString *FSSJ;
// 标题
@property (nonatomic, copy) NSString *title;
// 详情所需id
@property (nonatomic, copy) NSString *ZNX_ID;

@end
