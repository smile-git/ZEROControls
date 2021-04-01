//
//  ScratchImageViewController.m
//  ZEROControls
//
//  Created by ZWX on 2021/4/1.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import "ScratchImageViewController.h"
#import "MDScratchImageView.h"
#import "UIImage+ImageEffects.h"

@interface ScratchImageViewController ()

@end

@implementation ScratchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"scrollImage-1"];
    UIView *imageContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGFloat scale = MAX(HEIGHT / image.size.height, WIDTH / image.size.width);
    imageContentView.transform = CGAffineTransformMakeScale(scale, scale);
    imageContentView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.f, CGRectGetHeight(self.view.bounds) / 2.f);
    [self.view addSubview:imageContentView];
    
    UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:imageContentView.bounds];
    blurImageView.image = image;
    [imageContentView addSubview:blurImageView];
    
    MDScratchImageView *scratchImageView = [[MDScratchImageView alloc] initWithFrame:imageContentView.bounds];
    [scratchImageView setImage:[[UIImage imageNamed:@"scrollImage-4"] blurImage] radius:40.f];
    [imageContentView addSubview:scratchImageView];
}


@end
