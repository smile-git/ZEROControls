//
//  SlidingDoorViewController.m
//  ZEROControls
//
//  Created by ZWX on 2017/6/27.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "SlidingDoorViewController.h"
#import "SlidingDoorLayout.h"
#import "SlidingDoorCell.h"
@interface SlidingDoorViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *resourceItems;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SlidingDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self loadResourceData];
    
    [self configSubviews];
    
    [self buildSettings];
}

- (void)loadResourceData {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"gallery" ofType:@"json"];
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:jsonPath];
    self.resourceItems = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
}

- (void)configSubviews {
    
    SlidingDoorLayout *layout = [[SlidingDoorLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate        = self;
    _collectionView.dataSource      = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SlidingDoor1Cell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SlidingDoor1Cell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"SlidingDoor2Cell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SlidingDoor2Cell"];
    
    [self.view addSubview:_collectionView];
    
    [self performSelector:@selector(quickFix) withObject:nil afterDelay:0.01];
    
}

- (void)buildSettings {
    
    UISegmentedControl *typeSwitch = [[UISegmentedControl alloc] initWithItems:@[@"one", @"two"]];
    [typeSwitch setTintColor:UIColorRGBA(220, 220, 220, 1)];
    [typeSwitch setSelectedSegmentIndex:0];
    [typeSwitch addTarget:self action:@selector(typeSwitchClick:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:typeSwitch];
}

- (void)quickFix {
    
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + 1)];
}

#pragma mark - ---- Delegate & DataSource Method ----
#pragma mark UICollectionView delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *itemDict = [self.resourceItems objectAtIndex:indexPath.item];
    
    SlidingDoorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SlidingDoor1Cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [[itemDict valueForKey:@"title"] uppercaseString];
    cell.imageView.image = [UIImage imageNamed:[itemDict valueForKey:@"image"]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.resourceItems.count;
}

#pragma mark - ---- Event Method ----
- (void)typeSwitchClick: (UISegmentedControl *)sender {
    
    NSInteger typeIndex = sender.selectedSegmentIndex;
    
    SlidingDoorLayout *layout = (SlidingDoorLayout *)_collectionView.collectionViewLayout;
    layout.type = typeIndex;
    
//    [_collectionView.collectionViewLayout invalidateLayout];
    [_collectionView reloadData];
    
    [self performSelector:@selector(quickFix) withObject:nil afterDelay:0.01];

}

@end
