//
//  SphereMenuNew.m
//  SphereMenu
//
//  Created by ZWX on 2016/12/14.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "SphereMenu.h"

//间隔
static const CGFloat   kAngleOffset     = M_PI_2 / 2;
static const CGFloat   kSphereLength    = 80;
static const float     kSphereDamping   = 0.3;
static const NSInteger kShpereButtonTag = 100;


@interface SphereMenu()

@property (nonatomic, weak)   UIView *showView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton  *menuButton;
@property (nonatomic, strong) NSMutableArray <UIButton *>*sphereItems;

@property (nonatomic, strong) NSMutableArray *spherePositions;

@property (nonatomic, strong) UIDynamicAnimator *dynamic;
@property (nonatomic, strong) NSMutableArray <UISnapBehavior *>*shrinkSnaps;
@property (nonatomic, strong) NSMutableArray <UISnapBehavior *>*expandSnaps;

@property (nonatomic, copy) SphereDidSelected handleCompletion;

@property (nonatomic, assign) BOOL isExpanded;
@end

@implementation SphereMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sphereItems     = [NSMutableArray array];
        self.spherePositions = [NSMutableArray array];
        self.shrinkSnaps     = [NSMutableArray array];
        self.expandSnaps     = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame menuImage:(NSString *)menuImageStr sphereImages:(NSArray<NSString *> *)sphereImages{
    
    if (self = [super initWithFrame:frame]) {
        
        self.sphereItems     = [NSMutableArray array];
        self.spherePositions = [NSMutableArray array];
        self.shrinkSnaps     = [NSMutableArray array];
        self.expandSnaps     = [NSMutableArray array];

        self.menuImageStr    = menuImageStr;
        self.sphereImages    = sphereImages;
    }
    return self;
}

#pragma mark - ---- set method ----
- (void)setMenuImageStr:(NSString *)menuImageStr{
    
    _menuImageStr = menuImageStr;
    
    if (!_menuButton) {
        
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_menuButton setImage:[UIImage imageNamed:menuImageStr] forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(menuButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_menuButton];
    }
}

- (void)setSphereImages:(NSArray<NSString *> *)sphereImages{
    
    _sphereImages = sphereImages;
    [_sphereImages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *sphereButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sphereButton.frame     = CGRectMake(0, 0, self.frame.size.width - 3, self.frame.size.width - 3);
        sphereButton.center    = self.center;
        sphereButton.tag       = idx + kShpereButtonTag;
        
        [sphereButton setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [sphereButton addTarget:self action:@selector(sphereItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sphereItems addObject:sphereButton];
        [_spherePositions addObject:NSStringFromCGPoint([self pointForSphereAtIndex:idx])];
        
        // ----- 缩回动画
        UISnapBehavior *shrinkSnap = [[UISnapBehavior alloc] initWithItem:sphereButton snapToPoint:self.center];
        shrinkSnap.damping = kSphereDamping;
        [_shrinkSnaps addObject:shrinkSnap];
        
        // ----- 弹出动画
        UISnapBehavior *expandSnap = [[UISnapBehavior alloc] initWithItem:sphereButton snapToPoint:[self pointForSphereAtIndex:idx]];
        expandSnap.damping = kSphereDamping;
        [_expandSnaps addObject:expandSnap];
    }];
}

- (CGPoint)pointForSphereAtIndex:(NSInteger)index{
    
    CGFloat firstAngle = - M_PI + index * kAngleOffset;
    CGPoint startPoint = self.center;
    CGFloat x = startPoint.x + cos(firstAngle) * kSphereLength;
    CGFloat y = startPoint.y + sin(firstAngle) * kSphereLength;
    CGPoint position = CGPointMake(x, y);
    return position;
    
}

#pragma mark - ---- get method ----
- (UIView *)bgView{
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _bgView.hidden          = YES;
        _bgView.frame           = CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height);
        
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recover)]];
    }

    return _bgView;
}

- (UIDynamicAnimator *)dynamic{
    
    if (!_dynamic) {
        
        _dynamic = [[UIDynamicAnimator alloc] initWithReferenceView:_showView];
    }
    return _dynamic;
}


#pragma mark - open method
- (void)showInView:(UIView *)showView completion:(SphereDidSelected)completion{
    
    self.showView         = showView;
    self.handleCompletion = completion;
    
    [self.showView addSubview:self.bgView];
    
    [_sphereItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull sphereButton, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.showView addSubview:sphereButton];
    }];
    
    [self.showView addSubview:self];
}

#pragma mark - ---- shrink & expand method ----

/**
 收缩
 */
- (void)shrinkSubmenu{
    
    [self.dynamic removeAllBehaviors];
    _bgView.hidden = YES;

    // ----- 再旋转回去
    [UIView animateWithDuration:kSphereDamping animations:^{
        _menuButton.transform = CGAffineTransformMakeRotation(1.5);
    }completion:^(BOOL finished) {
        _menuButton.transform = CGAffineTransformMakeRotation(0.0);
    }];
    
    [_shrinkSnaps enumerateObjectsUsingBlock:^(UISnapBehavior * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.dynamic addBehavior:obj];
    }];

    _isExpanded = NO;
}

/**
 弹出
 */
- (void)expandSubmenu{
    
    [self.dynamic removeAllBehaviors];
    _bgView.hidden = NO;
    // ----- 旋转
    [UIView animateWithDuration:kSphereDamping animations:^{
        _menuButton.transform = CGAffineTransformMakeRotation(0.75);
    }];
    
    [_expandSnaps enumerateObjectsUsingBlock:^(UISnapBehavior * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.dynamic addBehavior:obj];
    }];
    
    _isExpanded = YES;
}


#pragma mark - ---- event method ----
#pragma mark butotn click
- (void)menuButtonClick{
    
    if (_isExpanded) {
        
        [self shrinkSubmenu];
    }
    else{
        
        [self expandSubmenu];
    }
}

- (void)sphereItemClick:(UIButton *)sender{
    
    if (self.handleCompletion) {
        
        self.handleCompletion(sender.tag - kShpereButtonTag);
    }

    [self shrinkSubmenu];
}

#pragma mark gesture
/**
 * @brief click bgView， recover sphereItems点击背景view，收回弹出控件

 */
- (void)recover{
    
    [self shrinkSubmenu];
}
@end
