//
//  MarqueeControl.m
//  MarqueeControl
//
//  Created by ZWX on 2019/1/11.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import "MarqueeControl.h"
#import "MarqueeCell.h"
#import "MarqueeModel.h"
#import "MarqueeLayoutH.h"
#import "MarqueeLayoutHManager.h"

// 滚动方向
typedef NS_ENUM(NSInteger, MarqueeControlScrollType) {
    
    MarqueeControlScrollTypeVertical,
    MarqueeControlScrollTypeHorizontal
};


@interface MarqueeControl()<UICollectionViewDelegate, UICollectionViewDataSource, MarqueeLayoutHDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *currentTimer;

@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@implementation MarqueeControl

#pragma mark - ---- Init Method ----

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.timeInterval = 0.02;
        
        [self buildSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    
    if (self = [super initWithFrame:frame]) {
        
        self.scrollDirection = scrollDirection;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.timeInterval = scrollDirection == UICollectionViewScrollDirectionVertical ? 3 : 0.02;
        
        [self buildSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)scrollDirection models:(NSArray *)models {
    
    if (self = [super initWithFrame:frame]) {
        
        self.scrollDirection = scrollDirection;
        //滑动or滚动时间间隔
        self.timeInterval = scrollDirection == UICollectionViewScrollDirectionVertical ? 3 : 0.05;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.models = [NSMutableArray arrayWithArray:models];
        [self.models addObjectsFromArray:models];
        
        [self buildSubviews];
    }
    return self;
}

#pragma mark - ---- Private Method ----
#pragma mark Subviews

- (void)buildSubviews {
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = self.scrollDirection;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = self.bounds.size;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    } else {
        
        MarqueeLayoutH *layout = [MarqueeLayoutH new];
        layout.delegate = self;
        layout.mManager.gap = 50;
        layout.mManager.edgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
        CGFloat rowHeight = self.bounds.size.height;
        NSInteger rowCount = 1;
        
        NSMutableArray *rowHeights = [NSMutableArray array];
        for (NSInteger index = 0; index < rowCount; index ++) {
            [rowHeights addObject:@(rowHeight)];
        }
        layout.mManager.itemHeights = rowHeights;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    }
    
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    // 禁用滑动手势
    _collectionView.scrollEnabled = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MarqueeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MarqueeCell"];
    [self addSubview:_collectionView];
}

#pragma mark configre
- (void)setupTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _currentTimer = timer;
}

- (void)invalidateTimer {
    
    [_currentTimer invalidate];
    _currentTimer = nil;
}

#pragma mark - ---- Public Method ----
- (void)startLoopAnimated:(BOOL)animated {
    
    [_collectionView reloadData];
    
    [self setupTimer];
}

#pragma mark - ---- Delegate Method ----
#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.models.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MarqueeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarqueeCell" forIndexPath:indexPath];
    
    // 横向滑动->1行显示；  纵向滚动->最多2行显示
    cell.contentLabel.numberOfLines = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? 1 : 2;
    
    cell.dataModel = self.models[indexPath.row];
    [cell loadContent];
    cell.contentLabel.textColor = _textColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MarqueeCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell willDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(MarqueeCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell didEndDisplaying];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@", indexPath);
    // delegate
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(MarqueeCell *obj, NSUInteger idx, BOOL *stop) {
            
            CGPoint point = [obj convertPoint:obj.bounds.origin toView:self];
            
            [obj contentOffset:point];
        }];
    }
    
    if (self.models.count == 0) { return; }
}

#pragma mark MarqueeLayoutHDelegate

- (CGFloat)itemWidthWithIndexPath:(NSIndexPath *)indexPath {
    
    MarqueeModel *model = self.models[indexPath.item];
    return [self calculateRowWidthWithString: model.contentStr];
}

- (CGFloat)calculateRowWidthWithString:(NSString *)string {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(10000, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return rect.size.width + 20.f;
}


#pragma mark - ---- Event Method ----
#pragma mark Timer
- (void)timerAction {
    
    if (self.models.count == 0) {  return; }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        
        NSIndexPath *currentIndexPath = [[_collectionView indexPathsForVisibleItems] lastObject];
        
        NSInteger newItem = (currentIndexPath.item + 1) % (self.models.count);
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newItem inSection:0];
        
        [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        
        if ((currentIndexPath.row + 1) / (self.models.count / 2) >= 1.0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            });
        }
        
    } else {
        
        NSIndexPath *currentIndexPath = [[_collectionView indexPathsForVisibleItems] lastObject];
        NSInteger currentItem = currentIndexPath.item;
        if ((currentItem) / (self.models.count / 2) >= 1.0) {
            
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        
        CGPoint currentPoint = [_collectionView contentOffset];
        CGPoint offsetPoint = CGPointMake(currentPoint.x + 1.5f, currentPoint.y);
        [_collectionView setContentOffset:offsetPoint animated:NO];
    }
}

@end
