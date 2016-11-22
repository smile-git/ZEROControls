//
//  BezierCollectionViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "CircleCollectionViewController.h"
#import "CircleLayout.h"
#import "CircleCell.h"
@interface CircleCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation CircleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createCollectionView];
}

#pragma mark - create method
- (void)createCollectionView{
    
    CGFloat radius          = 350.0 / 667.0 * HEIGHT;
    CGFloat angularSpacing  = 12.0 / 667.0 * HEIGHT;
    CGFloat xOffset         = 155.0 / 375.0 * WIDTH;
    CGFloat cell_width      = 220.0 / 375.0 * WIDTH;
    CGFloat cell_height     = 60.0 / 667.0 * HEIGHT;
    
    CircleLayout *layout = [[CircleLayout alloc] initWithRadius:radius angularSpacing:angularSpacing cellSize:CGSizeMake(cell_width, cell_height) xOffset:xOffset];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate        = self;
    _collectionView.dataSource      = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CircleCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CircleCell"];
    
    [self.view addSubview:_collectionView];
    
}

#pragma mark - collectionview delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleCell" forIndexPath:indexPath];
    
    return cell;
}
@end
