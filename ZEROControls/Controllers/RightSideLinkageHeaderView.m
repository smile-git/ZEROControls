//
//  RightSideLinkageHeaderView.m
//  TwoLevelLinkage
//
//  Created by ZWX on 19/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "RightSideLinkageHeaderView.h"
#import "CategoryModel.h"

@interface RightSideLinkageHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation RightSideLinkageHeaderView


- (void)buildSubview {
    
    [super buildSubview];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 25)];
    
    _titleLabel.font      = [UIFont systemFontOfSize:11];
    _titleLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.85f];
    
    [self.contentView addSubview:_titleLabel];
}

- (void)loadContent {
    
    [super loadContent];
    
    CategoryModel *categoryModel = self.data;
    _titleLabel.text = categoryModel.name;
}

+ (CGFloat)headerFooterViewHeightWithData:(id)data {
    
    return 25.f;
}
@end
