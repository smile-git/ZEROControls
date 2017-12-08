//
//  VideoListModel.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/8.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListModel : NSObject

@property (nonatomic, strong) NSNumber *releaseTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSString *rawWebUrl;
@property (nonatomic, strong) NSString *webUrlForWeibo;
@property (nonatomic, strong) NSString *coverForFeed;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSNumber *videoId;
@property (nonatomic, strong) NSString *coverForDetail;
@property (nonatomic, strong) NSNumber *date;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) NSString *coverBlurred;
@property (nonatomic, strong) NSMutableArray *playInfo;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
