//
//  ConntctUSVC.m
//  test
//
//  Created by hongbaodai on 2017/11/23.
//  Copyright © 2017年 hongbaodai. All rights reserved.
//

#import "ConntctUSVC.h"

@interface ConntctUSVC ()

@end

@implementation ConntctUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"联系我们";
    [self setupGroups];

}

- (void)setupGroups
{
    // 0组
    [self setUpGroup0];
}

- (void)setUpGroup0
{
    HXProuductGroup *group0 = [[HXProuductGroup alloc] init];
    group0.cellHeight = 51.0f;
    group0.headerHeight = 10.0f;
    group0.footerHeight = 0;
    HXItem *customerService = [[HXItem alloc] initWithImg:@"callMe" title:@"40067-40088（周一到周五：9:00~18:00）"];
    customerService.titleFont = [UIFont systemFontOfSize:12.0f];
    
    HXItem *announcement = [[HXItem alloc] initWithImg:@"emails" title:@"serve@hongbaodai.com"];
    announcement.titleFont = [UIFont systemFontOfSize:12.0f];

    HXItem *connectUS = [[HXItem alloc] initWithImg:@"Wchat" title:@"红包袋（HBD-DY)"];
    connectUS.titleFont = [UIFont systemFontOfSize:12.0f];

    HXItem *aboutRed = [[HXItem alloc] initWithImg:@"location" title:@"北京市朝阳区东三环中路39号建外SOHO23号楼（南办公室）21层B-2504"];
    aboutRed.titleFont = [UIFont systemFontOfSize:12.0f];

    group0.items = [NSMutableArray arrayWithObjects:customerService, announcement, connectUS, aboutRed, nil];
    [self.datas addObject:group0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
