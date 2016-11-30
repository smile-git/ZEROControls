//
//  ZEROListCell.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROListCell.h"
#import "UIFont+Fonts.h"
#import "ZEROListModel.h"
#import "POPBasicAnimation.h"
#import "POPSpringAnimation.h"

@interface ZEROListCell()

@property (nonatomic, strong) UILabel  *titlelabel;
@property (nonatomic, strong) UILabel  *subTitleLabel;

@end

@implementation ZEROListCell

- (void)setupCell{
    
    self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)buildSubview{
    
    self.titlelabel      = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, WIDTH - 40, 25)];
    [self addSubview:self.titlelabel];
    
    self.subTitleLabel           = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, WIDTH - 40, 10)];
    self.subTitleLabel.font      = [UIFont AvenirLightWithFontSize:8.f];
    self.subTitleLabel.textColor = [UIColor grayColor];
    [self addSubview:self.subTitleLabel];
}

- (void)loadContent{
    
    if (self.dataItem.data) {
        
        ZEROListModel *model           = self.dataItem.data;
        self.titlelabel.attributedText = model.attributeName;
        self.subTitleLabel.text        = model.controller;
    }
    
    if (self.indexPath.row % 2) {
        
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.05f];
        
    } else {
        
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    if (self.highlighted) {
        
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration           = 0.1f;
        scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self.titlelabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
    } else {
        
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness    = 20.f;
        [self.titlelabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}


@end
