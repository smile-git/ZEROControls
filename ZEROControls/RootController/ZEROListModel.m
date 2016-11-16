//
//  ZEROListItem.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROListModel.h"
#import "UIFont+Fonts.h"

@interface ZEROListModel()

@property (nonatomic, strong) NSMutableAttributedString *attributeName;

@end

@implementation ZEROListModel

+ (instancetype)initWithName:(NSString *)name controller:(NSString *)controller{
    
    ZEROListModel *model  = [[[self class] alloc] init];
    model.name       = name;
    model.controller = controller;
    
    return model;

}

- (void)createAttributedName{
    
    NSString *fullStirng = [NSString stringWithFormat:@"%02ld. %@", (long)self.index, self.name];
    
    NSMutableAttributedString *richString = [[NSMutableAttributedString alloc] initWithString:fullStirng];
    
//    {
//        FontAttribute *fontAttribute = [FontAttribute new];
//        fontAttribute.font           = [UIFont HeitiSCWithFontSize:16.f];
//        fontAttribute.effectRange    = NSMakeRange(0, richString.length);
//        [richString addStringAttribute:fontAttribute];
//    }
//    
//    {
//        FontAttribute *fontAttribute = [FontAttribute new];
//        fontAttribute.font           = [UIFont fontWithName:@"GillSans-Italic" size:16.f];
//        fontAttribute.effectRange    = NSMakeRange(0, 3);
//        [richString addStringAttribute:fontAttribute];
//    }
//    
//    {
//        ForegroundColorAttribute *foregroundColorAttribute = [ForegroundColorAttribute new];
//        foregroundColorAttribute.color                     = [[UIColor blackColor] colorWithAlphaComponent:0.65f];
//        foregroundColorAttribute.effectRange               = NSMakeRange(0, richString.length);
//        [richString addStringAttribute:foregroundColorAttribute];
//    }
//    
//    {
//        ForegroundColorAttribute *foregroundColorAttribute = [ForegroundColorAttribute new];
//        foregroundColorAttribute.color                     = [[UIColor redColor] colorWithAlphaComponent:0.65f];
//        foregroundColorAttribute.effectRange               = NSMakeRange(0, 3);
//        [richString addStringAttribute:foregroundColorAttribute];
//    }
    
    self.attributeName = richString;

}

@end
