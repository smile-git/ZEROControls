//
//  PhotoChooseView.h
//  ZEROControls
//
//  Created by ZWX on 2016/12/3.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoChooseView : UIView



@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong, readonly) NSArray <UIImage *>* currentPhotos;
@end
