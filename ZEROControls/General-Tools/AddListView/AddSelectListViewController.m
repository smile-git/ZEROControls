//
//  AddSelectListViewController.m
//  AddSelectList
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddSelectListViewController.h"
#import "AddSelectListView.h"

@interface AddSelectListViewController ()<UIGestureRecognizerDelegate>

@end

@implementation AddSelectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animate = YES;
    [self createListView];
    
    //TapGesture
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    dismissTap.delegate = self;
    [self.view addGestureRecognizer:dismissTap];

}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)createListView{
    
    [self.view addSubview:self.addListView];
}

- (void)showListView{
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    
    [self.showListVC presentViewController:self animated:NO completion:^{
        
        [self setAnchorPoint:CGPointMake(0.9, 0) forView:_addListView];
        _addListView.hidden     = NO;
        _addListView.transform  = CGAffineTransformMakeScale(0.2, 0.2);
        _addListView.alpha      = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _addListView.transform = CGAffineTransformMakeScale(1, 1);
            _addListView.alpha     = 1;
        }];
    }];
}

- (void)dismissListView
{
    if (_animate) {
        //设置缩放的原点(必须配置)
        //这个point，应该是按照比例来的。0是最左边，1是最右边
        [self setAnchorPoint:CGPointMake(0.9, 0) forView:_addListView];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _addListView.transform = CGAffineTransformMakeScale(0.2, 0.2);
            _addListView.alpha     = 0;
        } completion:^(BOOL finished) {
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }else
        [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_addListView]) {
        return NO;
    }
    return YES;
}

- (void)dismiss
{
    [self dismissListView];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin       = view.frame.origin;
    view.layer.anchorPoint  = anchorPoint;
    CGPoint newOrigin       = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center  = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}


@end
