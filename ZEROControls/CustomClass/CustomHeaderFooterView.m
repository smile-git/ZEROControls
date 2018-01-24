//
//  CustomHeaderFooterView.m
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "CustomHeaderFooterView.h"
#import "CellHeaderFooterDataAdapter.h"

@implementation CustomHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupHeaderFooterView];
        [self buildSubview];
    }
    
    return self;
}

#pragma mark - Method voerride by subclass.

- (void)setupHeaderFooterView {
    
}

- (void)buildSubview {
    
}

- (void)loadContent {
    
}

+ (CGFloat)headerFooterViewHeightWithData:(id)data {
    
    return 0.f;
}

#pragma mark - Adapters.

+ (CellHeaderFooterDataAdapter *)dataAdapterWithReuseIdentifier:(NSString *)reuseIdentifier data:(id)data height:(CGFloat)height type:(NSInteger)type {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:reuseIdentifier data:data height:height type:type];
}

+ (CellHeaderFooterDataAdapter *)dataAdapterWithData:(id)data height:(CGFloat)height type:(NSInteger)type {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:NSStringFromClass([self class]) data:data height:height type:type];
}

+ (CellHeaderFooterDataAdapter *)dataAdapterWithData:(id)data height:(CGFloat)height {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:NSStringFromClass([self class]) data:data height:height type:0];
}

+ (CellHeaderFooterDataAdapter *)dataAdapterWithHeight:(CGFloat)height type:(NSInteger)type {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:NSStringFromClass([self class]) data:nil height:height type:type];
}

+ (CellHeaderFooterDataAdapter *)dataAdapterWithHeight:(CGFloat)height {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:NSStringFromClass([self class]) data:nil height:height type:0];
}

+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapterWithReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:reuseIdentifier data:data height:[[self class] headerFooterViewHeightWithData:data] type:type];
}

+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data type:(NSInteger)type {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:NSStringFromClass([self class]) data:data height:[[self class] headerFooterViewHeightWithData:data] type:type];
}
+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:NSStringFromClass([self class]) data:data height:[[self class] headerFooterViewHeightWithData:data] type:0];
}
+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapter {
    
    return [CellHeaderFooterDataAdapter cellHeaderFooterDataAdapterWithReuseIdentifier:NSStringFromClass([self class]) data:nil height:[[self class] headerFooterViewHeightWithData:nil] type:0];
}
@end
