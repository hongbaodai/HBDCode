//
//  LDAccountEQianBaoView.m
//  HBD
//
//  Created by hongbaodai on 2018/7/3.
//  Copyright © 2018年 caomaoxiaozi All rights reserved.
//

#import "LDAccountEQianBaoView.h"
#import "LADAccoutModel.h"
#import "AletStrViewController.h"

@interface LDAccountEQianBaoView()
@property (weak, nonatomic)IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *selecBut;


@end

@implementation LDAccountEQianBaoView

+ (instancetype)createLDAccountViewWithFrame:(CGRect)frame
{
    LDAccountEQianBaoView *view = [[NSBundle mainBundle] loadNibNamed:@"LDAccountEQianBaoView" owner:nil options:nil].lastObject;
    view.frame = frame;
//    view.selecBut.selected = YES;
    return view;
}

// 确认开户按钮
- (IBAction)sureAction:(id)sender {
    if (!self.selecBut.selected) {
        NSString *aler = @"\n\n        请知悉并同意《授权书》\n";
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"64c1df"];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:aler attributes:attributes];

        [AletStrViewController creatAlertVCWithAttributedString:str sureStr:@"确定" sureBlock:nil];
        return;
    }
    if (self.sureBlock) {
        self.sureBlock();
    }
}

// 选择按钮
- (IBAction)selecAction:(UIButton *)sender {
    self.selecBut.selected = !self.selecBut.selected;
}

// 授权书
- (IBAction)protocalAction:(UIButton *)sender {
    if (self.protoBlock) {
        self.protoBlock();
    }
}


@end
