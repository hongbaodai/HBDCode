//
//  HXTextAndButView.m
//
//  Created by hongbaodai on 2017/12/15.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXTextAndButView.h"
#import <YYText/YYTextView.h>
#import <YYText/YYTextAttribute.h>
#import <YYText/YYText.h>

@implementation HXTextAndButView

/** 普通的文字：或可加按钮 */
+ (instancetype)hxTextAndButViewWithStyle:(HXTextAndButStyle *)style
{
    HXTextAndButView *view = [[HXTextAndButView alloc] initWithFrame:style.viewFrame style:style dataArr:nil];
    return view;
}

/** 可点击事件富文本 */
+ (instancetype)hxTextAndButViewWithStyle:(HXTextAndButStyle *)style dataArr:(NSArray *)dataArr
{
    HXTextAndButView *view = [[HXTextAndButView alloc] initWithFrame:style.viewFrame style:style dataArr:dataArr];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame style:(HXTextAndButStyle *)style dataArr:(NSArray *)dataArr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUIWithSytle:style dataArr:dataArr];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setUpUIWithSytle:(HXTextAndButStyle *)style dataArr:(NSArray *)dataArr
{
    NSMutableAttributedString *textf = [[NSMutableAttributedString alloc] init];
    //UIFont *font = [UIFont systemFontOfSize:style.textFont];
    UIFont *font = [UIFont boldSystemFontOfSize:style.textFont];

    NSMutableAttributedString *attachment = nil;
    
    
    if ((dataArr.count > 0)) {
        for (int i = 0; i < dataArr.count; i ++) {
            NSString *str = dataArr[i];
            NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc] initWithString:str];
            muStr.yy_font = [UIFont systemFontOfSize:style.textFont];
            muStr.yy_color = style.textColor;
                        
            WS(weakSelf);
            [muStr yy_setTextHighlightRange:muStr.yy_rangeOfAll color:style.textColor backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                NSLog(@"===%@",[text.string substringWithRange:range]);
                NSString *str = [text.string substringWithRange:range];
                if (weakSelf.tapTextBlock) {
                    weakSelf.tapTextBlock(str);
                }
            }];
            [textf appendAttributedString:muStr];
        }
    } else {
        NSString *str = style.textStr;
        
        UIColor *colo = style.textColor;
        NSDictionary *attrs = @{NSForegroundColorAttributeName : colo};
        
        [textf appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:attrs]];
    }
    
    if (style.butImgStr) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setImage:[UIImage imageNamed:style.butImgStr] forState:UIControlStateNormal];
        but.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
        if (!style.click) {
            [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        CGRect fra = CGRectMake(0, 0, 28, 17);

        but.frame = fra;
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:but contentMode:UIViewContentModeLeft attachmentSize:but.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [textf appendAttributedString: attachment];
    }
    
    textf.yy_font = font;
    YYTextView *textView = [[YYTextView alloc] init];

    textView.frame = self.bounds;
    
//    CGPoint cent = textView.center;
//    cent.y = self.bounds.size.height / 2;
//    textView.center = cent;

    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.alwaysBounceVertical = YES;
    textView.attributedText = textf;
    
    [self addSubview:textView];
}

- (void)butAction:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
