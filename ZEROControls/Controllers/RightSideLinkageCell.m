//
//  RightSideLinkageCell.m
//  TwoLevelLinkage
//
//  Created by ZWX on 18/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "RightSideLinkageCell.h"
#import "SubCategoryModel.h"
#import "UIImageView+WebCache.h"

@interface RightSideLinkageCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation RightSideLinkageCell

- (void)setupCell {
    
    [super setupCell];
}

- (void)buildSubview {
    
    [super buildSubview];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.iconImageView.center = CGPointMake(30, 30);
    self.iconImageView.layer.cornerRadius = 15;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.image = [UIImage imageNamed:@"logo-bg"];
    
    [self.contentView addSubview:_iconImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 150, 60)];
    self.titleLabel.font =  [UIFont fontWithName:@"Avenir-Light" size:18.f];
    [self.contentView addSubview:_titleLabel];
}

- (void)loadContent {
    
    [super loadContent];
    SubCategoryModel *subModel = self.data;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:subModel.icon_url]];
    _titleLabel.text = subModel.name;
}



+ (CGFloat)cellHeightWithData:(id)data {
    
    return 60.f;
}

@end
