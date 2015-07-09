//
//  ECRainbowSortAlgorithms.m
//  ECRainbowSort
//
//  Created by chen.wenqiang on 15/7/8.
//
//

#import "ECRainbowSortAlgorithms.h"

#define isNotCancel ![[NSThread currentThread]isCancelled]

@implementation ECRainbowSortAlgorithms

/**
 *  模拟慢速CPU,在大量循环位移操作中加入delayTime
 *
 *  @param time 延迟次数
 */
- (void)delayTime:(int)time
{
    if ([self.delegate respondsToSelector:@selector(extraOperation:)]) {
        [self.delegate extraOperation:time];
    }
}

/**
 *  直接插入排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)straightInsertSort:(float[])arr Len:(int)len
{
    float temp;
    for (int i = 1; i < len && isNotCancel; i++)
    {
        if (arr[i] < arr[i - 1])
        {
            // 将arr[i]元素存入temp
            temp = arr[i];
            int j = i;
            // 将i左侧比i大的元素右移一位
            do
            {
                arr[j] = arr[j - 1];
                [self delayTime:1];
                j--;
            } while (j > 0 && temp < arr[j - 1] && isNotCancel);
            
            // 将temp存入比i大的最小元素的左侧位置
            arr[j] = temp;
            [self delayTime:2];
        }
        
    }
}

/**
 *  希尔排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)shellSort:(float[])arr Len:(int)len
{
    float temp;
    // 初始步长
    int gap = len / 2;
    while (gap != 0 && isNotCancel)
    {
        // 改进版的直接插入排序
        for (int i = gap; i < len && isNotCancel; i++)
        {
            if (arr[i] < arr[i - gap])
            {
                temp = arr[i];
                int j = i;
                
                do
                {
                    arr[j] = arr[j - gap];
                    [self delayTime:1];
                    j -= gap;
                } while (j - gap >= 0 && temp < arr[j - gap] && isNotCancel);
                
                arr[j] = temp;
                [self delayTime:2];
            }
        }
        // 缩小增量
        gap /= 2;
        
    }
}

/**
 *  冒泡排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)bubbleSort:(float[])arr Len:(int)len
{
    float temp;
    //每趟排序将无序元素中的最小元素换到有序元素的右侧
    for (int i = 0; i < len - 1 && isNotCancel; i++)
    {
        for (int j = len - 1; j > i && isNotCancel; j--)
        {
            if (arr[j - 1] > arr[j] && isNotCancel)
            {
                temp = arr[j - 1];
                arr[j - 1] = arr[j];
                arr[j] = temp;
                [self delayTime:3];
            }
        }
    }
}

/**
 *  快速排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)quickSort:(float[])arr Len:(int)len
{
    [self reQuickSort:arr Low:0 High:len - 1];
}

/**
 *  递归快排
 *
 *  @param arr  待排数组
 *  @param low  起始位置
 *  @param high 终止位置
 */
- (void)reQuickSort:(float[])arr Low:(int)low High:(int)high
{
    if (low < high && isNotCancel)
    {
        //将目标数组一分为二，得到枢轴位置
        int pivotLoc = [self partition:arr Low:low High:high];
        //对低子表递归排序
        [self reQuickSort:arr Low:low High:pivotLoc - 1];
        //对高子表递归排序
        [self reQuickSort:arr Low:pivotLoc + 1 High:high];
    }
}

/**
 *  一趟快排
 *
 *  @param arr  待排数组
 *  @param low  起始位置
 *  @param high 终止位置
 *
 *  @return 下一个枢轴位置
 */
- (int)partition:(float[])arr Low:(int)low High:(int)high
{
    // 用子表的第一个记录作枢轴记录
    float pivotKey = arr[low];
    // 从表的两端交替地向中间扫描
    while (low < high && isNotCancel)
    {
        // 将比枢轴记录小的记录交换到低端
        while (low < high && arr[high] >= pivotKey)
        {
            --high;
        }
        arr[low] = arr[high];
        // 将比枢轴记录大的记录交换到高端
        while (low < high && arr[low] <= pivotKey)
        {
            ++low;
        }
        arr[high] = arr[low];
        [self delayTime:1];
    }
    // 枢轴记录到位
    arr[low] = pivotKey;
    [self delayTime:1];
    return low;
}

