//
//  BXRepaymentCalendarController.h
//  
//
//  Created by echo on 16/2/25.
//
//  还款日历

#import <UIKit/UIKit.h>
#import "RDVCalendarView.h"

@interface BXRepaymentCalendarController : UIViewController<RDVCalendarViewDelegate>

@property (nonatomic, strong) RDVCalendarView  *calendarView;

@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

+ (instancetype)creatVCFromStroyboard;

@end
