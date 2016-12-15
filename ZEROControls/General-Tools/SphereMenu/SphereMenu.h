//
//  SphereMenuNew.h
//  SphereMenu
//
//  Created by ZWX on 2016/12/14.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SphereDidSelected)(NSInteger index);

@interface SphereMenu : UIView

- (instancetype)initWithFrame:(CGRect)frame menuImage:(NSString *)menuImageStr sphereImages:(NSArray <NSString *>*)sphereImages;

@property (nonatomic, copy)   NSString *menuImageStr;
@property (nonatomic, strong) NSArray  <NSString *>*sphereImages;

- (void)showInView:(UIView *)showView completion:(SphereDidSelected)completion;

@end
