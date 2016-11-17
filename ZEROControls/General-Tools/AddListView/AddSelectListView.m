//
//  AddSelectListView.m
//  SelectList
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddSelectListView.h"
#import "AddSelectListItem.h"
#import "AddSelectListCell.h"
#import "AddSelectListViewController.h"

#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

#define AddSelectListItem_Height 40
#define AddSelectListItem_Width  130

@interface AddSelectListView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@end

@implementation AddSelectListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame: frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame showVC:(UIViewController *)showListVC items:(NSArray<AddSelectListItem *> *)items
{
    if (self = [super initWithFrame:frame]) {
        if (items) {
            
            self.backgroundColor = [UIColor clearColor];            
            self.items           = items;
            self.showListVC      = showListVC;
            self.frame           = CGRectMake(WIDTH - AddSelectListItem_Width - 10, 64 + 5, AddSelectListItem_Width, AddSelectListItem_Height * items.count + 10);
            
            [self createTableView];
        }
    }
    return self;
}

- (void)createTableView{
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 10) style:UITableViewStylePlain];
    
    _tableView.delegate             = self;
    _tableView.dataSource           = self;
    _tableView.scrollEnabled        = NO;
    _tableView.rowHeight            = AddSelectListItem_Height;
    _tableView.backgroundColor      = [UIColor clearColor];
    _tableView.layer.cornerRadius   = 3;
    _tableView.layer.masksToBounds  = YES;
    [_tableView registerClass:[AddSelectListCell class] forCellReuseIdentifier:@"AddSelectListCell"];
    [self addSubview:_tableView];
    
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

- (void)setItems:(NSArray *)items{
    
    if (_items != items) {
        
        _items = items;
        
        self.frame       = CGRectMake(WIDTH - AddSelectListItem_Width - 10, 64 + 5, AddSelectListItem_Width, AddSelectListItem_Height * items.count + 10);
        _tableView.frame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 10);
        
        [_tableView reloadData];
    }
}


- (void)showClick:(AddSelectListClickBlock)clickBlock{
    
    AddSelectListViewController *listVC = [[AddSelectListViewController alloc] init];
    
    self.hidden         =  YES;
    self.listVC         = listVC;
    self.clickBlock     = clickBlock;
    listVC.addListView  = self;
    listVC.showListVC   = self.showListVC;
    listVC.animate      = self.animate;
    
    [self.listVC showListView];
}

- (void)dismiss{
    
    [self dismissSelfWithCompletion:nil];
}

- (void)dismissSelfWithCompletion:(void(^)(void))completion{
    
    [self.listVC dismissListView];
    
    if (completion) {
        
        completion();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSelectListCell"];
    AddSelectListItem *item = [_items objectAtIndex:indexPath.row];
    
    [cell configListWith:item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissSelfWithCompletion:^{
        if (self.clickBlock) {
            self.clickBlock(indexPath.row);
        }
    }];
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    /*三角形*/
    CGFloat centerX    = self.frame.size.width - 15;
    CGFloat top        = 5;
    CGFloat height     = 5;
    CGFloat layerWidth = height * sqrt(3) / 3;
    
    CGContextSetRGBFillColor  (context, 100.0 / 255.0, 100.0 / 255.0, 100.0 / 255.0, 1.0);//设置填充颜色
    CGContextSetRGBStrokeColor(context, 100.0 / 255.0, 100.0 / 255.0, 100.0 / 255.0, 1.0);//画笔线的颜色
    
    CGPoint sPoints[3];
    sPoints[0] =CGPointMake(centerX, top);
    sPoints[1] =CGPointMake(centerX - layerWidth, top + height);
    sPoints[2] =CGPointMake(centerX + layerWidth, top + height);
    CGContextAddLines(context, sPoints, 3);         //添加线
    CGContextClosePath(context);                    //封起来
    CGContextDrawPath(context, kCGPathFillStroke);  //根据坐标绘制路径
    
    
    /*画圆角矩形*/
    CGFloat arcTop = top + height + 1;
    float fw = self.frame.size.width;
    float fh = self.frame.size.height;
    
    CGContextMoveToPoint(context, fw, fh - 10);                     // 开始坐标右边开始
    CGContextAddArcToPoint(context, fw, fh, 10, fh, 4);             // 右下角角度
    CGContextAddArcToPoint(context, 0, fh, 0, arcTop, 4);           // 左下角角度
    CGContextAddArcToPoint(context, 0, arcTop, fw - 10, arcTop, 3); // 左上角
    CGContextAddArcToPoint(context, fw, arcTop, fw, fh - 10, 3);    // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);                  //根据坐标绘制路径
    
}

@end
