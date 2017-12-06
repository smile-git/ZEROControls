//
//  TreeStructureCell.m
//  ZEROControls
//
//  Created by ZWX on 2017/8/28.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "TreeStructureCell.h"
#import "TreeStructureModel.h"
#import "UIFont+Fonts.h"
#import "IconEdgeInsetsLabel.h"

@interface TreeStructureCell ()

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *expendedColor;
@property (nonatomic, strong) UIColor *finalColor;

@property (nonatomic, strong) UIView *leftSideView;
@property (nonatomic, strong) IconEdgeInsetsLabel *titleLabel;

@end

@implementation TreeStructureCell

- (void)setupCell {
    
    [super setupCell];
    
    self.normalColor   = [[UIColor redColor] colorWithAlphaComponent:0.95f];
    self.expendedColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    self.finalColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
}

- (void)buildSubview {
    
    self.leftSideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 16.f)];
    self.leftSideView.backgroundColor = [UIColor blackColor];
    
    self.titleLabel = [[IconEdgeInsetsLabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font      = [UIFont HYQiHeiWithFontSize:18.f];
    self.titleLabel.direction = kIconAtLeft;
    self.titleLabel.gap       = 5.f;
    self.titleLabel.iconView  = self.leftSideView;
    
    [self.contentView addSubview:self.titleLabel];
}

- (void)loadContent {
    
    TreeStructureModel *model = self.data;
    
    [self.titleLabel sizeToFitWithText:model.text];
    self.titleLabel.centerY = 25.f;
    self.titleLabel.left    = 15.f + model.level * 35.f;
    
    if (model.subModelsCount) {
        
        self.titleLabel.textColor         = [UIColor darkGrayColor];
        self.leftSideView.backgroundColor = model.extend ? self.normalColor : self.expendedColor;
        self.contentView.backgroundColor  = model.extend ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.15] : [UIColor whiteColor];
    
    } else {
        
        self.titleLabel.textColor         = [UIColor lightGrayColor];
        self.leftSideView.backgroundColor = self.finalColor;
        self.contentView.backgroundColor  = [UIColor whiteColor];
    }
}

- (void)selectedEvent {
    
    TreeStructureModel *model = self.data;
    
    if (model.subModelsCount) {
        
        self.titleLabel.textColor = [UIColor darkTextColor];
        
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            self.leftSideView.backgroundColor = model.extend ? self.expendedColor : self.normalColor;
            self.contentView.backgroundColor = model.extend ? [UIColor whiteColor] : [[UIColor lightGrayColor] colorWithAlphaComponent:0.15];
            
        } completion:nil];
        
    } else {
        
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.leftSideView.backgroundColor = self.finalColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
