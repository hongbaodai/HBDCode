//
//  HXRiskAssessModel.m
//  HBD
//
//  Created by hongbaodai on 2017/12/21.
//

#import "HXRiskAssessModel.h"
#import "SZQuestionItem.h"
#import "SZConfigure.h"

@interface HXRiskAssessModel()

//-----风险控制相关--------
@property (nonatomic, strong) NSArray *assessArray;
@property (nonatomic, strong) NSMutableArray *questionsArr;
@property (nonatomic, strong) NSMutableArray *answersArr;
@property (nonatomic, strong) NSMutableArray *answerArr;
@property (nonatomic, strong) NSMutableArray *scoresArr;
@property (nonatomic, strong) NSMutableArray *tagNumArr;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *optionArray;
@property (nonatomic, strong) NSArray *resultArray;

@end

@implementation HXRiskAssessModel

+ (instancetype)shareRiskModel
{
    HXRiskAssessModel *risk = [[HXRiskAssessModel alloc] init];
    return risk;
}

- (DDRiskAssessViewController *)creaAssessVC
{
    
    [self addRiskAssess];
    
    SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:self.titleArray andOptionArray:self.optionArray andResultArray:self.resultArray andQuestonType:SZQuestionSingleChoice];
    
    //DIY样式
    SZConfigure *configure = [self creatStyle];
    
    DDRiskAssessViewController *riskController = [[DDRiskAssessViewController alloc] initWithItem:item andConfigure:configure];
    
    riskController.pathScoreArr = self.scoresArr;
    riskController.pathTagNumArr = self.tagNumArr;
    
    return riskController;
}

- (SZConfigure *)creatStyle
{
    SZConfigure *configure = [[SZConfigure alloc] init];
    configure.titleSideMargin = 20;
    configure.optionSideMargin = 25;
    configure.titleFont = 13;
    configure.optionFont = 13;
    configure.buttonSize = 20;
    configure.topDistance = 10;
    configure.checkedImage = @"ass_sel";
    configure.unCheckedImage = @"ass_nor";
    configure.buttonSize = 30;
    configure.oneLineHeight = 35;
    configure.titleTextColor = kColor_Title_Blue;
    configure.optionTextColor = [UIColor darkGrayColor];
    configure.backColor = [UIColor clearColor];
    return configure;
}

- (void)addRiskAssess
{
    self.answersArr = [NSMutableArray array];
    self.answerArr = [NSMutableArray array];
    self.scoresArr = [NSMutableArray array];
    self.tagNumArr = [NSMutableArray array];
    
    for (int i = 0; i < self.assessArray.count; i++) {
        //答案数组
        NSString *str = self.assessArray[i][@"answers"];
        
        [self.answersArr addObject:str];
        //答案数组
        [self.answerArr addObject:[[self.answersArr objectAtIndex:i] valueForKey:@"answer"]];
        //分数数组
        [self.scoresArr addObject:[[self.answersArr objectAtIndex:i] valueForKey:@"score"]];
        //标识数组
        [self.tagNumArr addObject:[[self.answersArr objectAtIndex:i] valueForKey:@"tagNum"]];
    }
    
    self.titleArray = (NSArray *)self.questionsArr;
    self.optionArray = (NSArray *)self.answerArr;
}


#pragma mark - 懒加载
- (NSArray *)assessArray
{
    if (_assessArray == nil) {
        _assessArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AssessPlist.plist" ofType:nil]];
    }
    return _assessArray;
}

- (NSMutableArray *)questionsArr
{
    if (_questionsArr == nil) {
        _questionsArr = [NSMutableArray array];
        
        for (int i = 0; i < self.assessArray.count; i++) {
            
            NSString *str = self.assessArray[i][@"qusetion"];
            
            [_questionsArr addObject:str];
        }
    }
    return _questionsArr;
}

- (NSMutableArray *)answersArr
{
    if (_answersArr == nil) {
        _answersArr = [NSMutableArray array];
        
        for (int i = 0; i < self.assessArray.count; i++) {
            
            NSString *str = self.assessArray[i][@"answers"];
            
            [_answersArr addObject:str];
        }
    }
    return _answersArr;
}

- (NSMutableArray *)answerArr
{
    if (_answerArr == nil) {
        _answerArr = [NSMutableArray array];
        
        for (int i = 0; i < self.assessArray.count; i++) {
            
            NSString *str = self.assessArray[i][@"answer"];
            
            [_answerArr addObject:str];
        }
    }
    return _answerArr;
}

- (NSMutableArray *)tagNumArr
{
    if (_tagNumArr == nil) {
        _tagNumArr = [NSMutableArray array];
        
        for (int i = 0; i < self.assessArray.count; i++) {
            
            NSString *str = self.assessArray[i][@"tagNum"];
            
            [_tagNumArr addObject:str];
        }
    }
    return _tagNumArr;
}



@end
