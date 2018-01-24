//
//  CustomCell.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCell];
        [self buildSubview];
    }
    
    return self;
}

#pragma mark - Method you should overwrite.

- (void)setupCell{
    
}

- (void)buildSubview{
    
}

- (void)loadContent{
    
}

+ (CGFloat)cellHeightWithData:(id)data{
    
    return 0.f;
}

#pragma mark - Useful method.
- (void)selectedEvent {
    
    
}

- (void)updateWithNewHeight:(CGFloat)height animated:(BOOL)animated {
    
    if (_tableView && _dataAdapter) {
        
        if (animated) {
            _dataAdapter.cellHeight = height;
            
            [_tableView beginUpdates];
            [_tableView endUpdates];
        } else {
            
            _dataAdapter.cellHeight = height;
            [_tableView reloadData];
        }
    }
}

#pragma mark - Load content.

- (void)loadContentWithAdapter:(CellDataAdapter *)dataAdapter {
    
    _dataAdapter = dataAdapter;
    _data = dataAdapter.data;
    
    [self loadContent];
}

- (void)loadContentWithAdapter:(CellDataAdapter *)dataAdapter indexPath:(NSIndexPath *)indexPath {
    
    _dataAdapter = dataAdapter;
    _data = dataAdapter.data;
    _indexPath = indexPath;
    
    [self loadContent];
}

- (void)loadContentWithAdapter:(CellDataAdapter *)dataAdapter tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    _dataAdapter = dataAdapter;
    _data = dataAdapter.data;
    _tableView = tableView;
    _indexPath = indexPath;
    
    [self loadContent];
}

#pragma mark - Normal type adapter.
+ (CellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data cellHeight:(CGFloat)height type:(NSInteger)type {
    
    NSString *tmpReuseIdentifier = reuseIdentifier.length <= 0 ? NSStringFromClass([self class]) : reuseIdentifier;
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:tmpReuseIdentifier data:data cellHeight:height cellType:type];
}

+ (CellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height tyep:(NSInteger)type {
    
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellHeight:height cellType:type];
}

+ (CellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height {
    
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellHeight:height cellType:0];
}

+ (CellDataAdapter *)dataAdapterWithData:(id)data {
    
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellHeight:0 cellType:0];
}

+ (CellDataAdapter *)fixedHeightTypeDataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type {
    
    NSString *tmpReuseIdentifier = reuseIdentifier.length <= 0 ? NSStringFromClass([self class]) : reuseIdentifier;
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:tmpReuseIdentifier data:data cellHeight:[[self class] cellHeightWithData:data] cellType:type];
}

+ (CellDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data type:(NSInteger)type {
    
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellHeight:[[self class] cellHeightWithData:data] cellType:type];
}

+ (CellDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data {
    
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellHeight:[[self class] cellHeightWithData:data] cellType:0];
}

+ (CellDataAdapter *)fixedHeightTypeDataAdapter {
    
    return [CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([self class]) data:nil cellHeight:[[self class] cellHeightWithData:nil] cellType:0];
}

@end
