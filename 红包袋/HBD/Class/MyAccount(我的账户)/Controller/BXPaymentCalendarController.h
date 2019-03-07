//
//  BXPaymentCalendarController.h
//  
//
//  Created by echo on 16/2/25.
//
//  回款日历

#import <UIKit/UIKit.h>
#import "RDVCalendarView.h"
#import "BaseNormolViewController.h"

@interface BXPaymentCalendarController : BaseNormolViewController<RDVCalendarViewDelegate>


//
@property (nonatomic, strong) RDVCalendarView  *calendarView;

@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;
+ (instancetype)creatVCFromStroyboard;

@end
