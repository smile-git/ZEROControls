//
//  ZEROAlbumListController.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/27.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlbumListController.h"
#import "NSBundle+ZEROImagePicker.h"
#import "ZEROImagePickerController.h"
#import "ZEROPhotoPickerController.h"
#import "ZEROAssetModel.h"
#import "ZEROPhotoManager.h"
#import "UIView+Ext.h"
#import "ZEROAlbumListCell.h"

@interface ZEROAlbumListController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *albumArray;
@end

@implementation ZEROAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [NSBundle zero_loaclizedStringForKey:@"Photos"];
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:zImagePickerVC.cancelBtnTitleStr style:UIBarButtonItemStylePlain target:zImagePickerVC action:@selector(cancelButtonClick)];
    
    // ----- 仿微信，在相册列表页定义backBarButtonItem为返回
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle zero_loaclizedStringForKey:@"Back"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self configerTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    ZEROImagePickerController *imagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    [imagePickerVC hideProgressHUD];
    if (_albumArray) {
        
        [_albumArray enumerateObjectsUsingBlock:^(ZEROAlbumModel *_Nonnull albumModel, NSUInteger idx, BOOL * _Nonnull stop) {
            albumModel.selectedModels = imagePickerVC.selectedModels;
        }];
        [_tableView reloadData];
    } else {
        
        [self configerTableView];
    }
}

- (void)configerTableView {
    
    CGFloat cellHeight = 70;
    ZEROImagePickerController *imagePickerVC = (ZEROImagePickerController *)self.navigationController;
    [[ZEROPhotoManager shareManager] getAllAlbumsVideo:imagePickerVC.allowPickingVideo allowPickingImage:imagePickerVC.allowPickingImage completion:^(NSArray<ZEROAlbumModel *> *albumModels) {
        
        _albumArray = [NSMutableArray arrayWithArray:albumModels];
        [_albumArray enumerateObjectsUsingBlock:^(ZEROAlbumModel *_Nonnull albumModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            albumModel.cellHeight     = cellHeight;
            albumModel.selectedModels = imagePickerVC.selectedModels;
        }];
        
        if (!_tableView) {
            
            CGFloat top = 44;
            if (iOS7Later) top += 20;
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height - top) style:UITableViewStylePlain];
            _tableView.rowHeight       = cellHeight;
            _tableView.tableFooterView = [UIView new];
            _tableView.dataSource      = self;
            _tableView.delegate        = self;
            
            [_tableView registerClass:[ZEROAlbumListCell class] forCellReuseIdentifier:@"ZEROAlbumListCell"];
            [self.view addSubview:_tableView];
        } else {
            
            [_tableView reloadData];
        }
    }];
}

#pragma mark - ---- Delegate method ----
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZEROAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZEROAlbumListCell"];
    ZEROImagePickerController *imagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    cell.selectedCountButton.backgroundColor = imagePickerVC.okBtnNormalTitleColor;
    cell.albumModel    = _albumArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZEROPhotoPickerController *photoPickerVC = [[ZEROPhotoPickerController alloc] init];
    ZEROAlbumModel *albumModel = _albumArray[indexPath.row];
    photoPickerVC.albumModel   = albumModel;
    
    __weak typeof(self)weakSelf = self;
    photoPickerVC.backButtonClickHandle = ^(ZEROAlbumModel *ablumModel) {
        
        [weakSelf.albumArray replaceObjectAtIndex:indexPath.row withObject:ablumModel];
    };
    
    [self.navigationController pushViewController:photoPickerVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
