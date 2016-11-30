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

@property (nonatomic, strong) NSArray   *data;
@property (nonatomic)         CGFloat   tagHeight;
@property (nonatomic)         BOOL      singleChoose;   //是否单选 default: NO

- (CGSize)sizeWithIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)edgeInsetsWithSection:(NSInteger)section;

- (CGFloat)minimumInteritemSpacingWithSection:(NSInteger)section;

@end
