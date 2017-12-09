//
//  PhotoChooseViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "PhotoChooseViewController.h"
#import "PhotoChooseView.h"

@interface PhotoChooseViewController ()

@end

@implementation PhotoChooseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configerPhotoChooseView];
}

#pragma mark - create method

- (void)configerPhotoChooseView{
    
    PhotoChooseView *photoChoose = [[PhotoChooseView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, WIDTH)];
   
    [photoChoose setPhotos:@[@"https://b-ssl.duitang.com/uploads/item/201612/24/20161224173209_HxFGX.thumb.700_0.jpeg",
                             @"http://img.dongqiudi.com/uploads/avatar/2015/07/25/QM387nh7As_thumb_1437790672318.jpg",
                             @"https://b-ssl.duitang.com/uploads/item/201510/13/20151013205037_H3BnY.jpeg",
                             @"https://b-ssl.duitang.com/uploads/item/201605/29/20160529091027_N4M2s.jpeg"]];
    [self.view addSubview:photoChoose];
}
@end
