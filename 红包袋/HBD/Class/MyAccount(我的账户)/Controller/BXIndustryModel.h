//
//  BXIndustryModel.h
//  
//
//  Created by echo on 16/3/1.
//
//  消息中心列表公告model

#import <Foundation/Foundation.h>

@interface BXIndustryModel : NSObject

// 标题
@property (nonatomic, copy) NSString *BT;
// 发布时间
@property (nonatomic, copy) NSString *FBSJ;
// 内容简介
@property (nonatomic, copy) NSString *NRJJ;
// 详情参数id
@property (nonatomic, copy) NSString *WZZX_ID;

@end
