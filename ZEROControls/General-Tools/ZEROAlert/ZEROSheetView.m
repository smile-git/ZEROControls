//
//  ZEROSheetView.m
//  Alert
//
//  Created by ZWX on 2016/11/26.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROSheetView.h"
#import "NSString+LabelWidthAndHeight.h"

#define Z_Sheet_Height_Max      HEIGHT - 100                            //Sheet最大高度
#define Z_Sheet_BackgroundColor [UIColor whiteColor]                    //sheet背景颜色
#define Z_Sheet_Title_Font      [UIFont systemFontOfSize:19]            //标题字号
#define Z_Sheet_Detail_Font     [UIFont systemFontOfSize:14]            //选择列表字号
#define Z_Sheet_Cancle_Font     [UIFont systemFontOfSize:15]            //取消按钮字号
#define Z_Sheet_Title_Color     UIColorRGBA(55, 52, 71, 1)              //标题字体颜色
#define Z_Sheet_Line_Color      [UIColor colorWithWhite:0.2 alpha:0.2]  //标题线背景颜色
#define Z_Sheet_Cancle_Color    UIColorRGBA(251, 80, 114, 1)            //取消字体颜色

static const CGFloat SheetCellHeight    = 40;       //选择列表高度
static const CGFloat SheetCancelHeight  = 50;       //取消按钮高度
static const CGFloat TitleTopMargin     = 15;       //标题上边距
static const CGFloat TitleLeftMargin    = 20;       //标题左右边距
static const CGFloat SectionGap         = 15;       //取消按钮和选择列表距离

#define Z_Sheet_Title_Width   WIDTH - TitleLeftMargin * 2               //标题宽度


@interface ZEROSheetView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic)         ZEROSheetViewType sheetViewtype;          //sheet类型
@property (nonatomic, copy)   NSString          *title;                 //标题文字
@property (nonatomic, copy)   NSString          *cancelButtonTitle;     //取消按钮文字
@property (nonatomic, strong) NSArray           *otherButtonTitles;     //其他列表文字数组

@property (nonatomic, strong) UITableView       *actionsTable;          //其他选择列表
@property (nonatomic, strong) UIView            *customView;            //sheet内展示的view

@end

@implementation ZEROSheetView

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle click:(ClickHandleWithIndex)clickHandle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    NSMutableArray *btnArray  = [NSMutableArray array];
    NSString* curStr;
    va_list list;
    if(otherButtonTitles){
        
        [btnArray addObject:otherButtonTitles];
        
        va_start(list, otherButtonTitles);
        while ((curStr = va_arg(list, NSString*))) {
            
            [btnArray addObject:curStr];
        }
        va_end(list);
    }
    
    return [self initWithType:ZEROSheetViewTypeDefault title:title customView:nil cancelButtonTitle:cancelButtonTitle click:clickHandle otherButtonTitles:btnArray];
}

- (instancetype)initWithCustomView:(UIView *)customView cancelButtonTitle:(NSString *)cancelButtonTitle click:(ClickHandleWithIndex)clickHandle{
    
    return [self initWithType:ZEROSheetViewTypeCustom title:nil customView:customView cancelButtonTitle:cancelButtonTitle click:clickHandle otherButtonTitles:nil];
}

- (instancetype)initWithType:(ZEROSheetViewType)sheetViewType title:(NSString *)title customView:(UIView *)customView cancelButtonTitle:(NSString *)cancelButtonTitle click:(ClickHandleWithIndex)clickHandle otherButtonTitles:(NSArray *)otherButtonTitles{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 0)]) {
        
        self.alertStyle                 = ZEROAlertStyleActionSheet;
        self.sheetViewtype              = sheetViewType;
        self.title                      = title;
        self.customView                 = customView;
        self.cancelButtonTitle          = cancelButtonTitle;
        self.clickIndexHandle           = clickHandle;
        self.otherButtonTitles          = otherButtonTitles;
        self.dismissWhenTouchBackground = YES;
        
        [self setUp];
    }
    return self;

}

- (void)setUp{
    
    self.actionsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _actionsTable.delegate              = self;
    _actionsTable.dataSource            = self;
    _actionsTable.sectionFooterHeight   = 0.0;
    _actionsTable.backgroundColor       = [UIColor clearColor];
    _actionsTable.separatorInset        = UIEdgeInsetsZero;
    [self addSubview:_actionsTable];
    
    self.backgroundColor = [UIColor whiteColor];
    
}

/**
 * @brief sheet及子控件坐标排布
 * @discussion 根据title、message、customView、buttons来计算各个控件的frame。整个sheet的size、center
 */
- (void)configSheet{
    
    CGFloat height = 0.0;
    
    height += [self section0Height];
    
    height += [self section1Height];
    
    // -----超出最大高度的时候，高度固定，并且tableview可滑动
    height = height > Z_Sheet_Height_Max ? Z_Sheet_Height_Max : height;
    _actionsTable.scrollEnabled = height > Z_Sheet_Height_Max;
    _actionsTable.frame         = CGRectMake(0, 0, WIDTH, height);
    
    // -----y轴从页底开始，实现移动动画效果
    self.frame = CGRectMake(0, HEIGHT, WIDTH, height);
    
}

