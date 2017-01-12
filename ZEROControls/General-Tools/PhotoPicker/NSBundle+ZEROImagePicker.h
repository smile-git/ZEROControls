//
//  NSBundle+ZEROImagePicker.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/27.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (ZEROImagePicker)

+ (NSString *)zero_loaclizedStringForKey:(NSString *)key;
+ (NSString *)zero_localizedStringForKey:(NSString *)key value:(NSString *)value;

+ (UIImage *)zero_imageFromPickerBundle:(NSString *)name;
@end
