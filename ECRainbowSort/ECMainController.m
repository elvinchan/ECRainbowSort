//
//  ECMainController.m
//  ECRainbowSort
//
//  Created by chen.wenqiang on 15/7/7.
//
//

#import "ECMainController.h"
#import "ECSortAlgorithms.h"
#import "ECSortController.h"

@interface ECMainController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextField *algorithmsTextField;
@property (weak, nonatomic) IBOutlet UITextView *outputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *rainbowButton;

@property (nonatomic, strong) NSArray *algorithmsList;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation ECMainController

#pragma mark - Init

- (NSArray *)algorithmsList
{
    if (!_algorithmsList) {
        _algorithmsList = AlgorithmsList;
    }
    return _algorithmsList;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

#pragma mark - Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.outputTextField.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.outputTextField.layer.borderWidth = 0.6f;
    self.outputTextField.layer.cornerRadius = 6.0f;
    
    UIImage *image = [UIImage imageNamed:@"bg_btn"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [self.sortButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.rainbowButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.algorithmsTextField.inputView = self.pickerView;
    self.algorithmsTextField.text = self.algorithmsList[0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)sortClick:(id)sender {
    [self.view endEditing:YES];
    self.outputTextField.text = @"";
    NSString *inputStr = self.inputTextField.text;
    
    // 1.解析
    NSNumberFormatter *numF = [[NSNumberFormatter alloc] init];
    NSArray *inputArr = [inputStr componentsSeparatedByString:@","];
    float arr[inputArr.count];
    int count = 0;
    for (NSString *item in inputArr) {
        NSScanner* scan = [NSScanner scannerWithString:item];
        // 判断是数字
        float floatVal;
        if ([scan scanFloat:&floatVal] && [scan isAtEnd]) {
            arr[count] = [[numF numberFromString:item] floatValue];
            count++;
        } else {
            self.outputTextField.text = @"输入的格式有误,请重试!";
            return;
        }
    }
    // 2.排序
    [self sortAction:arr Length:count];
    
    // 3.输出
    NSString *outputStr = @"";
    for (int i = 0; i < count; i++) {
        NSNumber *num = [NSNumber numberWithFloat:arr[i]];
        if (i == 0) {
            outputStr = [NSString stringWithFormat:@"%@", num];
        } else {
            outputStr = [NSString stringWithFormat:@"%@, %@", outputStr, num];
        }
    }
    self.outputTextField.text = outputStr;
}

/**
 *  开始排序
 *
 *  @param arr   待排序数组
 *  @param count 数组长度
 */
- (void)sortAction:(float[])arr Length:(int)count
{
    int index = (int)[self.algorithmsList indexOfObject:self.algorithmsTextField.text];
    // 计时开始
    NSDate *startTime = [NSDate date];
    switch (index) {
        case 0:
            straightInsertSort(arr, count);
            break;
        case 1:
            shellSort(arr, count);
            break;
        case 2:
            bubbleSort(arr, count);
            break;
        case 3:
            quickSort(arr, count);
            break;
        case 4:
            simpleSelectionSort(arr, count);
            break;
        case 5:
            heapSort(arr, count);
            break;
        case 6:
            mergeSort(arr, count);
            break;
        case 7:
            radixSort(arr, count);
        default:
            break;
    }
    
    NSNumber *timeInterval = [NSNumber numberWithFloat:-[startTime timeIntervalSinceNow]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"排序完成" message:[NSString stringWithFormat:@"用时:%@秒", timeInterval] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.algorithmsList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.algorithmsTextField.text = self.algorithmsList[row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    ECSortController *vc = (ECSortController *)segue.destinationViewController;
    vc.algorithmsIndex = (int)[self.algorithmsList indexOfObject:self.algorithmsTextField.text];
}

@end
