//
//  TwoLevelLinkageView.h
//  TwoLevelLinkage
//
//  Created by ZWX on 2018/1/11.
//  Copyright © 2018年 ZWX. All rights reserved.
//


/**
 级联菜单
 要使用TwoLevelLinkageView, 就要自定义左右两个cell，继承自TwoLevelLinkageCell，
 */

#import <UIKit/UIKit.h>
#import "LeftLevelLinkageModel.h"
@class TwoLevelLinkageView;

@protocol TwoLevelLinkageViewDelegate<NSObject>

- (void)twoLevelLinkageView:(TwoLevelLinkageView *)linkageView selectedLeftSideTableViewItemRow:(NSInteger)row item:(id)data;
- (void)twoLevelLinkageView:(TwoLevelLinkageView *)linkageView selectedRightSideTableViewItemIndexPath:(NSIndexPath *)indexPath item:(id)data;

@end

/**
 注册cell和header的block

 @param leftSideTableView 左侧tableView
 @param rightSideTableView 右侧tableView
 */
typedef void(^RegistCellWithTableViewBlock)(UITableView *leftSideTableView, UITableView *rightSideTableView);


@interface TwoLevelLinkageView : UIView

@property (nonatomic, weak) id<TwoLevelLinkageViewDelegate> delegate;

@property (nonatomic, strong) NSArray <LeftLevelLinkageModel *>*leftModels;

/**
 init method

 @param frame frame
 @param leftSideWidth leftTableView's width
 @return TwoLevelLinkageView
 */
- (instancetype)initWithFrame:(CGRect)frame leftSideWidth:(CGFloat)leftSideWidth;


/**
 注册两个级联TableView的cell和HdaderView

 @param leftSideTableViewBlock leftSideTableViewBlock description
 @param rightSideTableViewBlock rightSideTableViewBlock description
 */
- (void)registCellWithLeftTableView:(void (^)(UITableView *leftSideTableView))leftSideTableViewBlock cellAndHeaderWithRightTableView:(void (^)(UITableView *rightSideTableView))rightSideTableViewBlock;

/**
 注册两个级联TableView的cell和HdaderView

 @param tableViewBlock TableViewBlock description
 */
- (void)registCellWithTableViews:(RegistCellWithTableViewBlock)tableViewBlock;

/**
 刷新数据
 */
- (void)reloadData;

/**
 初始化左侧tableView选中第几行

 @param row row
 */
- (void)leftTableViewCellMakeSelectedAtRow:(NSInteger)row;

@end
