//
//  ECSortAlgorithms.h
//  ECRainbowSort
//
//  Created by chen.wenqiang on 15/7/4.
//
//

#import <Foundation/Foundation.h>

@interface ECSortAlgorithms : NSObject

void straightInsertSort(float arr[], int len);
void shellSort(float arr[], int len);
void bubbleSort(float arr[], int len);
void quickSort(float arr[], int len);
void simpleSelectionSort(float arr[], int len);
void heapSort(float arr[], int len);
void mergeSort(float arr[], int len);
void radixSort(float arr[], int len);

@end
