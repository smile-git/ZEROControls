//
//  ZZNavAddListController.m
//  NavAddList
//
//  Created by ZWX on 29/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "ZZNavAddListController.h"
#import "ZZNavAddListView.h"
#import "ZZNavAddListCell.h"

static const CGFloat   NavAddListViewRightMargin = 10.f;
static const CGFloat   NavAddListViewTopMargin   = 5.f;
static const CGFloat   NavAddListViewItemWidth   = 130.f;
static const CGFloat   NavAddListViewItemHeight  = 40.f;
static const CGFloat   NavAddTriangleHeight      = 5.f;         // ----- 三角形高度


@interface ZZNavAddListController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray <NSDictionary *>*listDictionarys;
@property (nonatomic, strong) NSArray <ZZNavAddListItem *>*listItems;

@property (nonatomic, copy)   SelectCompletion selectCompletion;
@property (nonatomic, assign) NSInteger maxListCount;

@property (nonatomic, strong) ZZNavAddListView *listView;
@end

@implementation ZZNavAddListController

#pragma mark - ---- Class Method ----
+ (instancetype)navAddListControllerWithDictionarys:(NSArray<NSDictionary *> *)listDictionarys selectCompletion:(SelectCompletion)selectCompletion {
    
    ZZNavAddListController *listController = [self navAddListControllerWithDictionarys:listDictionarys
                                                                          maxListCount:listDictionarys.count
                                                                      selectCompletion:selectCompletion];
    
    
    return listController;
}

+ (instancetype)navAddListControllerWithStrings:(NSArray<NSString *> *)listStrings selectCompletion:(SelectCompletion)selectCompletion {
    
    NSMutableArray *listDictionarys = [NSMutableArray arrayWithCapacity:0];
    [listStrings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [listDictionarys addObject:[NSDictionary dictionaryWithObject:obj forKey:@"title"]];
    }];
    
    ZZNavAddListController *listController = [self navAddListControllerWithDictionarys:listDictionarys
                                                                          maxListCount:listDictionarys.count
                                                                      selectCompletion:selectCompletion];
    
    return listController;
}

+ (instancetype)navAddListControllerSelectCompletion:(SelectCompletion)selectCompletion listStrings:(NSString *)listString, ... {
    
    NSMutableArray *listStrings     = [NSMutableArray array];
    NSMutableArray *listDictionarys = [NSMutableArray array];
    NSDictionary *curString;
    va_list list;
    if(listString){
        
        [listStrings addObject:listString];
        [listDictionarys addObject:[NSDictionary dictionaryWithObject:listString forKey:@"title"]];
        
        va_start(list, listString);
        while ((curString = va_arg(list, NSDictionary*))) {
            
            [listStrings addObject:curString];
            [listDictionarys addObject:[NSDictionary dictionaryWithObject:curString forKey:@"title"]];
        }
        va_end(list);
    }
    
    ZZNavAddListController *listController = [self navAddListControllerWithDictionarys:listDictionarys
                                                                          maxListCount:listDictionarys.count
                                                                      selectCompletion:selectCompletion];
    
    return listController;
}


+ (instancetype)navAddListControllerWithDictionarys:(NSArray<NSDictionary *> *)listDictionarys maxListCount:(NSInteger)maxListCount selectCompletion:(SelectCompletion)selectCompletion {
    
    ZZNavAddListController *listController = [self new];
    
    listController.listDictionarys  = listDictionarys;
    listController.selectCompletion = selectCompletion;
    listController.maxListCount     = listDictionarys.count > maxListCount ? maxListCount : listDictionarys.count;
    
    return listController;
}

#pragma mark - ---- Show & Dismiss Method ----

- (void)showInViewController:(UIViewController *)viewController {
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    
    [viewController presentViewController:self animated:NO completion:^{
        
        [self setAnchorPoint:CGPointMake(0.9, 0) forView:self.listView];
        self.listView.hidden    = NO;
        self.listView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.listView.alpha     = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.listView.transform = CGAffineTransformMakeScale(1, 1);
            self.listView.alpha     = 1;
        }];
    }];
}

- (void)dismissAddListController {
    
    [self setAnchorPoint:CGPointMake(0.9, 0) forView:_listView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.listView.transform = CGAffineTransformMakeScale(0.5, 0.2);
        self.listView.alpha     = 0;
    } completion:^(BOOL finished) {
        
        self.listView.transform = CGAffineTransformMakeScale(1, 1);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

// ----- 计算缩放点
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

#pragma mark - ---- Set & Get Method ----

- (void)setListDictionarys:(NSArray<NSDictionary *> *)listDictionarys {
    
    _listDictionarys = listDictionarys;
    NSMutableArray *listItemArr = [NSMutableArray arrayWithCapacity:0];
    [listDictionarys enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = [obj objectForKey:@"title"];
        NSString *icon  = [obj objectForKey:@"icon"];
        [listItemArr addObject:[ZZNavAddListItem listItemWithTitle:title iconString:icon]];
    }];
    
    self.listItems = listItemArr;
}

#pragma mark - ---- ViewController Method ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildSubviews];
    
    [self buildEvents];
}

- (void)buildSubviews {
    
    CGFloat tableViewTopMargin = NavAddListViewTopMargin + NavAddTriangleHeight;
    CGFloat tableViewHeight    = NavAddListViewItemHeight * _maxListCount;
    
    CGFloat originX      = WIDTH - NavAddListViewItemWidth - NavAddListViewRightMargin;
    CGFloat originY      = NavHeight + NavAddTriangleHeight;
    CGFloat sizeWidth    = NavAddListViewItemWidth;
    CGFloat sizeHeight   = tableViewTopMargin + tableViewHeight;
    CGRect listViewFrame = CGRectMake(originX, originY, sizeWidth, sizeHeight);
    
    self.listView = [[ZZNavAddListView alloc] initWithFrame:listViewFrame];
    _listView.hidden = YES;
    [self.view addSubview:_listView];
    
    CGRect tableViewFrame = CGRectMake(0, tableViewTopMargin, sizeWidth, tableViewHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame
                                                          style:UITableViewStylePlain];
    tableView.delegate   = self;
    tableView.dataSource = self;
    tableView.bounces    = NO;
    tableView.rowHeight  = NavAddListViewItemHeight;
    tableView.backgroundColor     = [UIColor clearColor];
    tableView.layer.cornerRadius  = 3;
    tableView.layer.masksToBounds = YES;
    tableView.showsVerticalScrollIndicator = NO;

    [tableView registerClass:[ZZNavAddListCell class] forCellReuseIdentifier:@"ZZNavAddListCell"];
    [_listView addSubview:tableView];
    
    // ----- 去掉cell左侧默认15像素的空白
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)buildEvents {
    
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss:)];
    dismissTap.delegate = self;
    
    [self.view addGestureRecognizer:dismissTap];
}

#pragma mark - ---- Deleagte Method ----
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZNavAddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZNavAddListCell"];
    
    cell.listItem = [_listItems objectAtIndex:indexPath.row];
    [cell loadContent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissAddListController];
    
    if (self.selectCompletion) {
        
        self.selectCompletion(indexPath.row);
    }
}

// ----- 去掉cell左侧默认15像素的空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // ----- 判断点击的view是否是listView或其subview
    if ([touch.view isDescendantOfView:_listView]) {
        
        return NO;
    }
    return YES;
}

#pragma mark - ---- Event Method ----
#pragma mark gesture
- (void)tapToDismiss:(UIGestureRecognizer *)sender {
    
    [self dismissAddListController];
}
@end
