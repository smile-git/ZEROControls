//
//  MyAlertView.m
//  Alert
//
//  Created by ZWX on 2016/11/28.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertView.h"
#import "ZEROAlertItem.h"
#import "NSString+LabelWidthAndHeight.h"
#import "UIView+Ext.h"
#import "ZEROAlertButtonsCell.h"


#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height


static       CGFloat Alert_Width            = 270;      //alert宽度，可随着customView宽度改变270~(WIDTH - AlertGap * 2)
static const CGFloat AlertDefaultWidth      = 270;      //alert默认宽度
static const CGFloat AlertGap               = 20;       //间隔
static const CGFloat TitleMarginTop         = 20;       //标题上边距(也当无message时的下边距)
static const CGFloat TitleMarginLeft        = 20;       //标题左边距
static const CGFloat MessageMarginTop       = 18;       //title和message间距(也当messageLabel与下面控件边距)
static const CGFloat MessageMarginLeft      = 15;       //alert内容左边距
static const CGFloat CustomScrollHeightMin  = 70;       //customScrollView最小高度
static const CGFloat NormalButtonHeight     = 46;       //标准alert 按钮高度(左右两个的时候)
static const CGFloat ButtonsCellHeight      = 50;       //多个按钮alert 按钮列表cell高度
static const CGFloat ButtonsButtonHeight    = 40;       //多个按钮alert 按钮高度
static const CGFloat ButtonsLeftMargin      = 20;       //按钮列表 按钮左边距
static const CGFloat ButtonsTopMargin       = 10;       //按钮列表上边距

static const NSInteger buttonTag            = 10086;    //按钮的默认tag值

#define Z_Alert_BackgroundColor [UIColor whiteColor]
#define Z_Alert_Title_Color     UIColorRGBA(55, 52, 71, 1)
#define Z_Alert_Message_Color   UIColorRGBA(55, 52, 71, 1)
#define Z_Alert_Line_Color      [UIColor colorWithWhite:0.2 alpha:0.2]
#define Z_Alert_Title_Font      [UIFont systemFontOfSize:19]
#define Z_Alert_Message_Font    [UIFont systemFontOfSize:17]

// -----存放不固定的值
#define Z_Alert_Width_Max                 (WIDTH - AlertGap * 2)                 //alert最大宽度
#define Z_Alert_Height_Max                (HEIGHT - AlertGap * 2)                 //alert最大高度
#define Z_Alert_Buttons_Cell_Width        (Alert_Width - ButtonsLeftMargin * 2)   //
#define Z_Alert_ButtonsTable_Height_Max   (Z_Alert_Height_Max / 2.0 )             //按钮选择列表最大高度
#define Z_Alert_ButtonsTable_Height       ((_buttons.count * ButtonsCellHeight) > Z_Alert_ButtonsTable_Height_Max ? Z_Alert_ButtonsTable_Height_Max : _buttons.count * ButtonsCellHeight)        //按钮列表计算之后的高度
#define Z_Alert_CustomScroll_Height_Max   (Z_Alert_Height_Max - Z_Alert_ButtonsTable_Height)  //customScroll的高度

@interface ZEROAlertView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic)         ZEROAlertViewType     alertViewType;

@property (nonatomic, copy)   NSString              *title;
@property (nonatomic, copy)   NSString              *message;
@property (nonatomic, strong) NSArray               *buttons;
@property (nonatomic, strong) UIView                *customView;

@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UILabel               *messageLabel;
@property (nonatomic, strong) UIScrollView          *customScollView;
@property (nonatomic, strong) UIView                *horizontalLine;
@property (nonatomic, strong) UITableView           *buttonsTable;

@property (nonatomic)         CGFloat               customHeight;
@end

@implementation ZEROAlertView

