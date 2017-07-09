//
//  ShowTweakViewController.m
//  ZEROControls
//
//  Created by ZWX on 2017/6/28.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "ShowTweakViewController.h"
#import "PhotoTweaksViewController.h"

@interface ShowTweakViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, PhotoTweaksViewControllerDelegate>

@end

@implementation ShowTweakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImagePickerController *pickerContro = [[UIImagePickerController alloc] init];
    pickerContro.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerContro.delegate = self;
    pickerContro.allowsEditing = NO;
    pickerContro.navigationBarHidden = YES;
    
    [self presentViewController:pickerContro animated:NO completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoTweaksViewController *photoTweaksVC = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksVC.delegate = self;
    photoTweaksVC.autoSaveToLibray = YES;
    photoTweaksVC.maxRotationAngle = M_PI_4;
    [picker pushViewController:photoTweaksVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:NO completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller {
    
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage {
    
    [controller.navigationController popViewControllerAnimated:YES];
}


@end
