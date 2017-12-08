//
//  OffsetCellHeaderView.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/7.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DailyListModel;

@interface OffsetCellHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)DailyListModel *model;

- (void)loadContent;

@end
