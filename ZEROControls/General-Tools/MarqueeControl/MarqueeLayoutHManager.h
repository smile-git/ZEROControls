//
//  MarqueeLayoutHManager.h
//  MarqueeControl
//
//  Created by ZWX on 2019/1/16.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarqueeLayoutHManager : NSObject

// item的固定高度
@property (nonatomic, assign) CGFloat itemHeight;
// item高度数组
@property (nonatomic, strong) NSArray <NSNumber *>*itemHeights;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat gap;


- (void)reset;

- (CGSize)conetentSize;


- (void)addElement:(NSNumber *)width;

- (NSArray *)allElements;

- (NSArray *)allFrames;

- (CGRect)frameAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
