//
//  SelectListCell.m
//  SelectList
//
//  Created by ZWX on 16/6/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddSelectListCell.h"
#import "AddSelectListItem.h"

@implementation AddSelectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createListViews];
    }
    return self;
}

- (void)createListViews
{
    self.listIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.contentView addSubview:_listIcon];
    
    self.listTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    _listTitle.textColor     = [UIColor whiteColor];
    _listTitle.font          = [UIFont systemFontOfSize:15];
    _listTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_listTitle];
}

- (void)configListWith:(AddSelectListItem *)item
{
    _listIcon.image = [UIImage imageNamed:item.icon];
    _listTitle.text = item.title;
    
    _listIcon.hidden  = item.icon  == nil ? YES : NO;
    _listTitle.hidden = item.title == nil ? YES : NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _listIcon.frame  = CGRectMake(15, 10, 20, 20);;
    _listTitle.frame = CGRectMake(45, 0, 80, self.frame.size.height);
    
    if (_listIcon.hidden) {
        
        _listTitle.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
    
    if (_listTitle.hidden) {
        
        _listIcon.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
}

@end
