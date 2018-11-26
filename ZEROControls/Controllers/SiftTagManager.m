//
//  SiftTagManager.m
//  SiftTag
//
//  Created by ZWX on 2016/11/24.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "SiftTagManager.h"
#import "NSString+LabelWidthAndHeight.h"

#define tag_Margin                  10
#define edgeInsets                  UIEdgeInsetsMake(8, 50, 15, 30)
#define minimumInteritemSpacing     10
#define max_minimumInteritemSpacing 20

@interface SiftTagManager()

@property (nonatomic, strong) NSMutableArray *minimumInteritemSpacings;
@property (nonatomic, strong) NSMutableArray *sizes;

@end

@implementation SiftTagManager

- (instancetype)init{
    
    if (self = [super init]) {
        
        _sizes                      = [NSMutableArray array];
        _minimumInteritemSpacings   = [NSMutableArray array];
        _singleChoose               = NO;
        _tagHeight                  = 40.0;
    }
    return self;
}

- (void)setData:(NSArray *)data{
    
    _data = data;
    
    [self calculate];
}

- (void)setSingleChoose:(BOOL)singleChoose{
    
    _singleChoose = singleChoose;
}

/**
 计算
 */
- (void)calculate{
    
    CGFloat containerWidth = WIDTH - edgeInsets.left - edgeInsets.right;        //容器宽度
    CGFloat minTagWidth    = 60;                                                //tag最小宽度
    __block CGFloat contentWidth;                                               //实际内容宽度
    __block CGFloat beforeContentWidth;                                         //上一行实际内容宽度
    __block CGFloat congtentMaxWidth;                                           //section中,行(row)的最大宽度

    [_data enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull tagDic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableArray *tagSizes  = [NSMutableArray arrayWithCapacity:0];
        contentWidth              = 0.0;
        beforeContentWidth        = 0.0;
        congtentMaxWidth          = 0.0;
        NSArray *tags             = tagDic[@"tags"];
        
        __block NSInteger lineNum       = 1;                   //每个sectin的行(row)数
        __block NSInteger rowItemNum    = 0;                   //每行item个数
        __block NSInteger maxRowItemNum = 0;                   //最宽的一行item个数
        
        [tags enumerateObjectsUsingBlock:^(NSString *_Nonnull tag, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat tagWidth = [tag widthWithStringFont:[UIFont systemFontOfSize:16]];
            CGSize tagSize   = CGSizeMake((tagWidth + tag_Margin * 2) > minTagWidth ? (tagWidth + tag_Margin * 2) : minTagWidth, self->_tagHeight);
            
            [tagSizes addObject:NSStringFromCGSize(tagSize)];
            
            contentWidth += tagSize.width;
            
            if (contentWidth > containerWidth) {
                //超出容量: 行数增加, 算出上一行宽度, 这一行宽度, 这一行item个数
                lineNum ++;
                beforeContentWidth  = containerWidth - tagSize.width - minimumInteritemSpacing;
                contentWidth        = tagSize.width + minimumInteritemSpacing;
                rowItemNum          = 1;
            }
            else{
                //未超出容量, 上一行(此行)宽度、item个数
                beforeContentWidth  = contentWidth;
                contentWidth        += minimumInteritemSpacing;
                rowItemNum ++;
            }
            //全部行数中，最宽的宽度
            congtentMaxWidth = congtentMaxWidth > beforeContentWidth ? congtentMaxWidth : beforeContentWidth;
            maxRowItemNum    = maxRowItemNum > rowItemNum ? maxRowItemNum : rowItemNum;
        }];
        
        //可以根据最宽的那一行的所占宽度，提高此section中每一行的间距
        CGFloat minimumInteritem = max_minimumInteritemSpacing < ((containerWidth - congtentMaxWidth) / (maxRowItemNum - 1) + 10) ? max_minimumInteritemSpacing : ((containerWidth - congtentMaxWidth) / (maxRowItemNum - 1) + 10);
        [self->_minimumInteritemSpacings addObject:@(minimumInteritem)];
        
        if (lineNum == 1 && rowItemNum <= 3) {
            //一行的时候, 并且个数不超过3个的时候，调节tag显示宽度
            //当三个的时候最合适, 求出最适宜tag宽度
            CGFloat okTagWidth = (containerWidth - max_minimumInteritemSpacing * 2) / 3;
            [tags enumerateObjectsUsingBlock:^(NSString *_Nonnull stringSize, NSUInteger idx, BOOL * _Nonnull stop) {
                //如果宽度不够适宜宽度，改变
                CGSize tagSize = CGSizeMake(CGSizeFromString(tagSizes[idx]).width > okTagWidth ? CGSizeFromString(tagSizes[idx]).width : okTagWidth, self->_tagHeight);
                [tagSizes replaceObjectAtIndex:idx withObject:NSStringFromCGSize(tagSize)];
            }];
        }
        
        [self->_sizes addObject:tagSizes];
    }];
}

- (CGSize)sizeWithIndexPath:(NSIndexPath *)indexPath{
    
    if (_data.count == 0) {
        
        return CGSizeMake(tag_Margin * 4, _tagHeight);
    }
    return CGSizeFromString(_sizes[indexPath.section][indexPath.item]);
}

- (UIEdgeInsets)edgeInsetsWithSection:(NSInteger)section{
    
    return edgeInsets;
}

- (CGFloat)minimumInteritemSpacingWithSection:(NSInteger)section{
    
    if (_data.count == 0) {
        
        return minimumInteritemSpacing;
    }
    return [_minimumInteritemSpacings[section] floatValue];
}
@end
