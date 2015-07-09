//
//  ECSortController.m
//  ECRainbowSort
//
//  Created by chen.wenqiang on 15/7/7.
//
//

#import "ECSortController.h"
#import "ECSortView.h"

@interface ECSortController ()

@property (nonatomic, strong) ECSortView *sortView;

@end

@implementation ECSortController

- (void)dealloc
{
    NSLog(@"Dealloc--%@", self.class);
}

- (ECSortView *)sortView
{
    if (!_sortView) {
        CGRect rect = self.view.frame;
        rect.origin.y = self.navigationController.navigationBar.frame.size.height + [UIScreen mainScreen].applicationFrame.origin.y;
        rect.size.height = rect.size.height - rect.origin.y;

        _sortView = [[ECSortView alloc] initWithFrame:rect];
        _sortView.backgroundColor = [UIColor grayColor];
    }
    return _sortView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sortView];
    self.sortView.algorithmsIndex = self.algorithmsIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.sortView cancelSorting];
}

@end
