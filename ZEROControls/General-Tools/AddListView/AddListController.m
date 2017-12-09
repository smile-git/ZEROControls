//
//  AddListController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/18.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddListController.h"
#import "AddSelectListItem.h"
#import "AddListView.h"
#import "AddSelectListCell.h"

static const CGFloat AddListViewRightMargin = 10.0;
static const CGFloat AddListViewTopMargin   = 10.0;
static const CGFloat AddListViewItemWidth   = 130.0;
static const CGFloat AddListViewItemHeight  = 40.0;

@interface AddListController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AddListView *listView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AddListController

+ (instancetype)addListControllerWithItems:(NSArray<AddSelectListItem *> *)items{
    
    AddListController *listController = [[AddListController class] new];
    listController.items = items;
    return listController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createListView];
    
    [self addGesture];
}

- (void)setItems:(NSArray *)items{
    
    //根据item数量更新frame，刷新tableView
    if (_items != items) {
        
        _items = items;
        
        _listView.frame  = CGRectMake(WIDTH - AddListViewItemWidth - AddListViewRightMargin, NavHeight + 5, AddListViewItemWidth, AddListViewItemHeight * (items.count > 6 ? 6 : items.count) + AddListViewTopMargin);
        _tableView.frame = CGRectMake(0, AddListViewTopMargin, _listView.width, _listView.height - AddListViewTopMargin);
        
        [_tableView reloadData];
    }
}


#pragma mark - create method

- (void)createListView{
    
    self.listView = [[AddListView alloc] initWithFrame:CGRectMake(WIDTH - AddListViewItemWidth - AddListViewRightMargin, NavHeight + 5, AddListViewItemWidth, AddListViewItemHeight * (_items.count > 6 ? 6 : _items.count) + AddListViewTopMargin)];
    _listView.hidden = YES;

    [self.view addSubview:_listView];
    
    [self createTableView];
}

- (void)createTableView{
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, AddListViewTopMargin, _listView.width, _listView.height - AddListViewTopMargin) style:UITableViewStylePlain];
    
    _tableView.delegate             = self;
    _tableView.dataSource           = self;
    _tableView.bounces              = NO;
    _tableView.rowHeight            = AddListViewItemHeight;
    _tableView.backgroundColor      = [UIColor clearColor];
    _tableView.layer.cornerRadius   = 3;
    _tableView.layer.masksToBounds  = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[AddSelectListCell class] forCellReuseIdentifier:@"AddSelectListCell"];
    [_listView addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)addGesture{
    
    //TapGesture
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss)];
    dismissTap.delegate = self;
    [self.view addGestureRecognizer:dismissTap];

}

#pragma mark - show & dismiss

- (void)showInViewController:(UIViewController *)viewController completion:(void (^)(NSInteger))completion{
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    
    [viewController presentViewController:self animated:NO completion:^{
        
        [self setAnchorPoint:CGPointMake(0.9, 0) forView:_listView];
        _listView.hidden     = NO;
        _listView.transform  = CGAffineTransformMakeScale(0.2, 0.2);
        _listView.alpha      = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _listView.transform = CGAffineTransformMakeScale(1, 1);
            _listView.alpha     = 1;
        }];
    }];

    self.selectCompletion = completion;
}

- (void)dismissListView
{
    [self setAnchorPoint:CGPointMake(0.9, 0) forView:_listView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _listView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        _listView.alpha     = 0;
    } completion:^(BOOL finished) {
        
        _listView.transform = CGAffineTransformMakeScale(1, 1);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
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

#pragma mark - tableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSelectListCell"];
    AddSelectListItem *item = [_items objectAtIndex:indexPath.row];
    
    [cell configListWith:item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissListView];
    
    if (self.selectCompletion) {
        
        self.selectCompletion(indexPath.row);
    }
}


#pragma mark - response events
#pragma mark gesture

- (void)tapToDismiss{
    
    [self dismissListView];
}

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_listView]) {
        return NO;
    }
    return YES;
}
@end
