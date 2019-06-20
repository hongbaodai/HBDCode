//
//  HBDImgTitleView.h
//  HBD
//
//  Created by 草帽~小子 on 2019/6/6.
//  Copyright © 2019 李先生. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class HBDImgTitleView;


typedef NS_ENUM(NSInteger, SelectTapActionType){
    SelectTapActionTypeCentral = 1,
    SelectTapActionTypeFinance,
    SelectTapActionTypeSecurity,
};
typedef void(^ImgTleTapAction)(SelectTapActionType selectType);

@protocol HBDImgTitleViewDelegate <NSObject>

- (void)imgTitleTapAction:(SelectTapActionType)selectType;

@end

@interface HBDImgTitleView : UIView

@property (nonatomic, copy) ImgTleTapAction imgTleTapAction;
@property (nonatomic, weak) id<HBDImgTitleViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
