//
//  DDInvestdInfoView.m
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//  Copyright © 2017年 caomaoxiaozi All rights reserved.
//

#import "DDInvestdInfoView.h"
#import "HXTextAndButModel.h"

@interface DDInvestdInfoView()

@property (weak, nonatomic) IBOutlet UIView *textAndButView;

@end

@implementation DDInvestdInfoView

+ (instancetype)investmentDetailInfoView {
    
    DDInvestdInfoView *InfoView = [[[NSBundle mainBundle] loadNibNamed:@"DDInvestdInfoView" owner:self options:nil] lastObject];

    
    CGRect fra = InfoView.textAndButView.bounds;
    
    [HXTextAndButModel hxProjectItem:InfoView.textAndButView strImgViewFrame:fra status:TextAndImgStatusProjectMoney];
    return InfoView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
