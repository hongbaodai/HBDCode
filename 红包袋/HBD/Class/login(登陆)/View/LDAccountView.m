//
//  LDAccountView.m
//  HBD
//
//  Created by hongbaodai on 2018/4/4.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "LDAccountView.h"
#import "LADAccoutModel.h"

@interface LDAccountView()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation LDAccountView
+ (instancetype)createLDAccountViewWithFrame:(CGRect)frame
{
    LDAccountView *view = [[NSBundle mainBundle] loadNibNamed:@"LDAccountView" owner:nil options:nil].lastObject;
    view.frame = frame;
    return view;
}

- (IBAction)sureAction:(HXButton *)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

- (void)setDataArr:(NSArray *)dataArr
{
    if (dataArr.count < 3) return;
//    
    LADAccoutModel *model1 = dataArr[0];
    LADAccoutModel *model2 = dataArr[1];
    LADAccoutModel *model3 = dataArr[2];
    
    NSString *str = [NSString stringWithFormat:@"推荐您使用以下银行：（各银行充值限额有所不同，建议选择额度高的银行）\n1.%@     %@\n2.%@     %@\n3.%@     %@\n各银行快捷支付支持及限额：",model1.YHMC,model1.ZJTGXE,model2.YHMC,model2.ZJTGXE,model3.YHMC,model3.ZJTGXE];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor colorWithRed:45.0/255.0f green:65.0/255.0f blue:94.0/255.0f alpha:1];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 11.5;
    dic[NSParagraphStyleAttributeName] = paraStyle;
    
    NSAttributedString *arrStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    self.detailLabel.attributedText = arrStr;
}

@end
