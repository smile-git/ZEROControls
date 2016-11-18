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


#pragma mark - AddListView

#define AddListViewFillColor    UIColorRGBA(100, 100, 100, 1)
#define AddListViewItem_Height  40
#define AddListViewItem_Width   130

#endif /* Define_h */
