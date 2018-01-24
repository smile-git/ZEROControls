//
//  CustomHeaderFooterView.h
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomHeaderFooterView,CellHeaderFooterDataAdapter;

@protocol CustomHeaderFooterViewDelegate <NSObject>

@optional

/**
 CustomHeaderFooterView's event

 @param customHeaderFooterView CustomHeaderFooterView object.
 @param event                  Event data.
 */
- (void)customHeaderFooterView:(CustomHeaderFooterView *)customHeaderFooterView event:(id)event;

@end

@interface CustomHeaderFooterView : UITableViewHeaderFooterView

#pragma mark - Properties

/**
 CustomHeaderFooterView's dataAdapter.
 */
@property (nonatomic, weak)  CellHeaderFooterDataAdapter *adapter;


/**
 CustomHeaderFooterView's data.
 */
@property (nonatomic, weak) id data;


/**
 TableView's section
 */
@property (nonatomic, assign) NSInteger section;

/**
 CustomHeaderFooterView's delegate.
 */
@property (nonatomic, weak) id<CustomHeaderFooterViewDelegate> delegate;

#pragma mark - Method voerride by subclass.

/**
 Setup HeaderFooterView, override by subclass.
 */
- (void)setupHeaderFooterView;

/**
 Build subview, override by subclass.
 */
- (void)buildSubview;

/**
 Load content, override by subclass.
 */
- (void)loadContent;

/**
 Calculate the cell's from data, overwrite by subclass.

 @param data Data
 @return HeaderFooterView's height.
 */
+ (CGFloat)headerFooterViewHeightWithData:(id)data;

#pragma mark - Adapters.

+ (CellHeaderFooterDataAdapter *)dataAdapterWithReuseIdentifier:(NSString *)reuseIdentifier data:(id)data height:(CGFloat)height type:(NSInteger)type;
+ (CellHeaderFooterDataAdapter *)dataAdapterWithData:(id)data height:(CGFloat)height type:(NSInteger)type;
+ (CellHeaderFooterDataAdapter *)dataAdapterWithData:(id)data height:(CGFloat)height;
+ (CellHeaderFooterDataAdapter *)dataAdapterWithHeight:(CGFloat)height type:(NSInteger)type;
+ (CellHeaderFooterDataAdapter *)dataAdapterWithHeight:(CGFloat)height;

+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapterWithReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type;
+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data type:(NSInteger)type;
+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data;
+ (CellHeaderFooterDataAdapter *)fixedHeightTypeDataAdapter;
@end
