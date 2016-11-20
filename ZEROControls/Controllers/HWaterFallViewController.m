//
//  HWaterFallViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/19.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "HWaterFallViewController.h"
#import "HWaterFallCell.h"
#import "HWaterFallLayout.h"
#import "ResponseData.h"
#import "WaterfallPictureModel.h"
#import "FileManager.h"

static NSString *picturesSource = @"http://www.duitang.com/album/1733789/masn/p/0/100/";

@interface HWaterFallViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, HWaterFallLayoutDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic)         CGFloat            columnWidth;
@property (nonatomic, strong) NSMutableArray    *datas;
@property (nonatomic, strong) ResponseData      *picturesData;
@property (nonatomic, strong) NSMutableArray    <WaterfallPictureModel *> *dataSource;

@end

@implementation HWaterFallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    
    [self createCollectionView];
    
    [self loadWaterFallData];
}

- (void)createCollectionView{
    
    // 初始化布局文件
    CGFloat gap                = 1;
    NSInteger columnCount      = 3;
    _columnWidth               = (self.view.width - (columnCount + 1) * gap) / (CGFloat)columnCount;
    HWaterFallLayout *layout   = [[HWaterFallLayout alloc] init];
    layout.delegate            = self;
    layout.hManager.gap        = gap;
    layout.hManager.edgeInsets = UIEdgeInsetsMake(gap, gap, gap, gap);
    
    NSMutableArray *columnWidths = [NSMutableArray arrayWithCapacity:0];
    for (int idx = 0; idx < columnCount; idx ++) {
        
        [columnWidths addObject:@(_columnWidth)];
    }
    layout.hManager.columnWidths = columnWidths;
    
    self.collectionView                                = [[UICollectionView alloc] initWithFrame:self.view.frame
                                                                            collectionViewLayout:layout];
    self.collectionView.delegate                       = self;
    self.collectionView.dataSource                     = self;
    self.collectionView.backgroundColor                = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alpha                          = 0;
    [self.collectionView registerClass:[HWaterFallCell class] forCellWithReuseIdentifier:@"HWaterFallCell"];
    [self.view addSubview:self.collectionView];

}

- (void)loadWaterFallData{
    
    // 获取数据
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *string       = @"waterFall";
        NSString *realFilePath = [FileManager theRealFilePath:[NSString stringWithFormat:@"~/Documents/%@", string]];
        NSData   *data         = nil;
        
        if (![FileManager fileExistWithRealFilePath:realFilePath]) {
            
            data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picturesSource]];
            [data writeToFile:realFilePath atomically:YES];
            
        }else{
            
            data = [NSData dataWithContentsOfFile:realFilePath];
        }
        if (data == nil) {
            return;
        }
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                                  error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picturesData = [[ResponseData alloc] initWithDictionary:dataDic];
            if (self.picturesData.success.integerValue == 1) {
                
                for (int i = 0; i < self.picturesData.data.blogs.count; i++) {
                    
                    [_dataSource addObject:self.picturesData.data.blogs[i]];
                }
                
                [_collectionView reloadData];
                [UIView animateWithDuration:0.5f animations:^{
                    
                    _collectionView.alpha = 1.f;
                }];
            }
        });
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WaterfallPictureModel *pictureModel = _dataSource[indexPath.row];
    
    HWaterFallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWaterFallCell" forIndexPath:indexPath];
    cell.indexPath      = indexPath;
    cell.data           = pictureModel;
    cell.columnWidth    = _columnWidth;
    [cell loadContent];
    
    return cell;
}

- (CGFloat)itemHeightWithIndexPath:(NSIndexPath *)indexPath {
    
    WaterfallPictureModel *pictureModel = _dataSource[indexPath.row];
    return  [self resetFromSize:CGSizeMake(pictureModel.iwd.floatValue, pictureModel.iht.floatValue) withFixedWidth:_columnWidth].height;
}

- (CGSize)resetFromSize:(CGSize)size withFixedWidth:(CGFloat)width {
    
    CGFloat newHeight = size.height * (width / size.width);
    CGSize  newSize   = CGSizeMake(width, newHeight);
    
    return newSize;
}

@end
