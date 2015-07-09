//
//  ECRainbowSortAlgorithms.h
//  ECRainbowSort
//
//  Created by chen.wenqiang on 15/7/8.
//
//

#import <Foundation/Foundation.h>

@protocol ECRainbowSortAlgorithmsDelegate <NSObject>

@optional
- (void)extraOperation:(int)time;
@end

@interface ECRainbowSortAlgorithms : NSObject

- (void)straightInsertSort:(float[])arr Len:(int)len;
- (void)shellSort:(float[])arr Len:(int)len;
- (void)bubbleSort:(float[])arr Len:(int)len;
- (void)quickSort:(float[])arr Len:(int)len;
- (void)simpleSelectionSort:(float[])arr Len:(int)len;
- (void)heapSort:(float[])arr Len:(int)len;
- (void)mergeSort:(float[])arr Len:(int)len;
- (void)radixSort:(float[])arr Len:(int)len;

@property (nonatomic, weak) id<ECRainbowSortAlgorithmsDelegate> delegate;

@end
