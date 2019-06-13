
//
//  HXNewsSwitchVC.m
//  HBD
//
//  Created by hongbaodai on 2017/8/25.
//

#import "HXNewsSwitchVC.h"
#import "BXMessageCenterController.h"
#define kMagicColor @"60a7ff"

@interface HXNewsSwitchVC ()
/** MagicView数据 */
@property (nonatomic, strong)NSArray *dataArr;

@end

@implementation HXNewsSwitchVC

/** 初始化HXNewsSwitchVC */
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
    self.title = @"站内信";
    _dataArr = [NSArray arrayWithObjects:@"未读", @"已读", nil];
}

- (void)setUI{
    self.view.backgroundColor = kColor_BackGround_Gray;
    self.magicView.itemScale = 1.0;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = kColor_Red_Main;
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
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:kColor_Title_Blue forState:UIControlStateNormal];
        [menuItem setTitleColor:kColor_Red_Main forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (0 == pageIndex) {
        static NSString *identifier = @"CYTeachRankingListVC1.identifier";
        BXMessageCenterController *VC1 = [magicView dequeueReusablePageWithIdentifier:identifier];
        if (!VC1) {
            VC1 = [[BXMessageCenterController alloc] initWithMessageCenterController:StatusTypeUnRead];
        }
        return VC1;
    }
    if (1 == pageIndex) {
        static NSString *identifier = @"CYTeachRankingListVC2.identifier";
        BXMessageCenterController *VC2 = [magicView dequeueReusablePageWithIdentifier:identifier];
        if (!VC2) {
            VC2 = [[BXMessageCenterController alloc] initWithMessageCenterController:StatusTypeRead];
        }
        return VC2;
    }
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
