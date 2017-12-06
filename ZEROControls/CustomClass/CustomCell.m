//
//  CustomCell.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupCell];
        [self buildSubview];
    }
    
    return self;
}

- (void)setupCell{
    
}

- (void)buildSubview{
    
}

- (void)loadContent{

}

- (void)selectedEvent {
    
    
}

+ (CGFloat)cellHeightWithData:(id)data{
    
    return 0.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
