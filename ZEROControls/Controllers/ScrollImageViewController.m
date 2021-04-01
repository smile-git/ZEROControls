//
//  ScrollImageViewController.m
//  ZEROControls
//
//  Created by ZWX on 2021/3/23.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import "ScrollImageViewController.h"

#import "MoreInfoView.h"
#import "Math.h"
#import "UIView+Ext.h"

static int viewTag = 0x11;

@interface ScrollImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *picturesArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Math *onceLinearEquation;
@end

@implementation ScrollImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger type = arc4random()%4;
    MATHPoint pointA = MATHPointMake(0, -50);
    MATHPoint pointB;
    switch (type) {
        case 0:
            pointB = MATHPointMake(WIDTH, 270 - 80);
            break;
        case 1:
            pointB = MATHPointMake(WIDTH, 270 - 20);
            break;
        case 2:
            pointB = MATHPointMake(WIDTH, 270 + 20);
            break;
        case 3:
            pointB = MATHPointMake(WIDTH, 270 + 80);
            break;
        default:
            pointB = MATHPointMake(WIDTH, 270);
            break;
    }
    
    self.onceLinearEquation = [Math mathOnceLinearEquationWithPointA:pointA pointB:pointB];
    
    [self.view addSubview:self.scrollView];
    
    for (NSInteger i = 0; i < self.picturesArray.count; i++) {
        
        MoreInfoView *show = [[MoreInfoView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, self.scrollView.height)];
        show.imageView.image = self.picturesArray[i];
        show.tag = viewTag + i;
        
        [self.scrollView addSubview:show];
    }
    
    if (@available(iOS 11.0,*)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, HEIGHT - NavHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(self.picturesArray.count * WIDTH, HEIGHT - NavHeight);
    }
    return _scrollView;
}

- (NSArray *)picturesArray {
    if (!_picturesArray) {
        
        _picturesArray = @[[UIImage imageNamed:@"scrollImage-1"],
                           [UIImage imageNamed:@"scrollImage-2"],
                           [UIImage imageNamed:@"scrollImage-3"],
                           [UIImage imageNamed:@"scrollImage-4"],
                           [UIImage imageNamed:@"scrollImage-5"]];
    }
    return _picturesArray;
}

#pragma mark - ---- Delegate Method ----
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat X = scrollView.contentOffset.x;
//    NSLog(@"scrollView.contentSize.height=%f", scrollView.contentSize.height);
//    NSLog(@"scrollView.height=%f", scrollView.height);
    for (NSInteger i = 0; i < self.picturesArray.count; i++) {
        
        MoreInfoView *show = [scrollView viewWithTag:viewTag + i];
        show.imageView.left = self.onceLinearEquation.k * (X - i * self.view.bounds.size.width) + self.onceLinearEquation.b;
    }
}

@end
