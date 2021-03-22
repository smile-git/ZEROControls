//
//  OffsetImageCell.m
//  ZEROControls
//
//  Created by ZWX on 2017/12/8.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "OffsetImageCell.h"
#import "UIImageView+WebCache.h"
#import "OffsetCellModel.h"
#import "UIFont+Fonts.h"
#import "LineBackgroundView.h"

@interface OffsetImageCell ()

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel     *infoLabel;

@end

@implementation OffsetImageCell

- (void)setupCell {
    
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor blackColor];
}

- (void)buildSubview {
    
    self.clipsToBounds = YES;
    self.pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(HEIGHT / 1.7 - 250) / 2, WIDTH, HEIGHT / 1.7)];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.pictureView];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 250 - 30, WIDTH, 30)];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self.contentView addSubview:blackView];
    
    LineBackgroundView *lineBackgroundView = [LineBackgroundView createWithFrame:blackView.frame lineWidth:4 lineGap:4 lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.1f]];
    
    [self.contentView addSubview:lineBackgroundView];
    
    {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5f)];
        lineView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        lineView.bottom          = lineBackgroundView.top;
        [self.contentView addSubview:lineView];
        
    }
    
    {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5f)];
        lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        lineView.bottom          = lineBackgroundView.bottom;
        [self.contentView addSubview:lineView];
        
    }
    
    self.infoLabel = [[UILabel alloc] initWithFrame:lineBackgroundView.frame];
    self.infoLabel.width        -= 10;
    self.infoLabel.textColor     = [UIColor whiteColor];
    self.infoLabel.textAlignment = NSTextAlignmentRight;
    self.infoLabel.font          = [UIFont HeitiSCWithFontSize:13.f];
    [self.contentView addSubview:self.infoLabel];
}

- (void)loadContent {
    
    VideoListModel *model = self.data;
    self.infoLabel.text   = model.title;
    
    __weak OffsetImageCell *weakSelf = self;
    
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (cacheType == SDImageCacheTypeNone) {
            
            NSLog(@"[%ld][%ld] SDImageCacheTypeNone", (long)weakSelf.indexPath.section, (long)weakSelf.indexPath.row);
        
        } else if (cacheType == SDImageCacheTypeDisk) {
            
            NSLog(@"[%ld][%ld] SDImageCacheTypeDisk", (long)weakSelf.indexPath.section, (long)weakSelf.indexPath.row);

        } else if (cacheType == SDImageCacheTypeMemory) {
            
            NSLog(@"[%ld][%ld] SDImageCacheTypeMemory", (long)weakSelf.indexPath.section, (long)weakSelf.indexPath.row);

        } else {
            
            NSLog(@"[%ld][%ld] Unknow", (long)weakSelf.indexPath.section, (long)weakSelf.indexPath.row);
        }
        
        weakSelf.pictureView.alpha = 0;
        weakSelf.pictureView.image = image;
        
        [UIView animateWithDuration:0.35 animations:^{
        
            weakSelf.pictureView.alpha = 1.f;
        }];
    }];
}

- (void)cancelAnimation {
    
    [self.pictureView.layer removeAllAnimations];
}

- (CGFloat)cellOffset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    
    CGFloat cellOffsetY = centerY - windowCenter.y;
    
    CGFloat offsetDig = cellOffsetY / self.superview.frame.size.height * 2;
    CGFloat offset = -offsetDig * (HEIGHT / 1.7 - 250) / 2;
    
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0, offset);
    self.pictureView.transform = transY;
    
    return offset;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
