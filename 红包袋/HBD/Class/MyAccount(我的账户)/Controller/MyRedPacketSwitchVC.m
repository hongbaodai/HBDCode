//
//  MyRedPacketSwitchVC.m
//  HBD
//
//  Created by hongbaodai on 2017/9/27.
//

#import "MyRedPacketSwitchVC.h"
#import "MyRedPacketListVC.h"

@interface MyRedPacketSwitchVC ()
/** MagicView数据 */
@property (nonatomic, strong)NSArray *dataArr;
@end

@implementation MyRedPacketSwitchVC

/** 初始化MyRedPacketSwitchVC */
- (instancetype)initWithteach:(BOOL)teaArea
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setData];
    [self setUI];
}

- (void)setData
{
    self.title = @"我的奖券";
    _dataArr = [NSArray arrayWithObjects:@"未使用", @"已使用", @"已过期", nil];
}

- (void)setUI
{    
    self.view.backgroundColor = COLOUR_Gray_Bg;

    self.magicView.itemScale = 1.0;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = COLOUR_BTN_BLUE_NEW;
    self.magicView.sliderHeight = 2.0;
    self.magicView.sliderExtension = 0;
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.navigationHeight = kMagicViewHieght;
    self.magicView.headerHeight = 41.0;
    self.magicView.separatorHidden = YES;
    self.magicView.againstStatusBar = NO;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    
    [self.magicView reloadData];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _dataArr;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"MyRedPacketSwitchVC";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:COLOUR_BTN_BLUE_TITELCOLOR forState:UIControlStateNormal];
        [menuItem setTitleColor:COLOUR_BTN_BLUE_NEW forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (0 == pageIndex) {
        static NSString *identifier = @"MyRedPacketListVC0.identifier";
        MyRedPacketListVC *VC0 = [magicView dequeueReusablePageWithIdentifier:identifier];
        if (!VC0) {
            VC0 = [[MyRedPacketListVC alloc] myRedPacketListVC:RedTypeUnuse];
            VC0.cardDict = self.cardPersonDict;
        }
        return VC0;
    }
    if (1 == pageIndex) {
        static NSString *identifier = @"MyRedPacketListVC1.identifier";
        MyRedPacketListVC *VC1 = [magicView dequeueReusablePageWithIdentifier:identifier];
        if (!VC1) {
            VC1 = [[MyRedPacketListVC alloc] myRedPacketListVC:RedTypeUsed];
            VC1.cardDict = self.cardPersonDict;

        }
        return VC1;
    }
    if (2 == pageIndex) {
        static NSString *identifier = @"MyRedPacketListVC2.identifier";
        MyRedPacketListVC *VC2 = [magicView dequeueReusablePageWithIdentifier:identifier];
        if (!VC2) {
            VC2 = [[MyRedPacketListVC alloc] myRedPacketListVC:RedTypeOutOfDate];
            VC2.cardDict = self.cardPersonDict;
        }
        return VC2;
    }
    return nil;
}

@end
