//
//  LJWCyclePageView.m
//  CycleCollectionViewTest
//
//  Created by ljw on 15/3/28.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "LJWCyclePageView.h"
#import "LJWCollectionViewCell.h"

#define ItemsNumber (_numberOfItems + 4 > 4 ? _numberOfItems + 4 : 0)

@interface LJWCyclePageView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSTimer *cycleTimer;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LJWCyclePageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LJWCyclePageViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = delegate;
        
        _numberOfItems = [self.delegate numberOfItems];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        layout.minimumInteritemSpacing = 0.0f;
        layout.minimumLineSpacing = 0.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        
        [self.collectionView registerClass:[LJWCollectionViewCell class] forCellWithReuseIdentifier:@"LJWCollectionViewCell"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        if (_numberOfItems) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
        _pageControl = [[UIPageControl alloc] init];
        CGSize size = [self.pageControl sizeForNumberOfPages:_numberOfItems];
        self.pageControl.frame = CGRectMake(frame.size.width - size.width - 10, frame.size.height - size.height, size.width, size.height);
        self.pageControl.numberOfPages = _numberOfItems;
        self.pageControl.userInteractionEnabled = NO;
    
        [self addSubview:self.pageControl];

        
    }
    return self;
}


#pragma mark - ControlMethod
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
{
    
    if (!_numberOfItems) {
        return;
    }

    _currentIndex = index;
    
    [self.collectionView scrollToItemAtIndexPath:[self getRealIndexPath:index] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

- (void)setPageControlPosition:(LJWPageControlPosition)pageControlPosition
{
    _pageControlPosition = pageControlPosition;
    
    CGFloat centerX = 0;
    
    switch (pageControlPosition) {
        case LJWPageControlPositionDefault:
        case LJWPageControlPositionLeft:
        {
            centerX = 20 + self.pageControl.frame.size.width / 2;
        }
            break;
        case LJWPageControlPositionCenter:
        {
            centerX = self.frame.size.width / 2;
        }
            break;
        case LJWPageControlPositionRight:
        {
            centerX = self.frame.size.width - 20 - self.pageControl.frame.size.width / 2;
        }
            break;
            
        default:
            break;
    }
    
    self.pageControl.center = CGPointMake(centerX, self.pageControl.center.y);
    
}

- (void)reloadData
{
    _numberOfItems = [self.delegate numberOfItems];
    [self.collectionView reloadData];
    if (_numberOfItems) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    CGSize size = [self.pageControl sizeForNumberOfPages:_numberOfItems];
    self.pageControl.frame = CGRectMake(self.frame.size.width - size.width - 10, self.frame.size.height - size.height, size.width, size.height);
    self.pageControlPosition = self.pageControlPosition;
    self.pageControl.numberOfPages = _numberOfItems;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self setCurrentView:scrollView];
    
    [self setCurrentPage:scrollView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    BOOL flag = ((NSInteger)scrollView.contentOffset.x % (NSInteger)self.frame.size.width <= 50);
    
    [self setCurrentView:scrollView];
    
    if (flag) {
        
        [self setCurrentPage:scrollView];
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseAutoCycle];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startAutoCycle];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LJWCollectionViewCell *item = (LJWCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([(UIViewController *)self.delegate canPerformAction:@selector(ljwCyclePageView:didSelectedView:atIndex:) withSender:self.delegate]) {
        
        [self.delegate ljwCyclePageView:self didSelectedView:item.myContentView atIndex:[self getDataIndexWithIndexPath:indexPath]];
        
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ItemsNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSInteger dataIndex = [self getDataIndexWithIndexPath:indexPath];
    
    LJWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LJWCollectionViewCell" forIndexPath:indexPath];
    
    cell.myContentView = [self.delegate ljwCyclePageView:self viewForIndex:dataIndex];
    
    return cell;
    
}

#pragma mark - CaculateMethod
- (NSInteger)getDataIndexWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger dataIndex = indexPath.row - 2;
    
    if (indexPath.row < 2) {
        dataIndex = _numberOfItems - 2 + indexPath.row;
    }
    else if (indexPath.row > _numberOfItems + 2 - 1)
    {
        dataIndex = indexPath.row - _numberOfItems - 2;
    }
    
    return dataIndex;
}

- (NSIndexPath *)getRealIndexPath:(NSInteger)index
{
    return [NSIndexPath indexPathForItem:index + 2 inSection:0];
}

#pragma mark - SetMethod
- (void)setCurrentView:(UIScrollView *)scrollView
{
    
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    if (indexPath.row <= 0) {
        
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:ItemsNumber - 3 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }
    else if (indexPath.row >= ItemsNumber - 2)
    {
        
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }
    
}

#pragma mark - setter
- (void)setCurrentPage:(UIScrollView *)scrollView
{
    
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    self.pageControl.currentPage = [self getDataIndexWithIndexPath:indexPath];
    
    _currentIndex = self.pageControl.currentPage;
    
}

- (void)autoCycle:(BOOL)autoCycle
{
    _autoCycle = autoCycle;
    
    _currentIndex = -1;
    
    if (autoCycle) {
        [self startAutoCycle];
    }
    else
    {
        [self pauseAutoCycle];
    }
    
}

#pragma mark - TimerMethod
- (void)didTimerRunOnce:(NSTimer *)timer
{
//    if (ItemsNumber) {
        [self scrollToIndex:_currentIndex + 1 animated:YES];
//    }
}

- (void)stopAutoCycle
{
    [self.cycleTimer invalidate];
}

- (void)initTimer
{
    self.cycleTimer = nil;
    
    self.cycleTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(didTimerRunOnce:) userInfo:self.cycleTimer repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.cycleTimer forMode:NSRunLoopCommonModes];
}

- (void)startAutoCycle
{
    [self initTimer];
}

- (void)pauseAutoCycle
{
    [self.cycleTimer invalidate];
    self.cycleTimer = nil;
}

- (void)dealloc
{
    [self stopAutoCycle];
}

//0 1  2 3 4 5  6 7

@end
