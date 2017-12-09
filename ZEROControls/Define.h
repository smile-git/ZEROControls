//
//  Define.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#ifndef Define_h
#define Define_h

// 屏幕长宽
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

// 标准的RGBA设置
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define  iPhoneX        (WIDTH == 375.f && HEIGHT == 812.f ? YES : NO)
#define NavHeight       (iPhoneX ? 88 : 64)

#endif /* Define_h */
