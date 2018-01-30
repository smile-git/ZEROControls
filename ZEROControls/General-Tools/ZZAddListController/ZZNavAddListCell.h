//
//  ZZAddListCell.h
//  NavAddList
//
//  Created by ZWX on 27/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZNavAddListItem.h"

@interface ZZNavAddListCell : UITableViewCell

@property (nonatomic, strong) ZZNavAddListItem *listItem;

- (void)loadContent;

- (void)loadContentWithItem:(ZZNavAddListItem *)listItem;
@end
