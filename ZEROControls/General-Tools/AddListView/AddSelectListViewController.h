//
//  AddSelectListViewController.h
//  AddSelectList
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddSelectListView;


@interface AddSelectListViewController : UIViewController

@property (nonatomic, weak) AddSelectListView *addListView;

@property (nonatomic, weak) UIViewController *showListVC;

@property (nonatomic)       BOOL animate;
- (void)showListView;

- (void)dismissListView;

@end
