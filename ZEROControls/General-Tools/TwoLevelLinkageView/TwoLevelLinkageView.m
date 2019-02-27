//
//  TwoLevelLinkageView.m
//  TwoLevelLinkage
//
//  Created by ZWX on 2018/1/11.
//  Copyright © 2018年 ZWX. All rights reserved.
//

#import "TwoLevelLinkageView.h"
#import "TwoLevelLinkageCell.h"
#import "CustomHeaderFooterView.h"


@interface TwoLevelLinkageView ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_leftSideTableView;
    UITableView *_rightSideTableView;
}

@property (nonatomic, assign) CGFloat leftSideWidth;

/**
 当前选中cell‘row
 */
@property (nonatomic, assign) NSInteger leftTableViewCurrentSelectedCellIndex;

/**
 判断是否点击的左侧cell，防止右侧非手动滑动时影响左侧
 */
@property (nonatomic, assign) BOOL isSelectedLeft;
@end

@implementation TwoLevelLinkageView

- (instancetype)initWithFrame:(CGRect)frame leftSideWidth:(CGFloat)leftSideWidth {
    
    if (self = [super initWithFrame:frame]) {
        
        self.leftSideWidth = leftSideWidth;
        
        [self buildSubview];
    }
    
    return self;
}

- (void)buildSubview {
    
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    // ----- 两个级联tableView初始化
    _leftSideTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _leftSideWidth, height) style:UITableViewStylePlain];
    _leftSideTableView.delegate   = self;
    _leftSideTableView.dataSource = self;
    _leftSideTableView.showsVerticalScrollIndicator  = NO;
    _leftSideTableView.separatorStyle                = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_leftSideTableView];
    
    _rightSideTableView = [[UITableView alloc] initWithFrame:CGRectMake(_leftSideWidth, 0, width - _leftSideWidth, height) style:UITableViewStylePlain];
    
    _rightSideTableView.delegate   = self;
    _rightSideTableView.dataSource = self;
    _rightSideTableView.showsVerticalScrollIndicator  = NO;
    _rightSideTableView.separatorStyle                = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_rightSideTableView];
    
    [_rightSideTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - public method

- (void)registCellWithLeftTableView:(void (^)(UITableView *leftSideTableView))leftSideTableViewBlock cellAndHeaderWithRightTableView:(void (^)(UITableView *rightSideTableView))rightSideTableViewBlock {
    
    if (leftSideTableViewBlock) {
        
        leftSideTableViewBlock(_leftSideTableView);
    }
    
    if (rightSideTableViewBlock) {
        
        rightSideTableViewBlock(_rightSideTableView);
    }
}

- (void)registCellWithTableViews:(RegistCellWithTableViewBlock)tableViewBlock {
    
    if (tableViewBlock) {
        
        tableViewBlock (_leftSideTableView, _rightSideTableView);
    }
}

- (void)leftTableViewCellMakeSelectedAtRow:(NSInteger)row {
    
    TwoLevelLinkageCell *cell = [_leftSideTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    
    // ----- cell更新选择状态
    [cell updateToSelectedStateAnimated:YES];
    
    // ----- 更新当前所选cell
    self.leftTableViewCurrentSelectedCellIndex = row;
}

- (void)reloadData {
    
    [_leftSideTableView reloadData];
    [_rightSideTableView reloadData];
}

#pragma mark - ---- Delegate Method ----
#pragma mark TableViewDeleagte & TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:_leftSideTableView]) {
        
        return self.leftModels.count;
        
    } else {
        
        return self.leftModels[section].subModels.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([tableView isEqual:_rightSideTableView]) {
        
        return self.leftModels.count;
        
    } else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellDataAdapter *adapter = [self adapterWithTableView:tableView indexPath:indexPath];
    TwoLevelLinkageCell *cell = [tableView dequeueReusableCellWithIdentifier:adapter.cellReuseIdentifier];
    
    cell.dataAdapter = adapter;
    cell.levelModel  = [self linkageModelWithTableView:tableView indexPath:indexPath];
    cell.data        = adapter.data;
    cell.indexPath   = indexPath;
    
    [cell loadContent];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:_rightSideTableView]) {
        
        CellHeaderFooterDataAdapter *adapter = self.leftModels[section].headerAdapter;
        CustomHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:adapter.reusedIdentifier];
        
        headerView.adapter = adapter;
        headerView.data = adapter.data;
        headerView.section = section;
        
        [headerView loadContent];
        
        return headerView;
        
    } else {
        
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self adapterWithTableView:tableView indexPath:indexPath].cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:_rightSideTableView]) {
        
        LeftLevelLinkageModel *leftModel = self.leftModels[section];
        CellHeaderFooterDataAdapter *adapter = leftModel.headerAdapter;
        CGFloat height = adapter.height;
        return height;
        
    } else {
        
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_leftSideTableView]) {
        
        NSInteger newSelectIndex = indexPath.row;
        
        // ----- 触发代理方法
        if ([self.delegate respondsToSelector:@selector(twoLevelLinkageView:selectedLeftSideTableViewItemRow:item:)]) {
            
            [self.delegate twoLevelLinkageView:self selectedLeftSideTableViewItemRow:indexPath.row item:self.leftModels[newSelectIndex].adapter.data];
        }
        
        // ----- 点击之后，更新旧的和新的cell的选中状态
        [self updateSelectedIndexValueWithOldIndex:_leftTableViewCurrentSelectedCellIndex newIndex:newSelectIndex];
        
        self.isSelectedLeft = YES;
        [_rightSideTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:newSelectIndex]
                                   atScrollPosition:UITableViewScrollPositionTop
                                           animated:YES];
        
        // ----- 点击左侧cell状态
        [self performSelector:@selector(makeIsInSelectedAnimationDurationEquilNO) withObject:nil afterDelay:0.05f];
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(twoLevelLinkageView:selectedRightSideTableViewItemIndexPath:item:)]) {
            
            [self.delegate twoLevelLinkageView:self selectedRightSideTableViewItemIndexPath:indexPath item:self.leftModels[indexPath.section].subModels[indexPath.row].adapter.data];
        }
    }
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // ----- 手动滑动右侧tableView条件下
    if ([scrollView isEqual:_rightSideTableView] && _isSelectedLeft == NO) {
        
        NSIndexPath *indexPath = [_rightSideTableView indexPathForCell:_rightSideTableView.visibleCells.firstObject];
        NSInteger section      = indexPath.section;
        
        if (_leftTableViewCurrentSelectedCellIndex != section) {
            
            NSInteger newLeftSelectIndex = section;
            
            [self updateSelectedIndexValueWithOldIndex:_leftTableViewCurrentSelectedCellIndex newIndex:newLeftSelectIndex];
            
            [_leftSideTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]
                                      atScrollPosition:UITableViewScrollPositionMiddle
                                              animated:YES];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // ----- 非手动条件下滑动停止，更改状态
    if ([scrollView isEqual:_rightSideTableView]) {
        
        self.isSelectedLeft = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_rightSideTableView]) {
        
        self.isSelectedLeft = NO;
    }
}


