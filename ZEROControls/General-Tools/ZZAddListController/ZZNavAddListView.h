//
//  ZZAddListView.h
//  NavAddList
//
//  Created by ZWX on 27/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZNavAddListView : UIView


/**
 init method

 @param frame self's frame
 @param rightOffset triang right offset
 @return ZZNavAddListView
 */
- (instancetype)initWithFrame:(CGRect)frame rightOffset:(CGFloat)rightOffset;

- (instancetype)initWithFrame:(CGRect)frame rightOffset:(CGFloat)rightOffset viewFillColor:(UIColor *)viewFillColor;
@end
