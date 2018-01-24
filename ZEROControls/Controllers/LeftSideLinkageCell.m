//
//  LeftSideLinkageCell.m
//  TwoLevelLinkage
//
//  Created by ZWX on 18/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "LeftSideLinkageCell.h"
#import "CategoryModel.h"
#import "UIImageView+WebCache.h"

@interface LeftSideLinkageCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *bgView;
@end


@implementation LeftSideLinkageCell

#pragma mark - ---- overwrite Method ----
#pragma mark from customCell
- (void)buildSubview {
    
    [super buildSubview];

    self.iconImageView   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _iconImageView.image = [UIImage imageNamed:@"logo-bg"];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.contentView addSubview:_bgView];
    
    self.titleLabel           = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.f, 100.f)];
    _titleLabel.font          = [UIFont fontWithName:@"Avenir-Light" size:13.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
}

- (void)loadContent {
    
    [super loadContent];
    
    CategoryModel *categoryModel = self.data;
    
    self.titleLabel.text = categoryModel.name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:categoryModel.icon_url] completed:nil];
    
    // ----- 更改选择状态
    [self selectState:self.levelModel.selected];
}

+ (CGFloat)cellHeightWithData:(id)data {
    
    return 100.f;
}

#pragma mark from TwoLevelLinkageCell

- (void)updateToSelectedStateAnimated:(BOOL)animated {

    [self animationSelectStation:YES animated:animated];
}

- (void)updateToNormalStateAnimated:(BOOL)animated {

    [self animationSelectStation:NO animated:animated];
}

- (void)updateSelectedState:(BOOL)state animate:(BOOL)animated {
    
    [self animationSelectStation:state animated:animated];
}

#pragma mark - Private method

- (void)animationSelectStation:(BOOL)selectState animated:(BOOL)animated {
    
    [self selectState:selectState];
}

- (void)selectState:(BOOL)state {
    
    if (state) {
        
        // ----- 选中状态
        self.titleLabel.alpha       = 0.f;
        self.iconImageView.alpha    = 1.0f;
        self.bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1f];

    } else {
        
        // ----- 普通，未选中状态
        self.titleLabel.alpha       = 1.0f;
        self.iconImageView.alpha    = 0.f;
        self.bgView.backgroundColor = [UIColor clearColor];
    }
}

@end