#pragma mark - ---- Whtiin The Method ----

- (void)makeIsInSelectedAnimationDurationEquilNO {
    
    NSLog(@"makeIsInSelectedAnimationDurationEquilNO");
    self.isSelectedLeft = NO;
}

- (void)updateSelectedIndexValueWithOldIndex:(NSInteger)oldIndex newIndex:(NSInteger)newIndex {
    
    self.leftModels[oldIndex].selected = NO;
    self.leftModels[newIndex].selected = YES;
    
    [self updateLeftSideTableViewCellStateWithRow:oldIndex selectedState:NO];
    [self updateLeftSideTableViewCellStateWithRow:newIndex selectedState:YES];
    
    _leftTableViewCurrentSelectedCellIndex = newIndex;
}

- (void)updateLeftSideTableViewCellStateWithRow:(NSInteger)row selectedState:(BOOL)selectedState {
    
    TwoLevelLinkageCell *cell = [_leftSideTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    
    [cell updateSelectedState:selectedState animate:YES];
}


- (CellDataAdapter *)adapterWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    CellDataAdapter *adapter = nil;
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    if ([tableView isEqual:_leftSideTableView]) {
        
        adapter = self.leftModels[row].adapter;
        
    } else {
        
        adapter = self.leftModels[section].subModels[row].adapter;
    }
    
    return adapter;
}

- (id)linkageModelWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    id data = nil;
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    if ([tableView isEqual:_leftSideTableView]) {
        
        data = self.leftModels[row];
        
    } else {
        
        data = self.leftModels[section].subModels[row];
    }
    
    return data;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    // 点击左侧tableView中的cell触发移动
    if (self.isSelectedLeft == YES) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(makeIsInSelectedAnimationDurationEquilNO) object:nil];
    }
}

- (void)dealloc {
    
    [_rightSideTableView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
