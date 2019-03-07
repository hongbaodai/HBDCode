//
//  BXSharePageView.m
//  HBD
//
//  Created by echo on 16/3/16.
//  Copyright © 2016年 caomaoxiaozi All rights reserved.
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
