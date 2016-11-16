//
//  COBezierTableView.h
//  COBezierTableViewDemo
//
//  Created by ZWX on 2016/11/10.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
{
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    CGPoint p4;
}BezierPoints;



@interface ZEROBezierTableView : UITableView

@property (nonatomic) BezierPoints points;

@end
