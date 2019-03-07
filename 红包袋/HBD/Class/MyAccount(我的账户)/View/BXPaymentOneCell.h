//
//  BXPaymentOneCell.h
//  
//
//  Created by echo on 16/2/25.
//
//  第一个概括元素，两边复用

#import <UIKit/UIKit.h>

@interface BXPaymentOneCell : UITableViewCell
// 类型上
@property (weak, nonatomic) IBOutlet UILabel *upTypeLabel;
// 类型下
@property (weak, nonatomic) IBOutlet UILabel *downTypeLabel;

// 金额上
@property (weak, nonatomic) IBOutlet UILabel *upAmoutLabel;
// 金额下
@property (weak, nonatomic) IBOutlet UILabel *downAmoutLabel;

@end
