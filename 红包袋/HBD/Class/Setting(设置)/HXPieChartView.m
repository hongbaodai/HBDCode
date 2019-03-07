//
//  HXPieChartView.m
//  HBD
//
//  Created by hongbaodai on 2017/12/6.//


#import "HXPieChartView.h"
#import "HXPieChartModel.h"

@interface HXPieChartView()

@property (nonatomic, readonly) NSArray *items;
/**
 百分比数据
 */
@property (nonatomic) NSArray *endPercentag;

@end

@implementation HXPieChartView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
    }
    return self;
}
/** 创建视图 */
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if (self == [super initWithFrame:frame]) {
        _items = [NSArray arrayWithArray:items];
        [self doSome];
    }
    return self;
}

/** 处理事件 */
- (void)doSome
{
    [self makeData];
    [self addPie];
}

/** 处理数据 */
- (void)makeData
{
    __block CGFloat currentTotal = 0;

    NSMutableArray *endPercentages = [NSMutableArray new];
    CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];

    [self.items enumerateObjectsUsingBlock:^(HXPieChartModel *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (total == 0){
            [endPercentages addObject:@(1.0 / _items.count * (idx + 1))];
        } else {
            currentTotal += item.value;
            [endPercentages addObject:@(currentTotal / total)];
        }
    }];
    self.endPercentag = [endPercentages copy];
}

/** 添加饼状图 */
- (void)addPie
{
    HXPieChartModel *model;
    // 没有数据的显示
    if (_items.count == 0) {
        CAShapeLayer *circle = [self drawPieWithRadius:83 startPage:0 endPage:1 color:DDColor(239, 239, 239) width:10];
        [self.layer addSublayer:circle];
        return;
    }
    for (int i = 0; i < _items.count; i ++) {
        model = self.items[i];
        CGFloat startPercnetage = [self startPercentageForItemAtIndex:i];
        CGFloat endPercentage   = [self endPercentageForItemAtIndex:i];

        CAShapeLayer *circle = [self drawPieWithRadius:83 startPage:startPercnetage endPage:endPercentage color:model.color width:10];
        [self.layer addSublayer:circle];
    }
}

/** 饼段开始值 */
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index
{
    if(index == 0){
        return 0;
    }
    return [_endPercentag[index - 1] floatValue];
}

/** 饼段结束值 */
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index
{
    return [_endPercentag[index] floatValue];
}

/** 绘制饼状图 */
- (CAShapeLayer *)drawPieWithRadius:(CGFloat)radius startPage:(CGFloat)startPage endPage:(CGFloat)endPage color:(UIColor *)color width:(CGFloat)widths
{
    CAShapeLayer *layer = [CAShapeLayer layer];
     CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.strokeStart = startPage;
    layer.strokeEnd = endPage;
    layer.lineWidth = widths;
    layer.path = path.CGPath;
    return layer;
}

@end
