//
//  DuiTangPicModel.h
//  ZEROControls
//
//  Created by ZWX on 2017/10/11.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuiTangPicModel : NSObject

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *width;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
