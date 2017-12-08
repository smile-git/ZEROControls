//
//  OffsetCellModel.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/7.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyListModel.h"

@interface OffsetCellModel : NSObject

@property (nonatomic, strong) NSString *nextPageUrl;
@property (nonatomic, strong) NSNumber *nextPublishTime;

@property (nonatomic, strong) NSMutableArray <DailyListModel *> *dailyList;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
