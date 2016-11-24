//
//  SiftTagViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "SiftTagViewController.h"
#import "UIImage+ImageEffects.h"
#import "SiftTagCell.h"
#import "SiftTagSectionHeaderView.h"
#import "SiftTagFlowLayout.h"

@interface SiftTagViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) SiftTagFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray    *siftData;
@property (nonatomic, strong) NSMutableArray    *chooseTags;

@end

@implementation SiftTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title       = @"筛选";
    self.siftData    = [NSMutableArray array];
    self.chooseTags  = [NSMutableArray array];
    
    [self createBlurBg];
    
    [self createCollectionView];
    
    [self loadSiftData];

}

#pragma mark - set UI & NAV &
#pragma mark -

#pragma mark UI
- (void)createCollectionView{
    
    self.layout = [[SiftTagFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) collectionViewLayout:_layout];
    _collectionView.delegate        = self;
    _collectionView.dataSource      = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[SiftTagCell class] forCellWithReuseIdentifier:@"SiftTagCell"];
    [_collectionView registerClass:[SiftTagSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SiftTagSectionHeaderView"];
    
    [self.view addSubview:_collectionView];
}

- (void)createBlurBg{
    
    self.view.backgroundColor = UIColorRGBA(100, 100, 110, 0.9);

    UIView *blurView          = [[UIView alloc] initWithFrame:self.view.frame];
    UIImage *img              = [UIImage imageNamed:@""];
    blurView.backgroundColor  = [UIColor colorWithPatternImage:[img blurImageWithRadius:10]];
    
    [self.view addSubview:blurView];
}

#pragma mark - loadData
- (void)loadSiftData{
    
    NSArray *data = @[@{@"title":@"项目分类",@"tags":@[@"模型项目", @"渲染项目"]},
                      @{@"title":@"角色选择",@"tags":@[@"模型师", @"渲染师"]},
                      @{@"title":@"等级选择",@"tags":@[@"A", @"B", @"C"]},
                      @{@"title":@"项目类型",@"tags":@[@"规划", @"景观", @"室内", @"建筑"]},
                      @{@"title":@"平台特色",@"tags":@[@"热门推荐", @"服务之星", @"技术大牛"]},
                      @{@"title":@"价格",@"tags":@[@"300-800", @"800-1200", @"1200-1600", @"1600-2000", @"2000-3000", @"3000-5000", @"5000-9000", @"9000以上"]},
                      @{@"title":@"周期",@"tags":@[@"1-3天", @"3-5天", @"5-7天", @"7-9天", @"9-11天", @"11-13天", @"13-15天", @"15天以上"]}];
    
    self.siftData            = [NSMutableArray arrayWithArray:data];
    _layout.siftManager.data = data;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _siftData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *tags = _siftData[section][@"tags"];
    return tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SiftTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SiftTagCell" forIndexPath:indexPath];
    
    NSArray *tags = _siftData[indexPath.section][@"tags"];
    cell.tagLabel.text = tags[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headerView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        SiftTagSectionHeaderView *siftHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SiftTagSectionHeaderView" forIndexPath:indexPath];
        siftHeaderView.titleLabel.text = _siftData[indexPath.section][@"title"];
        headerView = siftHeaderView;
    }
    return headerView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SiftTagCell *cell = (SiftTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.chooseTag = !cell.chooseTag;
    
    if (cell.chooseTag) {
        
        cell.tagLabel.textColor       = UIColorRGBA(100, 100, 110, 0.9);
        cell.tagLabel.backgroundColor = [UIColor whiteColor];
        [_chooseTags addObject:indexPath];
    }
    else{
        
        cell.tagLabel.textColor       = [UIColor whiteColor];
        cell.tagLabel.backgroundColor = [UIColor clearColor];
        [_chooseTags removeObject:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(SiftTagFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [collectionViewLayout.siftManager sizeWithIndexPath:indexPath];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(SiftTagFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return [collectionViewLayout.siftManager edgeInsetsWithSection:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SiftTagFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return [collectionViewLayout.siftManager minimumInteritemSpacingWithSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(SiftTagFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(200, 40);
}

@end
