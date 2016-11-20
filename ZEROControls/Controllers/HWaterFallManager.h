//
//  HWaterFallManager.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWaterFallManager : NSObject

@property (nonatomic, strong) NSArray <NSNumber *> *columnWidths;
@property (nonatomic)         UIEdgeInsets    edgeInsets;
@property (nonatomic)         CGFloat         gap;
@property (nonatomic)         CGSize          contentSize;

- (void)reset;

- (void)addElement:(NSNumber *)height;

- (NSArray *)allElements;

- (NSArray *)allFrames;

- (CGRect)frameAtIndex:(NSInteger)index;

@end
