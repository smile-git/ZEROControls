//
//  NSBundle+ZEROImagePicker.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/27.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "NSBundle+ZEROImagePicker.h"

@implementation NSBundle (ZEROImagePicker)

+ (instancetype)zero_imagePickerBundle {
    
    static NSBundle *zeroBundle = nil;
    if (!zeroBundle) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ZEROImagePicker" ofType:@"bundle"];
        if (!path) {
            path = [[NSBundle mainBundle] pathForResource:@"ZEROImagePicker" ofType:@"bundle" inDirectory:@"Frameworks/ZEROImagePicker.framework/"];
        }
        zeroBundle = [NSBundle bundleWithPath:path];
    }
    return zeroBundle;
}

+ (NSString *)zero_loaclizedStringForKey:(NSString *)key {
    
    return [self zero_localizedStringForKey:key value:@""];
}

+ (NSString *)zero_localizedStringForKey:(NSString *)key value:(NSString *)value {
    
    static NSBundle *bundle = nil;
    if (!bundle) {
        
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
            
            language = @"zh-Hans";
        } else {
            
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle zero_imagePickerBundle] pathForResource:language ofType:@"lproj"]];
    }
    NSString *localized = [bundle localizedStringForKey:key value:value table:nil];
    return localized;
}

+ (UIImage *)zero_imageFromPickerBundle:(NSString *)name {
    
    UIImage *image = [UIImage imageNamed:[@"ZEROImagePicker.bundle" stringByAppendingPathComponent:name]];
    
    if (!image) {
        image = [UIImage imageNamed:name];
    }
    
    return image;
}
@end
