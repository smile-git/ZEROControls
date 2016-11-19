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
#import "ResponseData.h"
#import "WaterfallPictureModel.h"

static NSString *picturesSource = @"http://www.duitang.com/album/1733789/masn/p/0/100/";

@interface WWaterFallViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WWaterFallLayoutDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic)         CGFloat            rowHeight;
@property (nonatomic, strong) NSMutableArray    *datas;
@property (nonatomic, strong) ResponseData      *picturesData;
@property (nonatomic, strong) NSMutableArray    <WaterfallPictureModel *> *dataSource;


@end

@implementation WWaterFallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray new];
    
    // 初始化布局文件
    CGFloat gap               = 1;
    NSInteger rowCount        = 3;
    _rowHeight                = (self.view.frame.size.height - 64 - (rowCount + 1) * gap) / (CGFloat)rowCount;
    WWaterFallLayout *layout        = [WWaterFallLayout new];
    layout.manager.edgeInsets = UIEdgeInsetsMake(gap, gap, gap, gap);
    layout.manager.gap        = gap;
    layout.delegate           = self;
    
    NSMutableArray *rowHeights = [NSMutableArray array];
    for (int i = 0; i < rowCount; i++) {
        
        [rowHeights addObject:@(_rowHeight)];
    }
    layout.manager.itemHeights = rowHeights;
    
    self.collectionView                                = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                                            collectionViewLayout:layout];
    self.collectionView.delegate                       = self;
    self.collectionView.dataSource                     = self;
    self.collectionView.backgroundColor                = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alpha                          = 0;
    [self.collectionView registerClass:[WWaterFallCell class] forCellWithReuseIdentifier:@"WWaterFallCell"];
    [self.view addSubview:self.collectionView];
    
    // 获取数据
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picturesSource]];
        //NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"7ddb96eb43d029942aa1b84243269073" ofType:nil]];
        if (data == nil) {
            return;
        }
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                                  error:nil];
        
        [self reloadData:dataDic];
    });
}

- (void)reloadData:(NSDictionary *)jsonDic{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.picturesData = [[ResponseData alloc] initWithDictionary:jsonDic];
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
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WaterfallPictureModel *pictureModel = _dataSource[indexPath.row];
    
    WWaterFallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WWaterFallCell" forIndexPath:indexPath];
    cell.indexPath      = indexPath;
    cell.data           = pictureModel;
    cell.rowHeight      = _rowHeight;
    [cell loadContent];
    
    return cell;
}

- (CGFloat)itemWidthWithIndexPath:(NSIndexPath *)indexPath {
    
    WaterfallPictureModel *pictureModel = _dataSource[indexPath.row];
    return  [self resetFromSize:CGSizeMake(pictureModel.iwd.floatValue, pictureModel.iht.floatValue) withFixedHeight:_rowHeight].width;
}

- (CGSize)resetFromSize:(CGSize)size withFixedHeight:(CGFloat)height {
    
    float  newWidth = size.width * (height / size.height);
    CGSize newSize  = CGSizeMake(newWidth, height);
    
    return newSize;
}


@end
