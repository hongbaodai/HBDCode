//
//  BXRepaymentCalendarCell.m
//  
//
//  Created by echo on 16/2/25.
//
//

#import "BXRepaymentCalendarCell.h"

@implementation BXRepaymentCalendarCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _upTypeLabel = [[UILabel alloc]init];
        [_upTypeLabel setBackgroundColor:[UIColor whiteColor]];
        [_upTypeLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [_upTypeLabel setTextAlignment:NSTextAlignmentCenter];
        [_upTypeLabel setHighlighted:YES];
        [self.contentView addSubview:_upTypeLabel];
        
        _downTypeLabel = [[UILabel alloc]init];
        [_downTypeLabel setBackgroundColor:[UIColor whiteColor]];
        [_downTypeLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [_downTypeLabel setTextAlignment:NSTextAlignmentCenter];
        [_downTypeLabel setHighlighted:YES];
        [self.contentView addSubview:_downTypeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize viewSize = self.contentView.frame.size;
    
    [[self upTypeLabel] setFrame:CGRectMake(0, 0, 40, 15)];
    [[self downTypeLabel] setFrame:CGRectMake(0, 0, 40, 15)];
    if (BXSize.width == 320) {
        [self upTypeLabel].center = CGPointMake(viewSize.width / 2, viewSize.height - 13);
        [self downTypeLabel].center = CGPointMake(viewSize.width / 2, viewSize.height );
    }else if(BXSize.width == 375){
        [self upTypeLabel].center = CGPointMake(viewSize.width / 2, viewSize.height - 23);
        [self downTypeLabel].center = CGPointMake(viewSize.width / 2, viewSize.height - 10);
    }else{
        [self upTypeLabel].center = CGPointMake(viewSize.width / 2, viewSize.height - 25);
        [self downTypeLabel].center = CGPointMake(viewSize.width / 2, viewSize.height - 10);
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [[self upTypeLabel] setHidden:YES];
    [[self downTypeLabel] setHidden:YES];
}

@end
