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
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CircleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUserListData];
    [self createCollectionView];
}

- (void)loadUserListData {
    
    NSArray *userListPics = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HeadIcon" ofType:@"plist"]];
    self.dataSource = [NSMutableArray arrayWithArray:userListPics];
}

#pragma mark - create method

- (void)createCollectionView{
    
    CGFloat radius          = 380.0 / 667.0 * HEIGHT;
    CGFloat angularSpacing  = 12.0 / 667.0 * HEIGHT;
    CGFloat xOffset         = 155.0 / 375.0 * WIDTH;
    CGFloat cell_width      = 220.0 / 375.0 * WIDTH;
    CGFloat cell_height     = 75.0 / 667.0 * HEIGHT;
    
    CircleLayout *layout = [[CircleLayout alloc] initWithRadius:radius angularSpacing:angularSpacing cellSize:CGSizeMake(cell_width, cell_height) xOffset:xOffset];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, HEIGHT - NavHeight) collectionViewLayout:layout];
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
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleCell" forIndexPath:indexPath];
    
    cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    [cell loadContent];
    
    return cell;
}
@end
