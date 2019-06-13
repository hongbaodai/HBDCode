//
//  HXProductCell.m
//  test
//
//  Created by hongbaodai on 2017/11/22.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "HXProductCell.h"
#import "HXLabelItem.h"
#import "HXArrowItem.h"
#import "HXSwitchItem.h"
#import "HXLabelArrowItem.h"

@interface HXProductCell()

// 底部的横线
@property (nonatomic, strong) UIView *bottomView;

// accessoryView:箭头如偏
@property (nonatomic, strong) UIImageView *arrowIv;

// accessoryView：switch
@property (nonatomic, strong) UISwitch *switchBtn;

// accessoryView：纯文字
@property (nonatomic, strong) UILabel *labelView;

// accessoryView：文字+ 图片（箭头）
@property (nonatomic, strong) UIView *labelAndImgView;
// accessoryView：文字+ 图片（箭头）->label
@property (nonatomic, strong) UILabel *labelAndImgLabel;

@end

@implementation HXProductCell

/** 初始化cell */
+ (instancetype)hxProductCellWithTableView:(UITableView *)tableView style:(NSInteger)style
{
    static NSString *ID = @"setting";
    if (!style) {
        style = 0;
    }
    HXProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HXProductCell alloc] initWithStyle:style reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = kColor_sRGB(46, 65, 94);
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColor_sRGB(245, 245, 245);
        [cell addSubview:view];
        cell.bottomView = view;
    }
    return cell;
}

- (void)setItem:(HXItem *)item
{
    _item = item;
    // 赋值
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subTitle;
    if (item.img) {
        self.imageView.image = [UIImage imageNamed:item.img];
    }
//    self.textLabel.font = [UIFont systemFontOfSize:12.0f];

    if (item.titleFont) {
        self.textLabel.font = item.titleFont;
    }
    if (item.subTitleFont) {
        self.detailTextLabel.font = item.subTitleFont;
    }
    
    // accessoryView
    if ([item isKindOfClass:[HXArrowItem class]]) {
        // 箭头
        HXArrowItem *arroItem = (HXArrowItem *)item;
        if (arroItem.arrowImageStr) {
            self.arrowIv.image = [UIImage imageNamed:arroItem.arrowImageStr];
        }
        self.accessoryView = self.arrowIv;

    } else if ([item isKindOfClass:[HXSwitchItem class]]) {
        // 开关
        self.accessoryView = self.switchBtn;
        NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
        self.switchBtn.on = [defults boolForKey:self.item.title];
        self.switchBtn.onTintColor = kColor_Red_Main;
    } else if ([item isKindOfClass:[HXLabelItem class]]) {
        // 纯文字
        HXLabelItem *labelItem = (HXLabelItem *)item;
        self.labelView.text = labelItem.text;
        [_labelView sizeToFit];

        self.accessoryView = self.labelView;
    } else if ([item isKindOfClass:[HXLabelArrowItem class]]) {
        HXLabelArrowItem *labAndArror = (HXLabelArrowItem *)item;
        [self.labelAndImgView sizeToFit];
        self.labelAndImgLabel.text = labAndArror.text;
        
        self.accessoryView = self.labelAndImgView;
    } else if ([item isKindOfClass:[HXItem class]]) {
        self.accessoryView = nil;
        
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frea = self.accessoryView.frame;
    frea.origin.x += 12;
    self.accessoryView.frame =frea;
    
    
    
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);

}

#pragma mark - 懒加载
/// 懒加载 控件 一般使用strong
- (UILabel *)labelView
{
    if(_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        
        _labelView.font = [UIFont systemFontOfSize:12.0f];
        _labelView.textColor = [UIColor colorWithRed:45.0/255.0f green:65.0/255.0f blue:94.0/255.0f alpha:1];
    }
    return _labelView;
}

- (UIImageView *)arrowIv
{
    if (_arrowIv == nil) {
        _arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        _arrowIv.contentMode = UIViewContentModeRight;
    }
    return _arrowIv;
}

- (UISwitch *)switchBtn
{
    if (_switchBtn == nil) {
        
        _switchBtn = [[UISwitch alloc] init];
        
        // 监听开关的开关状态
        [_switchBtn addTarget:self action:@selector(switchBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (UIView *)labelAndImgView
{
    if (_labelAndImgView == nil) {
        _labelAndImgView = [[UIView alloc] init];
        _labelAndImgView.frame = CGRectMake(0, 0, 160, self.frame.size.height);
        CGFloat w = _labelAndImgView.bounds.size.width;
        CGFloat h = _labelAndImgView.bounds.size.height;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w * (5.0 / 7.0) , h)];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor colorWithRed:45.0/255.0f green:65.0/255.0f blue:94.0/255.0f alpha:1];
        label.textAlignment = NSTextAlignmentRight;
        
        self.labelAndImgLabel = label;

        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        imgView.frame = CGRectMake(CGRectGetWidth(label.frame), 0, w - CGRectGetWidth(label.frame), h);
        imgView.contentMode = UIViewContentModeRight;
        imgView.userInteractionEnabled = NO;

        [_labelAndImgView addSubview:label];
        [_labelAndImgView addSubview:imgView];
//        _labelAndImgView.backgroundColor = [UIColor redColor];
    }
    return _labelAndImgView;
}

- (void)switchBtnClick
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:self.switchBtn.isOn forKey:self.item.title];
//    [defaults synchronize];
    
    if (self.switchBlock) {
        self.switchBlock(self.switchBtn);
    }
}

@end
