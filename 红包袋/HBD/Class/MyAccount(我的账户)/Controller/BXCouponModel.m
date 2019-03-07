//
//  BXCouponModel.m
//  HBD
//
//  Created by echo on 16/5/25.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
//

#import "BXCouponModel.h"

@implementation BXCouponModel


//这里重写description方法，用于最后测试排序结果显示
-(NSString *)description{
    return [NSString stringWithFormat:@"MZ is %f , QTQX is %@, JZRQ is %@",_MZ,_QTQX,_JZRQ];
}


@end