/**
 *  简单选择排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)simpleSelectionSort:(float[])arr Len:(int)len
{
    float temp;
    //每趟排序将无序元素中的最小元素换到有序元素的右侧
    for (int i = 0; i < len && isNotCancel; i++)
    {
        int min = i;
        for (int j = i + 1; j < len && isNotCancel; j++)
        {
            if (arr[j] < arr[min])
            {
                min = j;
            }
        }
        temp = arr[i];
        arr[i] = arr[min];
        arr[min] = temp;
        [self delayTime:3];
    }
}

/**
 *  堆排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)heapSort:(float[])arr Len:(int)len
{
    // 构建最大堆
    for (int i = len / 2; i > 0 && isNotCancel; i--)
    {
        [self buildMaxHeap:arr Index:i HeapSize:len];
    }
    // 将堆顶元素放入堆底的有序序列，并重新调整最大堆
    for (int i = len - 1; i > 0 && isNotCancel; i--)
    {
        // 每次在构建好最大堆后，将第一个元素arr[0]和最后一个元素arr[i]交换
        [self swapHeap:arr Index:0 IndexReplace:i];
        // 此时arr[i]为堆的最大值，所以对arr[0]到arr[i - 1]元素进行调整
        len--;
        // 每次新组成的堆除了根节点其他的节点都保持最大堆的特性，因此只要再以根节点为基准调整就可以得到新的最大堆
        [self buildMaxHeap:arr Index:1 HeapSize:len];
    }
}

/**
 *  构建最大堆：调整当前节点和子节点使当前节点为最大元素
 *
 *  @param arr      子堆数组
 *  @param index    当前节点
 *  @param heapSize 堆容量
 */
- (void)buildMaxHeap:(float[])arr Index:(int)index HeapSize:(int)heapSize
{
    int largeIndex = index;
    //当前节点的左子节点
    int leftChildIndex = index << 1;
    //当前节点的右子节点
    int rightChildIndex = (index << 1) + 1;
    //左子节点存在且左子节点大于当前节点
    if (leftChildIndex <= heapSize && arr[leftChildIndex - 1] > arr[largeIndex - 1])
    {
        largeIndex = leftChildIndex;
    }
    //右子节点存在且右子节点大于当前节点
    if (rightChildIndex <= heapSize && arr[rightChildIndex - 1] > arr[largeIndex - 1])
    {
        largeIndex = rightChildIndex;
    }
    if (index != largeIndex)
    {
        [self swapHeap:arr Index:index - 1 IndexReplace:largeIndex - 1];
        [self buildMaxHeap:arr Index:largeIndex HeapSize:heapSize];
    }
}

/**
 *  互换堆中两个值
 *
 *  @param arr          堆数组
 *  @param index
 *  @param indexReplace
 */
- (void)swapHeap:(float[])arr Index:(int)index IndexReplace:(int)indexReplace
{
    float temp = arr[index];
    arr[index] = arr[indexReplace];
    arr[indexReplace] = temp;
    [self delayTime:3];
}

/**
 *  归并排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)mergeSort:(float[])arr Len:(int)len
{
    //在整个排序过程中始终使用同一个暂存数组，空间利用率高
    float tempArr[len];
    [self reMergeSort:arr TempArr:tempArr First:0 Last:len - 1];
}

/**
 *  将目标数组循环折半，递归执行归并排序核心，再组合成有序数组
 *
 *  @param arr     待排数组
 *  @param tempArr 暂存数组
 *  @param first   子表的起始位置
 *  @param last    子表的终止位置
 */
- (void)reMergeSort:(float[])arr TempArr:(float[])tempArr First:(int)first Last:(int)last
{
    if (first < last && isNotCancel)
    {
        int mid = (first + last) / 2;
        [self reMergeSort:arr TempArr:tempArr First:first Last:mid];
        [self reMergeSort:arr TempArr:tempArr First:mid + 1 Last:last];
        [self reMergeSortCore:arr TempArr:tempArr First:first Mid:mid Last:last];
    }
}

/**
 *  归并排序核心:将两个有序的左右子表（以mid区分），合并成一个有序表
 *
 *  @param arr     待排数组
 *  @param tempArr 暂存数组
 *  @param first   子表的起始位置
 *  @param mid     子表的划分位置
 *  @param last    子表的终止位置
 */
