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
#import "DuiTangPicModel.h"
#import "FileManager.h"

static NSString *picturesSource = @"http://www.duitang.com/album/1733789/masn/p/0/100/";

@interface HWaterFallViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, HWaterFallLayoutDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic)         CGFloat            columnWidth;
@property (nonatomic, strong) NSMutableArray    *datas;
@property (nonatomic, strong) DuiTangPicModel   *picturesData;
@property (nonatomic, strong) NSMutableArray    <DuiTangPicModel *> *dataSource;

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
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, HEIGHT - NavHeight)
                                             collectionViewLayout:layout];
    
    self.collectionView.delegate                       = self;
    self.collectionView.dataSource                     = self;
    self.collectionView.backgroundColor                = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alpha                          = 1;
    [self.collectionView registerClass:[HWaterFallCell class] forCellWithReuseIdentifier:@"HWaterFallCell"];
    [self.view addSubview:self.collectionView];

}

- (void)loadWaterFallData {
    
    // 获取数据
    self.dataSource = [NSMutableArray array];
    NSData *duitangPicsData = [NSData dataWithContentsOfFile:[FileManager bundleFileWithName:@"duitang.json"]];
    NSArray *duitangPics = [NSJSONSerialization JSONObjectWithData:duitangPicsData
                                                           options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                             error:nil];
    
    [duitangPics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.dataSource addObject:[[DuiTangPicModel alloc] initWithDictionary:obj]];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DuiTangPicModel *pictureModel = _dataSource[indexPath.row];
    
    HWaterFallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWaterFallCell" forIndexPath:indexPath];
    cell.indexPath      = indexPath;
    cell.data           = pictureModel;
    cell.columnWidth    = _columnWidth;
    [cell loadContent];
    
    return cell;
}

- (CGFloat)itemHeightWithIndexPath:(NSIndexPath *)indexPath {
    
    DuiTangPicModel *pictureModel = _dataSource[indexPath.row];
    return  [self resetFromSize:CGSizeMake(pictureModel.width.floatValue, pictureModel.height.floatValue) withFixedWidth:_columnWidth].height;
}

- (CGSize)resetFromSize:(CGSize)size withFixedWidth:(CGFloat)width {
    
    CGFloat newHeight = size.height * (width / size.width);
    CGSize  newSize   = CGSizeMake(width, newHeight);
    
    return newSize;
}

@end
