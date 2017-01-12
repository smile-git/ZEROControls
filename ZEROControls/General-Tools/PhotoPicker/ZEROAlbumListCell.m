//
//  ZEROAlbumListCell.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/27.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlbumListCell.h"
#import "NSBundle+ZEROImagePicker.h"
#import "ZEROAssetModel.h"
#import "ZEROPhotoManager.h"
#import "UIView+Ext.h"

@interface ZEROAlbumListCell()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *assetsNumLabel;

@end

@implementation ZEROAlbumListCell

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat cellHeight = _albumModel.cellHeight;
    self.posterImageView.frame     = CGRectMake(0, 0, cellHeight, cellHeight);
    self.titleLabel.frame          = CGRectMake(cellHeight + 10, 0, self.width - (cellHeight + 10) - 50, self.height);
    self.selectedCountButton.frame = CGRectMake(self.width - 24 - 30, (cellHeight - 24) / 2.0, 24, 24);
    self.selectedCountButton.layer.cornerRadius = _selectedCountButton.width / 2.0;

}

#pragma mark - ---- set method ----
- (void)setAlbumModel:(ZEROAlbumModel *)albumModel {
    
    _albumModel = albumModel;
    

    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:_albumModel.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",_albumModel.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLabel.attributedText = nameString;
    
    [[ZEROPhotoManager shareManager] getPostImageWithAlbumModel:_albumModel completion:^(UIImage *postImage) {
        
        self.posterImageView.image = postImage;
    }];
    
    if (albumModel.selectedCount) {
        
        self.selectedCountButton.hidden = NO;
        [self.selectedCountButton setTitle:[NSString stringWithFormat:@"%zi", albumModel.selectedCount] forState:UIControlStateNormal];
    } else {
        self.selectedCountButton.hidden = YES;
    }
}

#pragma mark - ---- Lazy method ----
- (UIImageView *)posterImageView {
    
    if (!_posterImageView) {
        
        _posterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _posterImageView.contentMode   = UIViewContentModeScaleAspectFill;
        _posterImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:_posterImageView];
    }
    return _posterImageView;
}

- (UIButton *)selectedCountButton {
    
    if (!_selectedCountButton) {
        
        _selectedCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedCountButton.frame              = CGRectZero;
        _selectedCountButton.clipsToBounds      = YES;
        _selectedCountButton.backgroundColor    = [UIColor redColor];
        _selectedCountButton.titleLabel.font    = [UIFont systemFontOfSize:15];
        [_selectedCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_selectedCountButton];
    }
    return _selectedCountButton;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor     = [UIColor colorWithWhite:0.1 alpha:1];
        _titleLabel.font          = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)assetsNumLabel {
    
    if (!_assetsNumLabel) {
        
        _assetsNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _assetsNumLabel.textColor     = [UIColor lightGrayColor];
        _assetsNumLabel.font          = [UIFont systemFontOfSize:17];
        _assetsNumLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_assetsNumLabel];
    }
    return _assetsNumLabel;
}
@end