- (void)reMergeSortCore:(float[])arr TempArr:(float[])tempArr First:(int)first Mid:(int)mid Last:(int)last
{
    //左侧子表的起始位置
    int indexA = first;
    //右侧子表的起始位置
    int indexB = mid + 1;
    int tempIndex = 0;
    //遍历左右子表，直到其中一个表遍历完
    while (indexA <= mid && indexB <= last && isNotCancel)
    {
        //左子表的最小元素 <= 右子表的最小元素
        if (arr[indexA] <= arr[indexB])
        {
            //左子表的最小元素暂存数组，遍历左子表下标+1
            tempArr[tempIndex++] = arr[indexA++];
            [self delayTime:1];
        }
        else
        {
            tempArr[tempIndex++] = arr[indexB++];
            [self delayTime:1];
        }
    }
    //有一侧子表遍历完后，将另一侧子表剩下的数一次放入暂存数组中，暂存数组保持有序
    while (indexA <= mid && isNotCancel)
    {
        tempArr[tempIndex++] = arr[indexA++];
        [self delayTime:1];
    }
    while (indexB <= last && isNotCancel)
    {
        tempArr[tempIndex++] = arr[indexB++];
        [self delayTime:1];
    }
    //将暂存数组中有序的元素写回到目标数组的指定位置，使进行归并的数组段有序
    tempIndex = 0;
    for (int i = first; i <= last && isNotCancel; i++)
    {
        arr[i] = tempArr[tempIndex++];
        [self delayTime:1];
    }
}

/**
 *  基数排序
 *
 *  @param arr 待排数组
 *  @param len 数组长度
 */
- (void)radixSort:(float[])arr Len:(int)len
{
    // 整数最高位
    int frontDigit = 0;
    // 小数最高位
    int behindDigit = 0;
    
    // 存放待排字符串
    const char* allNumChar[len][2];
    
    for (int i = 0; i < len && isNotCancel; i++) {
        NSString *numStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:arr[i]]];
        NSArray *numArr = [numStr componentsSeparatedByString:@"."];
        
        // 计算最高整数和小数位
        allNumChar[i][0] = [numArr[0] UTF8String];
        if (strlen(allNumChar[i][0]) > frontDigit) {
            frontDigit = (int)strlen(allNumChar[i][0]);
        }
        
        if (numArr.count == 2) {
            allNumChar[i][1] = [numArr[1] UTF8String];
            if (strlen(allNumChar[i][1]) > behindDigit) {
                behindDigit = (int)strlen(allNumChar[i][1]);
            }
        } else {
            allNumChar[i][1] = "0";
        }
        [self delayTime:1];
    }
    
    // 最高总位数
    int allDigit = frontDigit + behindDigit;
    
    // 存放每一位整数和小数
    int everyDigit[len][allDigit];
    
    // 1.拆分每一位数字
    for (int i = 0; i < len && isNotCancel; i++) {
        // 每一位整数位
        for (int j = 0; j < frontDigit; j++) {
            // 整数补0位的个数
            int zeroDigit = frontDigit - (int)strlen(allNumChar[i][0]);
            if (j >= zeroDigit) {
                char c[2];
                c[0] = allNumChar[i][0][j - zeroDigit];
                c[1] = '\0';
                everyDigit[i][j] = atoi(c);
            } else {
                everyDigit[i][j] = 0;
            }
            [self delayTime:1];
        }
        
        // 每一位小数位
        for (int j = 0; j < behindDigit ; j++) {
            if (strlen(allNumChar[i][1]) > 0) {
                if (strlen(allNumChar[i][1]) > j) {
                    char c[2];
                    c[0] = allNumChar[i][1][j];
                    c[1] = '\0';
                    everyDigit[i][j + frontDigit] = atoi(c);
                } else {
                    everyDigit[i][j + frontDigit] = 0;
                }
            } else {
                everyDigit[i][j + frontDigit] = 0;
            }
            [self delayTime:1];
        }
    }
    
    // 2.调整顺序
    int tempArr[len][allDigit];
    float resultArr[len];
    
    for (int i = allDigit - 1; i >= 0 && isNotCancel; i--) {
        // 计数器
        int countArr[10] = {0};
        for (int j = 0; j < len && isNotCancel; j++) {
            countArr[everyDigit[j][i]]++;
            [self delayTime:1];
        }
        
        // 累加在i位上出现j及比j小的数字的次数
        for (int j = 1; j < 10 && isNotCancel; j++)
        {
            countArr[j] += countArr[j - 1];
            [self delayTime:1];
        }
        
        // 调整顺序
        for (int j = len - 1; j >= 0 && isNotCancel; j--) {
            int splitNumIndex = countArr[everyDigit[j][i]] - 1;
            for (int k = 0; k < allDigit && isNotCancel; k++) {
                tempArr[splitNumIndex][k] = everyDigit[j][k];
                [self delayTime:1];
            }
            
            // 直接赋值，免去收集过程
            resultArr[splitNumIndex] = arr[j];
            countArr[everyDigit[j][i]]--;
            [self delayTime:2];
        }
        
        memcpy(everyDigit, tempArr, allDigit * len * sizeof(int));
        memcpy(arr, resultArr, len * sizeof(float));
    }
}

@end
