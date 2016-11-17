//
//  AddSelectListView.h
//  SelectList
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddSelectListItem, AddSelectListViewController;


typedef void(^AddSelectListClickBlock)(NSInteger selectIndex);

@interface AddSelectListView : UIView

- (instancetype)initWithFrame:(CGRect)frame showVC:(UIViewController *)showListVC items:(NSArray <AddSelectListItem *> *)items;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) CGFloat alphaComponent;           //默认0.25

@property (nonatomic, weak)   AddSelectListViewController *listVC;

@property (nonatomic, weak)   UIViewController *showListVC;

@property (nonatomic)         BOOL animate;

@property (nonatomic, copy)   AddSelectListClickBlock clickBlock;

- (void)showClick:(AddSelectListClickBlock)clickBlock;

- (void)dismiss;
@end
