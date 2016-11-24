//
//  SiftTagManager.h
//  SiftTag
//
//  Created by ZWX on 2016/11/24.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SiftTagManager : NSObject

@property (nonatomic, strong) NSArray *data;

- (CGSize)sizeWithIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)edgeInsetsWithSection:(NSInteger)section;

- (CGFloat)minimumInteritemSpacingWithSection:(NSInteger)section;

@end
