//
//  RHFiltrateView.m
//  MCSchool
//
//  Created by 郭人豪 on 2016/12/24.
//  Copyright © 2016年 Abner_G. All rights reserved.
//  筛选页面

#import "RHFiltrateView.h"
#import "RHFiltrateHeaderView.h"
#import "RHFiltrateFooterView.h"
#import "RHFiltrateCell.h"
#import "RHCollectionViewFlowLayout.h"
#import "RHHelper.h"
#import "DDInvestFilttrateVC.h"

#define Cell_Filtrate              @"Cell_Filtrate"
#define Collection_FiltrateHeader  @"Collection_FiltrateHeader"
#define Collection_FiltrateFooter  @"Collection_FiltrateFooter"

#define MarginX      20    //item X间隔
#define MarginY      15    //item Y间隔
#define ItemHeight   20    //item 高度
#define ItemWidth    40    //item 追加宽度

@interface RHFiltrateView () <UICollectionViewDelegate, UICollectionViewDataSource, RHCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * itemArr;
@property (nonatomic, strong) NSMutableArray * dataArr;
@end
@implementation RHFiltrateView


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles items:(NSArray<NSArray *> *)items {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _titleArr = [NSArray arrayWithArray:titles];
        _itemArr = [NSArray arrayWithArray:items];
        [self loadData];
        [self addSubviews];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles items:(NSArray<NSArray *> *)items {
    
    self = [super init];
    
    if (self) {
        
        _titleArr = [NSArray arrayWithArray:titles];
        _itemArr = [NSArray arrayWithArray:items];
        [self loadData];
        [self addSubviews];
        self.backgroundColor = COLOUR_Gray_Bg;
    }
    return self;
}

#pragma mark - load data
- (void)loadData {
    [_dataArr removeAllObjects];
    
    for (int i = 0; i < _itemArr.count; i++) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray * arr = _itemArr[i];
        int k = [self.selectArr[i] intValue];
        
        for (int j = 0; j < arr.count; j++) {
            
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            [dic setObject:arr[j] forKey:@"title"];
   
            if (j == k) {
                
                [dic setObject:@YES forKey:@"isSelected"];
            } else {
                
                [dic setObject:@NO forKey:@"isSelected"];
            }
            [array addObject:dic];
        }
        [self.dataArr addObject:array];
    }
}

- (void)loadData11 {
    
    for (int i = 0; i < _itemArr.count; i++) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray * arr = _itemArr[i];
        
        for (int j = 0; j < arr.count; j++) {
            
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            [dic setObject:arr[j] forKey:@"title"];
            if (j == 0) {
                
                [dic setObject:@YES forKey:@"isSelected"];
            } else {
                
                [dic setObject:@NO forKey:@"isSelected"];
            }
            [array addObject:dic];
        }
        [self.dataArr addObject:array];
    }
}

#pragma mark - add subviews

- (void)addSubviews {
    
    [self addSubview:self.collectionView];
}

#pragma mark - layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _collectionView.frame = self.bounds;
    [self didClickResertBtn];
    [self loadData];
    [_collectionView reloadData];
}


#pragma mark - 重置选项
 
- (void)didClickResertBtn {
    
    [_dataArr removeAllObjects];
    [self loadData11];
    [self.collectionView reloadData];
    
}

#pragma mark - collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _titleArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_itemArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RHFiltrateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell_Filtrate forIndexPath:indexPath];
    
    if (indexPath.row < [self.dataArr[indexPath.section] count]) {
        
        NSDictionary * dic = _dataArr[indexPath.section][indexPath.row];
        [cell configCellWithData:dic];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.dataArr[indexPath.section]];
    
    for (int i = 0; i < array.count; i++) {
        
        NSMutableDictionary * dic = array[i];
        if (i == indexPath.row) {
            
            [dic setObject:@YES forKey:@"isSelected"];
        } else {
            
            [dic setObject:@NO forKey:@"isSelected"];
        }
        [array replaceObjectAtIndex:i withObject:dic];
    }
    [_dataArr replaceObjectAtIndex:indexPath.section withObject:array];
    [_collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(filtrateView:didSelectAtIndexPath:)]) {
        
        [self.delegate filtrateView:self didSelectAtIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        RHFiltrateHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Collection_FiltrateHeader forIndexPath:indexPath];
        headerView.headerTitle = _titleArr[indexPath.section];
        return headerView;
    } else {
        
        RHFiltrateFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Collection_FiltrateFooter forIndexPath:indexPath];
        return footerView;
    }
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    float width = [RHHelper getWidthByText:_itemArr[indexPath.section][indexPath.row] font:FONT_15] + ItemWidth; // --自适应--
    
    return CGSizeMake((SCREEN_WIDTH-22*4)/3, 26);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.bounds.size.width, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(self.bounds.size.width, 10);
}

#pragma mark - setter and getter

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
       /* --自适应-- 此注释部分为宽度自动适配文字和屏幕，如需要根据文字长度适配大小用此部分替换
        RHCollectionViewFlowLayout * flowLayout = [[RHCollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = MarginY;
        flowLayout.minimumInteritemSpacing = MarginX;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 22, 15, 22); //上左下右

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    */
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(11, 22, 14, 22); //上左下右
//        flowLayout.minimumInteritemSpacing = 22; //水平方空隙
        flowLayout.minimumLineSpacing = 22;//设置垂直方向的空隙
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[RHFiltrateCell class] forCellWithReuseIdentifier:Cell_Filtrate];
        [_collectionView registerClass:[RHFiltrateHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Collection_FiltrateHeader];
        [_collectionView registerClass:[RHFiltrateFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Collection_FiltrateFooter];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
