//
//  ZEROAlbumListCell.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/27.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZEROAlbumModel;

@interface ZEROAlbumListCell : UITableViewCell

@property (nonatomic, strong) ZEROAlbumModel *albumModel;
@property (nonatomic, strong) UIButton       *selectedCountButton;

@end
