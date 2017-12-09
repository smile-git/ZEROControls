//
//  WWaterFallViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/19.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "WWaterFallViewController.h"
#import "WWaterFallCell.h"
#import "WWaterFallLayout.h"
#import "FileManager.h"
#import "DuiTangPicModel.h"


@interface WWaterFallViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WWaterFallLayoutDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic)         CGFloat            rowHeight;
@property (nonatomic, strong) NSMutableArray    *datas;
@property (nonatomic, strong) NSMutableArray    <DuiTangPicModel *> *dataSource;


@end

@implementation WWaterFallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray new];
    
    // 初始化布局文件
    CGFloat gap                = 1;
    NSInteger rowCount         = 3;
    _rowHeight                 = (HEIGHT - NavHeight - (rowCount + 1) * gap) / (CGFloat)rowCount;
    WWaterFallLayout *layout   = [WWaterFallLayout new];
    layout.wManager.edgeInsets = UIEdgeInsetsMake(gap, gap, gap, gap);
    layout.wManager.gap        = gap;
    layout.delegate            = self;
    
    NSMutableArray *rowHeights = [NSMutableArray array];
    for (int i = 0; i < rowCount; i++) {
        
        [rowHeights addObject:@(_rowHeight)];
    }
    layout.wManager.itemHeights = rowHeights;
    
    self.collectionView                                = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, HEIGHT - NavHeight)
                                                                            collectionViewLayout:layout];
    self.collectionView.delegate                       = self;
    self.collectionView.dataSource                     = self;
    self.collectionView.backgroundColor                = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alpha                          = 1;
    [self.collectionView registerClass:[WWaterFallCell class] forCellWithReuseIdentifier:@"WWaterFallCell"];
    [self.view addSubview:self.collectionView];
    
    [self reloadData];

    if (@available(iOS 11.0, *)){
        
        if (iPhoneX) {
            
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}

- (void)reloadData{
    
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
    
    WWaterFallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WWaterFallCell" forIndexPath:indexPath];
    cell.indexPath      = indexPath;
    cell.data           = pictureModel;
    cell.rowHeight      = _rowHeight;
    [cell loadContent];
    
    return cell;
}

- (CGFloat)itemWidthWithIndexPath:(NSIndexPath *)indexPath {
    
    DuiTangPicModel *pictureModel = _dataSource[indexPath.row];
    return  [self resetFromSize:CGSizeMake(pictureModel.width.floatValue, pictureModel.height.floatValue) withFixedHeight:_rowHeight].width;
}

- (CGSize)resetFromSize:(CGSize)size withFixedHeight:(CGFloat)height {
    
    float  newWidth = size.width * (height / size.height);
    CGSize newSize  = CGSizeMake(newWidth, height);
    
    return newSize;
}


@end
