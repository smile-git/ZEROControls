//
//  PhotoPickerViewController.m
//  ZEROControls
//
//  Created by ZWX on 2017/1/12.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "PhotoPickerCell.h"
#import "ZEROImagePickerController.h"

static const NSInteger maxPhotoNum = 4;
@interface PhotoPickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    
    UICollectionView *_collectionView;
}

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *assetArray;
@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoArray = [NSMutableArray array];
    self.assetArray = [NSMutableArray array];
    
    [self configerCollectionView];
}

- (void)configerCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat margin = 3;
    CGFloat itemWH = (self.view.width - margin * 4) / 3;
    layout.minimumLineSpacing      = margin;
    layout.minimumInteritemSpacing = margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    _collectionView                                = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, HEIGHT - NavHeight)
                                                                        collectionViewLayout:layout];
    _collectionView.delegate                       = self;
    _collectionView.dataSource                     = self;
    _collectionView.backgroundColor                = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[PhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
    [self.view addSubview:_collectionView];

}

#pragma mark - ---- Delegate Method ----
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_photoArray.count >= maxPhotoNum) {
        return maxPhotoNum;
    } else {
        return _photoArray.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    if (self.photoArray.count > indexPath.item) {
        cell.photo = self.photoArray[indexPath.item];
    } else {
        cell.photo = [UIImage imageNamed:@"photo_upload_add"];
    }
    [cell loadContent];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == _photoArray.count) {
        
        ZEROImagePickerController *pickerVC = [[ZEROImagePickerController alloc] initWithMaxImagesCount:maxPhotoNum columnNumber:4 delegate:nil isPushPhoto:YES];
        pickerVC.selectedAssets = self.assetArray;
        
        [pickerVC setDidFinishPickingPhotosWithInfosHandle:^(NSArray <UIImage *>*photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray <NSDictionary *>*infos) {
            
        }];
        [pickerVC setDidFinishPickingPhotosHandle:^(NSArray <UIImage *>*photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.photoArray = [NSMutableArray arrayWithArray:photos];
            self.assetArray = [NSMutableArray arrayWithArray:assets];
            [self->_collectionView reloadData];
        }];
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
}
@end
