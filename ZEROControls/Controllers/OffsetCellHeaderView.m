//
//  OffsetCellHeaderView.m
//  ZEROControls
//
//  Created by ZWX on 2017/12/7.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "OffsetCellHeaderView.h"
#import "UIFont+Fonts.h"
#import "DailyListModel.h"

@interface OffsetCellHeaderView ()

@property (nonatomic, strong) UILabel *theTitleLabel;

@end

@implementation OffsetCellHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupHeaderFooterView];
        [self buildSubview];
    }
    
    return self;
}

- (void)setupHeaderFooterView {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)buildSubview {
    
    self.theTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, WIDTH - 10, 25.f)];
    [self addSubview:self.theTitleLabel];
    
    self.theTitleLabel.font = [UIFont HeitiSCWithFontSize:14.f];
    self.theTitleLabel.textColor = [UIColor blackColor];
    
    CGFloat gap = 5;
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, gap, 2, 25 - gap * 2)];
    redView.backgroundColor = [UIColor redColor];
    
    [self addSubview:redView];
}

- (void)loadContent {
    
    self.theTitleLabel.text = self.model.dateString;
}

@end
