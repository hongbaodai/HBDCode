//
//  BXSharePageView.m
//  ump_xxx1.0
//
//  Created by echo on 16/3/16.
//  Copyright © 2016年 李先生. All rights reserved.
//

#import "BXSharePageView.h"

@implementation BXSharePageView

+ (instancetype)sharePageView{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXSharePageView" owner:self options:nil] lastObject];
}

- (IBAction)didClickWXHYBtn:(id)sender {
    [self.SharePageDelegate didClickWXHYBtn];
}

- (IBAction)didClickWXPYQBtn:(id)sender {
    [self.SharePageDelegate didClickWXPYQBtn];
}

- (IBAction)didClickCancelBtn:(id)sender {
    [self.SharePageDelegate didClickCancelShareBtn];
}
@end
