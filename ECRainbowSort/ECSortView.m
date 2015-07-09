//
//  ECSortView.m
//  ECRainbowSort
//
//  Created by chen.wenqiang on 15/7/7.
//
//

#import "ECSortView.h"
#import "ECRainbowSortAlgorithms.h"

// 每行方块数（方块的列数）
#define columnNum 40

@interface ECSortView() <ECRainbowSortAlgorithmsDelegate>

/**
 *  总方块数
 */
@property (nonatomic, assign) int totalCube;

@property (nonatomic, strong) ECRainbowSortAlgorithms *algorithms;
@property (nonatomic) dispatch_source_t timerSource;
@property (nonatomic, assign) BOOL isSorted;
@property (nonatomic, strong) NSThread *sortThread;

@end

@implementation ECSortView

#pragma mark - Init

- (void)dealloc
{
    NSLog(@"Dealloc--%@", self.class);
}

- (NSThread *)sortThread
{
    if (!_sortThread) {
        _sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(beginSort) object:nil];
    }
    return _sortThread;
}

- (dispatch_source_t)timerSource
{
    if (!_timerSource) {
        dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
        _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    return _timerSource;
}

- (ECRainbowSortAlgorithms *)algorithms
{
    if (!_algorithms) {
        _algorithms = [[ECRainbowSortAlgorithms alloc] init];
        _algorithms.delegate = self;
    }
    return _algorithms;
}

float hueValue[10000];

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat cubeWidth = frame.size.width / columnNum;
    int rowNum = frame.size.height / cubeWidth;
    
    self.totalCube = rowNum * columnNum;
    // 制造随机颜色列表
    for (int i = 0; i < self.totalCube; i++) {
        hueValue[i] = (arc4random() % 100) / 100.0;
    }
    return [super initWithFrame:frame];
}

#pragma mark - Events

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 方块边长
    CGFloat cubeWidth = rect.size.width / columnNum;

    for (int i = 0; i < self.totalCube; i++) {
        CGRect cubeRect = CGRectMake((i % columnNum) * cubeWidth, (i / columnNum) * cubeWidth, cubeWidth, cubeWidth);
        
        UIColor *hsbColor = [UIColor colorWithHue:hueValue[i] saturation:1.0 brightness:1.0 alpha:1];
        CGContextSetFillColorWithColor(context, hsbColor.CGColor);
        
        CGContextFillRect(context, cubeRect);
        CGContextStrokePath(context);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 排序只执行一次
    if (self.isSorted)
        return;
    self.isSorted = YES;
    
    [self.sortThread start];
    
    // 循环刷新UI
    dispatch_source_set_timer(self.timerSource, dispatch_walltime(DISPATCH_TIME_NOW, 0), 0.05*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timerSource, ^{
        [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
    });
    dispatch_resume(self.timerSource);
}

/**
 *  在子线程开始排序
 */
- (void)beginSort
{
    // 计时开始
    NSDate *startTime = [NSDate date];
    switch (self.algorithmsIndex) {
        case 0:
            [self.algorithms straightInsertSort:hueValue Len:self.totalCube];
            break;
        case 1:
            [self.algorithms shellSort:hueValue Len:self.totalCube];
            break;
        case 2:
            [self.algorithms bubbleSort:hueValue Len:self.totalCube];
            break;
        case 3:
            [self.algorithms quickSort:hueValue Len:self.totalCube];
            break;
        case 4:
            [self.algorithms simpleSelectionSort:hueValue Len:self.totalCube];
            break;
        case 5:
            [self.algorithms heapSort:hueValue Len:self.totalCube];
            break;
        case 6:
            [self.algorithms mergeSort:hueValue Len:self.totalCube];
            break;
        case 7:
            [self.algorithms radixSort:hueValue Len:self.totalCube];
            break;
        default:
            break;
    }
    
    // 算法名称列表
    NSArray *nameList = AlgorithmsList;
    NSString *name = nameList[self.algorithmsIndex];
    NSNumber *timeInterval = [NSNumber numberWithFloat:-[startTime timeIntervalSinceNow]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:name message:[NSString stringWithFormat:@"排序用时:%@秒", timeInterval] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    // 取消运行循环
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_source_cancel(self.timerSource);
        if (!self.sortThread.isCancelled) {
            [alertView show];
        }
    });
}

/**
 *  取消正在进行的排序
 */
- (void)cancelSorting
{
    [self.sortThread cancel];
}

#pragma mark - ECRainbowSortAlgorithmsDelegate

- (void)extraOperation:(int)time
{
    [NSThread sleepForTimeInterval:time*0.0001];
}

@end
