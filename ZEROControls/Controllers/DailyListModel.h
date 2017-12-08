//
//  DailyListModel.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/7.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoListModel.h"

@interface DailyListModel : NSObject

@property (nonatomic, strong) NSNumber *date;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSMutableArray <VideoListModel *>*videoList;

#pragma Calculatoin Properties.
@property (nonatomic, strong) NSString *dateString;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
