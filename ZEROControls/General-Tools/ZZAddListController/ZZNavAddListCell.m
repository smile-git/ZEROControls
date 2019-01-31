//
//  ZZAddListCell.m
//  NavAddList
//
//  Created by ZWX on 27/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "ZZNavAddListCell.h"

@interface ZZNavAddListCell ()

@property (nonatomic, strong) UIImageView *addListIcon;
@property (nonatomic, strong) UILabel *addListTitle;

@end

@implementation ZZNavAddListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self setupCell];
        [self buildSubView];
    }
    return self;
}

- (void)setupCell {
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)buildSubView {
    
    _addListIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.contentView addSubview:_addListIcon];
    
    _addListTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    _addListTitle.textAlignment = NSTextAlignmentCenter;
    _addListTitle.textColor     = [UIColor whiteColor];
    _addListTitle.font          = [UIFont fontWithName:@"Avenir-Light" size:15.f];
    [self.contentView addSubview:_addListTitle];
}

- (void)loadContent{
    
    [self loadContentWithItem:self.listItem];
}

- (void)loadContentWithItem:(ZZNavAddListItem *)listItem {
    
    _addListIcon.image = listItem.iconString == nil ? nil : [UIImage imageNamed:listItem.iconString];
    _addListTitle.text = listItem.titleString;
    
    _addListTitle.hidden = listItem.titleString == nil ? YES : NO;
    _addListIcon.hidden  = listItem.iconString == nil ? YES : NO;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _addListIcon.frame = CGRectMake(15, 10, 20, 20);
    _addListTitle.frame = CGRectMake(45, 0, 80, self.frame.size.height);
    
    if (_addListTitle.hidden) {
        
        _addListIcon.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    }
    
    if (_addListIcon.hidden) {
        _addListTitle.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
