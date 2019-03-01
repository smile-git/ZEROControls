//
//  FoldingCellViewController.m
//  ZEROControls
//
//  Created by ZWX on 2019/2/28.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import "FoldingCellViewController.h"
#import "ZEROControls-Swift.h"

@interface FoldingCellViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CGFloat closeCellHeight;
@property (nonatomic, assign) CGFloat openCellHeight;
@property (nonatomic, assign) NSInteger rowsCount;

@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

@implementation FoldingCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configreDefaultState];
    [self buildSubViews];
}

- (void)configreDefaultState {
    
    _closeCellHeight = 179.0f;
    _openCellHeight = 488.0f;
    _rowsCount = 10;
    
    self.cellHeights = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger index = 0; index < _rowsCount; index ++) {
        
        [_cellHeights addObject:@(_closeCellHeight)];
    }
}

- (void)buildSubViews {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
//    tableView.estimatedRowHeight = _closeCellHeight;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [tableView registerNib:[UINib nibWithNibName:@"FoldingCell" bundle:nil] forCellReuseIdentifier:@"FoldingDemoCell"];
    
    [self.view addSubview:tableView];
}

#pragma mark - ---- Delegate Method ----
#pragma mark TableViewDelegate & TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.cellHeights[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoldingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoldingDemoCell"];
    
    NSTimeInterval time1 = 0.26;
    NSTimeInterval time2 = 0.2;
    NSTimeInterval time3 = 0.2;
    NSArray *durations = @[@(time1), @(time2), @(time3)];
    
    cell.durationsForCollapsedState = durations;
    cell.durationsForExpandedState = durations;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![cell isKindOfClass:[FoldingDemoCell class]]) {
        
        return;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if ([_cellHeights[indexPath.row] floatValue] == _closeCellHeight) {
        
        [(FoldingDemoCell *)cell unfold:NO animated:NO completion:nil];
    } else {
        [(FoldingDemoCell *)cell unfold:YES animated:NO completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoldingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.isAnimating) {
        return;
    }
    
    NSTimeInterval duration = 0.0;
    BOOL cellIsCollapsed = [_cellHeights[indexPath.row] floatValue] == _closeCellHeight;
    if (cellIsCollapsed) {
        _cellHeights[indexPath.row] = @(_openCellHeight);
        [cell unfold:YES animated:YES completion:nil];
        duration = 0.5;
    } else {
        
        _cellHeights[indexPath.row] = @(_closeCellHeight);
        [cell unfold:NO animated:YES completion:nil];
        duration = 0.8;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [tableView beginUpdates];
        [tableView endUpdates];
    } completion:nil];
}

@end
