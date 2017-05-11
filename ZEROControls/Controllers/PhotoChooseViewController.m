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
    
    PhotoChooseView *photoChoose = [[PhotoChooseView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, WIDTH)];
   
    [photoChoose setPhotos:@[@"http://img3.duitang.com/uploads/item/201307/29/20130729153409_YCfU2.thumb.224_0.jpeg",
                             @"placeholder",
                             @"http://cdn.duitang.com/uploads/item/201212/29/20121229214354_NrWcc.thumb.224_0.jpeg",
                             @"http://img3.duitang.com/uploads/item/201301/01/20130101121241_LmTTf.thumb.224_0.jpeg"]];
    [self.view addSubview:photoChoose];
}
@end
