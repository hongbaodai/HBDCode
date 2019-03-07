//
//  DDMyRewardModel.h
//  HBD
//
//  Created by hongbaodai on 16/11/17.
//

#import <Foundation/Foundation.h>

@interface DDMyRewardModel : NSObject

//标题
@property (nonatomic, copy) NSString *SP_NAME;
//标题
@property (nonatomic, copy) NSString *DESCRIBE;
//奖品来源
@property (nonatomic, copy) NSString *HDMC;
//获得时间
@property (nonatomic, copy) NSString *PRIZE_TIME;
//奖品状态
@property (nonatomic, copy) NSString *STATE;


@end
