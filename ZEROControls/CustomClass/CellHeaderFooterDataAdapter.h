//
//  CellHeaderFooterDataAdapter.h
//  TwoLevelLinkage
//
//  Created by ZWX on 15/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellHeaderFooterDataAdapter : NSObject


/**
 *  Cell header or footer's reused identifier.
 */
@property (nonatomic, strong) NSString *reusedIdentifier;

/**
 *  Data, can be nil.
 */
@property (nonatomic, strong) id data;

/**
 *  Cell header or footer's height, only used for UITableView's cell.
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  Section value.
 */
@property (nonatomic, assign) NSInteger section;

/**
 *  CellHeader or CellFooter's type (The same header or footer, but maybe have different types).
 */
@property (nonatomic, assign) NSInteger type;


/**
 Constructor

 @param reusedIdentifier Cell header or footer's reused identifier.
 @param                  data Data, can be nil.
 @param                  height Cell header or footer's height, only used for UITableView's cell.
 @param                  type CellHeader or CellFooter's type (The same header or footer, but maybe have different types).
 
 @return CellHeaderFooterDataAdapter
 */
+ (instancetype)cellHeaderFooterDataAdapterWithReuseIdentifier:(NSString *)reusedIdentifier data:(id)data height:(CGFloat)height type:(NSInteger)type;

@end
