//
//  AlertListModel.h
//  ZEROControls
//
//  Created by ZWX on 2016/12/2.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertListModel : NSObject

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;

@end
