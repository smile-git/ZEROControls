//
//  WWaterFallManager.h
//  WWaterFall
//
//  Created by ZWX on 2016/11/19.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WWaterFallManager : NSObject

@property (nonatomic, strong) NSArray <NSNumber *>* itemHeights;    //item的高度
@property (nonatomic) UIEdgeInsets  edgeInsets;      //
@property (nonatomic) CGFloat       gap;            //两个item间距
@property (nonatomic) CGSize        contentSize;    //collectionView的大小

/**
 reset manager 重置
 */
- (void)reset;


/**
 add element width

 @param width item's width
 */
- (void)addElement:(NSNumber *)width;

- (NSArray *)allElements;

- (NSArray *)allFrames;

- (CGRect)frameAtIndex:(NSInteger)index;

@end