#pragma mark - init method
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancle:(NSString *)cancle ok:(NSString *)ok click:(ClickHandleWithIndex)clickIndexHandle{
    
    NSString *cancleStr = cancle ? cancle : @"Cancel";
    NSString *okStr     = ok ? ok : @"OK";
    return [self initWithType:ZEROAlertViewTypeDefault
                        title:title
                      message:message
                   customView:nil
                        click:clickIndexHandle
                      buttons:@[@{@(0): cancleStr}, @{@(1): okStr}]];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message click:(ClickHandleWithIndex)clickIndexHandle buttons:(NSDictionary *)buttons, ...{
    
    NSMutableArray *btnArray  = [NSMutableArray array];
    NSString* curStr;
    va_list list;
    if(buttons){
        
        [btnArray addObject:buttons];
        
        va_start(list, buttons);
        while ((curStr = va_arg(list, NSString*))) {
            
            [btnArray addObject:curStr];
        }
        va_end(list);
    }
    
    return [self initWithType:ZEROAlertViewTypeButtons
                        title:title
                      message:message
                   customView:nil
                        click:clickIndexHandle
                      buttons:btnArray];
}

- (instancetype)initWithCustomView:(UIView *)customView cancle:(NSString *)cancle ok:(NSString *)ok click:(ClickHandleWithIndex)clickIndexHandle{
    
    NSString *cancleStr = cancle ? cancle : @"Cancel";
    NSString *okStr     = ok ? ok : @"OK";
    return [self initWithType:ZEROAlertViewTypeCustomDefault
                        title:nil
                      message:nil
                   customView:customView
                        click:clickIndexHandle
                      buttons:@[@{@(0): cancleStr}, @{@(1): okStr}]];
}

- (instancetype)initWithCustomView:(UIView *)customView click:(ClickHandleWithIndex)clickIndexHandle buttons:(NSDictionary *)buttons, ...{
    
    NSMutableArray *btnArray  = [NSMutableArray array];
    NSString* curStr;
    va_list list;
    if(buttons){
        
        [btnArray addObject:buttons];
        
        va_start(list, buttons);
        while ((curStr = va_arg(list, NSString*))) {
            
            [btnArray addObject:curStr];
        }
        va_end(list);
    }
    
    
    return [self initWithType:ZEROAlertViewTypeCustomButtons
                        title:nil
                      message:nil
                   customView:customView
                        click:clickIndexHandle
                      buttons:btnArray];
}

- (instancetype)initWithType:(ZEROAlertViewType)type title:(NSString *)title message:(NSString *)message customView:(UIView *)customView click:(ClickHandleWithIndex)clickIndexHandle buttons:(NSArray *)buttons{
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.alertStyle                 = ZEROAlertStyleAlert;
        self.alertViewType              = type;
        self.title                      = title;
        self.message                    = message;
        self.customView                 = [customView copy];
        self.customHeight               = customView.height;
        self.clickIndexHandle           = clickIndexHandle;
        self.dismissWhenTouchBackground = YES;
        
        Alert_Width = customView.width > Z_Alert_Width_Max ? Z_Alert_Width_Max : customView.width;
        Alert_Width = Alert_Width <= AlertDefaultWidth ? AlertDefaultWidth : Alert_Width;

        __block NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        [buttons enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZEROAlertItem *item = [[ZEROAlertItem alloc] initWithText:[[obj allValues] firstObject]
                                                                index:idx buttonType:[[[obj allKeys] firstObject] integerValue]
                                                          buttonFrame:CGRectMake(ButtonsLeftMargin, (ButtonsCellHeight - ButtonsButtonHeight) / 2.0, Z_Alert_Buttons_Cell_Width, ButtonsButtonHeight)];
            [items addObject:item];
        }];
        
        self.buttons = items;
        
        [self setUp];
    }
    return self;
}

#pragma mark - set method

- (void)setUp{
    
    self.titleLabel      = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel    = [[UILabel alloc] initWithFrame:CGRectZero];
    self.customScollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.buttonsTable    = [[UITableView alloc] initWithFrame:CGRectZero];
    self.horizontalLine  = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.layer.cornerRadius         = 10;
    self.layer.masksToBounds        = YES;
    self.backgroundColor            = Z_Alert_BackgroundColor;
    
    _titleLabel.font                = Z_Alert_Title_Font;
    _titleLabel.textColor           = Z_Alert_Title_Color;
    _titleLabel.textAlignment       = NSTextAlignmentCenter;
    _titleLabel.numberOfLines       = 0;
    _messageLabel.font              = Z_Alert_Message_Font;
    _messageLabel.textColor         = Z_Alert_Message_Color;
    _messageLabel.textAlignment     = NSTextAlignmentCenter;
    _messageLabel.numberOfLines     = 0;
    _horizontalLine.backgroundColor = Z_Alert_Line_Color;
    
    _titleLabel.text                = _title;
    _messageLabel.text              = _message;
    
    _buttonsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _buttonsTable.delegate       = self;
    _buttonsTable.dataSource     = self;
    _buttonsTable.scrollEnabled  = NO;

    _buttonsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    switch (_alertViewType) {
            
        case ZEROAlertViewTypeDefault:{
            
            [_customScollView addSubview:_messageLabel];
            [self addSubview:_titleLabel];
        }
            break;
        case ZEROAlertViewTypeButtons:{
            
            [_customScollView addSubview:_messageLabel];
            [self addSubview:_titleLabel];
            [self addSubview:_buttonsTable];
        }
            break;
        case ZEROAlertViewTypeCustomDefault:{
            
            [_customScollView addSubview:_customView];
        }
            break;
        case ZEROAlertViewTypeCustomButtons:{
            
            [_customScollView addSubview:_customView];
            [self addSubview:_buttonsTable];
        }
            break;
        default:
            break;
    }
    [self addSubview:_customScollView];
    [self addSubview:_horizontalLine];
    
}


