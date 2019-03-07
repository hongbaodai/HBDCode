//
//  HXProuductGroup.h
//  test
//
//  Created by hongbaodai on 2017/11/22.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXProuductGroup : NSObject

// 头部标题
@property (nonatomic, copy) NSString *headerTitle;
// 尾部标题
@property (nonatomic, copy) NSString *footerTitle;

// 当前分组里面的所有行的数据(包含小模型的数组)
@property (nonatomic, strong) NSMutableArray *items;

// 头部高度
@property (nonatomic, assign) CGFloat headerHeight;
// 尾部高度
@property (nonatomic, assign) CGFloat footerHeight;
// cell高度
@property (nonatomic, assign) CGFloat cellHeight;


@end
