//
//  SlidingDoorLayout.h
//  SlidingDoorCollectoinView
//
//  Created by ZWX on 2017/6/27.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SlidingDoorType) {
    
    SlidingDoorTypeOne,
    SlidingDoorTypeTwo
};

@interface SlidingDoorLayout : UICollectionViewLayout

@property (nonatomic, assign) SlidingDoorType type;

@end