/**
 * @brief alert及子控件坐标排布
 * @discussion 根据title、message、customView、buttons来计算各个控件的frame。整个alert的size、center
 */
- (void)configAlert{
    
    _titleLabel.frame       = [self titleFrame];
    _messageLabel.frame     = [self messageFrame];
    _customScollView.frame  = [self customScrollFrame];
    _customView.frame       = [self customFrame];   //比较迷得一个bug，xib创建view。在customScroll设置frame之后，宽高会增加一倍。再更新下frame
    _horizontalLine.frame   = [self horizontalLineFrame];
    _buttonsTable.frame     = [self buttonsTableFrame];
    
    switch (_alertViewType) {
            
        case ZEROAlertViewTypeDefault:{
            
            UIView *verticalLine = [[UIView alloc] initWithFrame:[self verticalLineFrame]];
            verticalLine.backgroundColor = Z_Alert_Line_Color;
            [self addSubview:verticalLine];
            
            [_buttons enumerateObjectsUsingBlock:^(ZEROAlertItem *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = [self alertButtonWith:item];
                button.frame     = [self normalButtonFrame:idx];
                button.tag       = buttonTag + idx;
                
                [self addSubview:button];
            }];
            
            self.frame  = CGRectMake(0, 0, Alert_Width, verticalLine.bottom);
        }
            break;
        case ZEROAlertViewTypeButtons:{
            
            _horizontalLine.height = 0;
            self.frame = CGRectMake(0, 0, Alert_Width, _buttonsTable.bottom + ButtonsTopMargin);
        }
            break;
        case ZEROAlertViewTypeCustomDefault:{
            
            UIView *verticalLine = [[UIView alloc] initWithFrame:[self verticalLineFrame]];
            verticalLine.backgroundColor = Z_Alert_Line_Color;
            [self addSubview:verticalLine];
            
            [_buttons enumerateObjectsUsingBlock:^(ZEROAlertItem *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = [self alertButtonWith:item];
                button.frame     = [self normalButtonFrame:idx];
                button.tag       = buttonTag + idx;
                
                [self addSubview:button];
            }];
            
            _customScollView.bounces = NO;
            self.frame               = CGRectMake(0, 0, Alert_Width, verticalLine.bottom);
            
        }
            break;
        case ZEROAlertViewTypeCustomButtons:{
            
            _customScollView.bounces = NO;
            if (_buttonsTable.height <= 0) {
                
                _horizontalLine.height = 0;
                self.frame = CGRectMake(0, 0, Alert_Width, _buttonsTable.bottom - _horizontalLine.height);
            }
            else{
                
                self.frame = CGRectMake(0, 0, Alert_Width, _buttonsTable.bottom + ButtonsTopMargin);
            }
        }
            break;
        default:
            break;
    }
    
    self.center = CGPointMake(WIDTH / 2, HEIGHT / 2);
    
}

- (UIButton *)alertButtonWith:(ZEROAlertItem *)item{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundColor:item.backgroundColor];
    [button setTitleColor:item.textColor forState:UIControlStateNormal];
    [button setTitle:item.text forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (item.layerColor) {
        
        button.layer.borderColor    = item.layerColor.CGColor;
        button.layer.borderWidth    = 1;
        button.layer.cornerRadius   = 5;
        button.layer.masksToBounds  = YES;
    }
    
    return button;
}


#pragma mark - event method

