//
//  ZEROPhotoPickerController.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/29.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEROAlbumModel;
@interface ZEROPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, strong) ZEROAlbumModel *albumModel;

@property (nonatomic, copy) void (^backButtonClickHandle)(ZEROAlbumModel *ablumModel);

@end
