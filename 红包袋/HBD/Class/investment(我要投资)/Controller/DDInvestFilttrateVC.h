//
//  DDInvestFilttrateVC.h
//  HBD
//
//  Created by hongbaodai on 2017/9/25.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDFilttrateDelegate <NSObject>

- (void)didClickFilttrateTermCount:(NSString *)termCount InterestRange:(NSString *)interestRange ProjType:(NSString *)projType;

@end

@interface DDInvestFilttrateVC : BaseNormolViewController

//出借期限
@property (nonatomic, copy) NSString *filTime;
//预期年化收益
@property (nonatomic, copy) NSString *filPercent;
//项目类型
@property (nonatomic, copy) NSString *filType;

@property (nonatomic, weak) id <DDFilttrateDelegate>delgate;

@end