#pragma mark - delegate method

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        return SheetCancelHeight;
    }
    return SheetCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return [self section0HeaderHeight];
    }
    else{
        
        return [self section1HeaderHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = 0;
    if (indexPath.section == 0) {
        
        index = _otherButtonTitles.count - indexPath.row;
        if (_cancelButtonTitle == nil) {
            
            index -= 1;
        }
    }
    NSLog(@"%zi", index);
    [self dismissWithCompletion:^{
        
        if (self.clickIndexHandle) {
            
            self.clickIndexHandle(index);
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = nil;
    
    if (section == 0) {
        
        switch (_sheetViewtype) {
                
            case ZEROSheetViewTypeDefault:{
                
                CGFloat titleHeight = [self titleLabelFrame].size.height;
                if (titleHeight <= 0) {
                    
                    return headerView;
                }
                
                headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, titleHeight + TitleTopMargin * 2)];
                UILabel *titleLabel         = [[UILabel alloc] initWithFrame:[self titleLabelFrame]];
                titleLabel.textAlignment    = NSTextAlignmentCenter;
                titleLabel.text             = _title;
                titleLabel.font             = Z_Sheet_Title_Font;
                titleLabel.textColor        = Z_Sheet_Title_Color;
                [headerView addSubview:titleLabel];
                headerView.backgroundColor  = Z_Sheet_BackgroundColor;

                if (_otherButtonTitles.count > 0) {
                    
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left * 1.5, titleLabel.bottom + TitleTopMargin - 1, WIDTH - titleLabel.left * 3, 1)];
                    lineView.backgroundColor = Z_Sheet_Line_Color;
                    [headerView addSubview:lineView];
                }                
            }
                break;
            case ZEROSheetViewTypeCustom:{
                
                _customView.frame   = CGRectMake(0, 0, _customView.width > WIDTH ? WIDTH : _customView.width, _customView.height);
                _customView.centerX = WIDTH / 2.0;
                headerView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _customView.height)];
                [headerView addSubview:_customView];
            }
                break;
            default:
                break;
        }
    }
    
    return headerView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return _sheetViewtype == ZEROSheetViewTypeCustom ? 0 : _otherButtonTitles.count;
    }
    else{
        
        return _cancelButtonTitle ? 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonsCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buttonsCell"];
        cell.backgroundColor = Z_Sheet_BackgroundColor;
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 1) {
        
        cell.textLabel.textColor = Z_Sheet_Cancle_Color;
        cell.textLabel.font      = Z_Sheet_Cancle_Font;
        cell.textLabel.text      = _cancelButtonTitle;
    }
    else{
        
        cell.textLabel.textColor = Z_Sheet_Title_Color;
        cell.textLabel.font      = Z_Sheet_Detail_Font;
        cell.textLabel.text      = _otherButtonTitles[_otherButtonTitles.count - 1 - indexPath.row];
    }
    
    return cell;
}

#pragma mark - frame method
/**
 * @brief 计算title的坐标
 * @return title‘s frame
 */
- (CGRect)titleLabelFrame{
    
    CGFloat titleHeight = [_title heightWithStringFont:Z_Sheet_Title_Font fixedWidth:Z_Sheet_Title_Width];
    CGFloat top         = titleHeight > 0 ? TitleTopMargin : 0;
    
    return CGRectMake(TitleLeftMargin, top, Z_Sheet_Title_Width, titleHeight);
}


/**
 * @brief 计算 section = 0 的header高度
 * @return header's height
 */
- (CGFloat)section0HeaderHeight{
    
    CGFloat height = 0.0;
    switch (_sheetViewtype) {
        case ZEROSheetViewTypeDefault:{
            
            CGFloat titleHeight = [self titleLabelFrame].size.height;
            
            // -----header的高度
            height = titleHeight > 0 ? (titleHeight + TitleTopMargin * 2) : 0;
        }
            break;
        case ZEROSheetViewTypeCustom:{
            
            // -----header的高度
            height = _customView.height;
            
        }
            break;
        default:
            break;
    }
    return height;
}

/**
 * @brief 计算 section = 1 的header高度
 * @return header's height
 */
- (CGFloat)section1HeaderHeight{
    
    CGFloat height = 0.0;
    
    if ((_title || _otherButtonTitles.count > 0 || _customView.height > 0) && _cancelButtonTitle) {
        
        // -----section = 1 的header高度(只有secion=0有高度的时候，才有会显示间距)
        height = SectionGap;
    }
    
    return height;
}

/**
 * @brief 计算 section = 0 的总高度
 * @return section's height(header + all cell)
 */
- (CGFloat)section0Height{
    
    return [self section0HeaderHeight] + _otherButtonTitles.count * SheetCellHeight;
}

/**
 * @brief 计算 section = 1 的总高度
 * @return section's height(header + cancel)
 */
-(CGFloat)section1Height{
    
    CGFloat height = 0.0;
    if (_cancelButtonTitle) {
        
        // -----section = 1 的cell高度(cancel高度)
        height = SheetCancelHeight;
    }
    
    return height + [self section1HeaderHeight];
}

@end
