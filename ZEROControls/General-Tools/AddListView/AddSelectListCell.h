//
//  SelectListCell.h
//  SelectList
//
//  Created by ZWX on 16/6/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddSelectListItem;

@interface AddSelectListCell : UITableViewCell

@property (nonatomic, strong)UIImageView *listIcon;
@property (nonatomic, strong)UILabel     *listTitle;

- (void)configListWith:(AddSelectListItem *)item;
@end
