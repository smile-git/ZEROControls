//
//  ZEROBezierCell.m
//  ZEROBezierTableView
//
//  Created by ZWX on 2016/11/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROBezierCell.h"
#import "UIImageView+WebCache.h"

@implementation ZEROBezierCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.headIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.headIcon.layer.masksToBounds = YES;
}

- (void)loadContent {
    
    self.headIcon.layer.cornerRadius = (self.cellHeight - 20) / 2.f;
    __weak ZEROBezierCell *wself  = self;

    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[self.dataDic objectForKey:@"img"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        wself.headIcon.image = image;
    }];
    
    self.nickLabel.text = [self.dataDic objectForKey:@"title"];
    NSDictionary *contentDic = [self.dataDic objectForKey:@"content"];
    
    switch ([[contentDic objectForKey:@"type"] integerValue]) {
        case 0:
            self.contentLabel.text = [contentDic objectForKey:@"content"];
            break;
        case 1:
            self.contentLabel.text = @"[语音聊天]";
            break;
        case 2:
            self.contentLabel.text = @"[图片]";
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (UIColor *)randomColor
{
    CGFloat randomRed   = drand48();
    CGFloat randomGreen = drand48();
    CGFloat randomBlue  = drand48();
    
    return [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
}


@end