#pragma mark -
#pragma mark button click
- (void)buttonClick:(UIButton *)sender{
    
    [self dismissWithCompletion:^{
        
        NSInteger tag = sender.tag - buttonTag;
        
        if (self.clickIndexHandle) {
            self.clickIndexHandle(tag);
        }
    }];
}

#pragma mark - delegate method

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ButtonsCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = _buttons.count - 1 - indexPath.row;

    [self dismissWithCompletion:^{
        
        if (self.clickIndexHandle) {
            
            self.clickIndexHandle(index);
        }
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _buttons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZEROAlertButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZEROAlertButtonsCell"];
    if (!cell) {
        
        cell = [[ZEROAlertButtonsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZEROAlertButtonsCell"];
    }
    
    [cell configAlertButtons:_buttons[indexPath.row]];
    
    return cell;
    
    
}

#pragma mark - frame method


/**
 * @brief 计算标题的坐标
 *  
 * @discussion 有title，则是 ZEROAlertViewTypeDefault 和 ZEROAlertViewTypeButtons 其中一种Alert。其宽度都是固定的270
 * @return titleLabel's frame
 */
- (CGRect)titleFrame{
    
    CGFloat TitleWidth  = Alert_Width - TitleMarginLeft * 2;
    
    CGFloat titleHeight = [_title heightWithStringFont:Z_Alert_Title_Font fixedWidth:TitleWidth];
    
    CGFloat top         = titleHeight > 0 ? TitleMarginTop : 0;
    
    return CGRectMake(TitleMarginLeft, top, TitleWidth, titleHeight);
}


/**
 * @brief 计算Alert内容坐标
 *
 *
 * @return messageLabel's frame
 */
- (CGRect)messageFrame{

    CGFloat MessageWidth  = Alert_Width - MessageMarginLeft * 2;
    CGFloat messageHeight = [_message heightWithStringFont:Z_Alert_Message_Font fixedWidth:MessageWidth];
    CGFloat top           = 0.0;
    
    if (_titleLabel.height > 0) {
        // -----如果title不为nil
        if (messageHeight > 0) {
            // -----message不为nil，message的originY就是 MessageMarginTop的1/2(customScroll的originY 也是1/2)
            top = MessageMarginTop / 2.0;
        }
        else{
            // -----message为nil时，message高度为0，customScroll高度也为0，调整titleLabel的高度
            _titleLabel.height = _titleLabel.bottom < (CustomScrollHeightMin - TitleMarginTop) ? (CustomScrollHeightMin - TitleMarginTop * 2) : _titleLabel.height;
            top = 0.0;
        }
    }
    else{
        // -----如果title为nil，message不为nil时，messageLabel的originY为 3/4(另 1/4 是customScroll的originY)
        top = messageHeight > 0 ? (MessageMarginTop / 2.0 + MessageMarginTop / 4.0) : 0;
    }
    
    return CGRectMake(MessageMarginLeft, top, MessageWidth, messageHeight);
}

- (CGRect)customFrame{
    
    return CGRectMake(0, 0, Alert_Width, _customHeight);
}


/**
 * @brief 计算customScroll的坐标
 *
 * @discussion customScroll的子控件不固定，所以坐标计算比较麻烦。
 *
 * @return customScrollView's frame
 */
- (CGRect)customScrollFrame{
    
    CGFloat top             = 0.0;
    CGFloat height          = 0.0;
    CGFloat contentHeight   = 0.0;
    
    switch (_alertViewType) {
            
        case ZEROAlertViewTypeDefault:{
            
            top     = [self customScrollViewTop];
            height  = _messageLabel.height > 0 ? _messageLabel.bottom + MessageMarginTop: 0;
            height  = height > (Z_Alert_Height_Max - NormalButtonHeight - top) ? (Z_Alert_Height_Max - NormalButtonHeight - top) : height;
            
            contentHeight   = _messageLabel.bottom > 0 ? _messageLabel.bottom + MessageMarginTop : 0;
        }
            break;
        case ZEROAlertViewTypeButtons:{
            
            top     = [self customScrollViewTop];
            height  = _messageLabel.height > 0 ? _messageLabel.bottom : 0;
            height  = [self configCustomScrollHeight:height top:top];
            
            contentHeight   = _messageLabel.bottom > 0 ? _messageLabel.bottom: 0;
        }
            break;
        case ZEROAlertViewTypeCustomDefault:{
            
            height          = _customView.height;
            height          = height > (Z_Alert_Height_Max - NormalButtonHeight) ? (Z_Alert_Height_Max - NormalButtonHeight) : height;
            contentHeight   = _customView.height;
        }
            break;
        case ZEROAlertViewTypeCustomButtons:{
            
            height          = _customView.height;
            height          = [self configCustomScrollHeight:height top:top];
            contentHeight   = _customView.height;
        }
            break;
        default:
            break;
    }
    
    _customScollView.contentSize = CGSizeMake(Alert_Width, contentHeight);
    
    if ((top + height) < CustomScrollHeightMin && _titleLabel <= 0) {
        
        _messageLabel.center = CGPointMake(Alert_Width / 2.0, CustomScrollHeightMin / 2.0);
        return CGRectMake(0, 0, Alert_Width, CustomScrollHeightMin);
    }
    return CGRectMake(0, top, Alert_Width, height);
}


/**
 * @brief alertViewType = 0,1 时，customScroll的top
 * @return customScroll'top
 */
- (CGFloat)customScrollViewTop{
    
    CGFloat top = 0.0;
    if (_titleLabel.height > 0) {
        
        if (_messageLabel.height > 0) {
            
            top = _titleLabel.bottom + MessageMarginTop / 2.0;
        }
        else{
            
            top = _titleLabel.bottom + TitleMarginTop;
        }
    }
    else{
        // -----1/4是为了视图美观。。。。。。。
        top = _messageLabel.height > 0 ? MessageMarginTop / 4.0 : 0;
    }
    return top;
}


- (CGRect)horizontalLineFrame{
    
    CGFloat top     = _customScollView.bottom > 0 ? _customScollView.bottom : 0;
    CGFloat height  = _customScollView.bottom > 0 ? 1 : 0;
    
    return CGRectMake(0, top, Alert_Width, height);
}

- (CGRect)verticalLineFrame{
    
    CGFloat top = _horizontalLine.height > 0 ? _horizontalLine.bottom : 0;
    
    return CGRectMake(Alert_Width / 2.0 - 0.5, top, 1, NormalButtonHeight);
}

- (CGRect)normalButtonFrame:(NSInteger)idx{
    
    CGFloat top = _horizontalLine.height > 0 ? _horizontalLine.bottom : 0;
    
    return CGRectMake(idx * (Alert_Width / 2.0 + 1),top, (Alert_Width - 1.0) / 2.0, NormalButtonHeight);
}



/**
 @brief 在AlertViewType = 1,3 时，buttonTableView的坐标

 @return buttonTableView's frame
 */
- (CGRect)buttonsTableFrame{
    
    if (_buttons.count <= 0) {
        
        return CGRectMake(0, _horizontalLine.bottom, Alert_Width, 0);
    }
    
    CGFloat top = _horizontalLine.bottom > 0 ? _horizontalLine.bottom + ButtonsTopMargin : ButtonsTopMargin;
    CGFloat height = ButtonsCellHeight * _buttons.count;
    
    if (ButtonsTopMargin + height + _customScollView.bottom > Z_Alert_Height_Max) {
        
        height = Z_Alert_Height_Max - _customScollView.bottom - ButtonsTopMargin;
        // -----如果下半部分高度 小于 Alert最大高度的一半(上高下矮)，tableView不可滑动
        if (height + ButtonsTopMargin <= Z_Alert_Height_Max / 2.0) {
            
            _buttonsTable.scrollEnabled = NO;
        }
        else{
            
            _buttonsTable.scrollEnabled = YES;
        }
    }
    
    return CGRectMake(0, top, Alert_Width, height);
}


/**
 @brief 根据button的个数，对customScrollView的高度进行更新

 @param height customScrollView's height
 @param top    customScrollView's top

 @return customScrollView's height(new)
 */
- (CGFloat)configCustomScrollHeight:(CGFloat)height top:(CGFloat)top{
    
    CGFloat bottomtHeight  = _buttons.count * ButtonsCellHeight + ButtonsTopMargin;;
    
    if (top + height + bottomtHeight > Z_Alert_Height_Max) {
        
        if (top + height > (Z_Alert_Height_Max / 2.0)) {
            
            if (bottomtHeight > (Z_Alert_Height_Max / 2.0)) {
                
                return Z_Alert_Height_Max / 2.0;
                //return Z_Alert_Height_Max / 2.0 - top;
            }
            else{
                
                return Z_Alert_Height_Max - bottomtHeight - top;
            }
        }
        
    }
    return height;
}

@end

