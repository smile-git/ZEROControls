//
//  MyAlertView.m
//  Alert
//
//  Created by ZWX on 2016/11/28.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertView.h"
#import "ZEROAlertItem.h"
#import "ZEROAlertButtonsCell.h"
#import "ZEROAlertFrameManager.h"


@interface ZEROAlertView()<UITableViewDelegate, UITableViewDataSource, ZEROAlertButtonsCellDelegate>

@property (nonatomic, strong) NSArray           *buttons;
@property (nonatomic, copy)   NSString          *title;
@property (nonatomic, copy)   NSString          *message;
@property (nonatomic, copy)   NSString          *cancelButtonTitle;
@property (nonatomic, strong) UIView            *customView;
@property (nonatomic)         ZEROAlertViewType alertViewType;

@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UILabel           *messageLabel;
@property (nonatomic, strong) UIScrollView      *contentScroll;
@property (nonatomic, strong) UIView            *horizontalLine;
@property (nonatomic, strong) UITableView       *buttonsList;


@property (nonatomic, strong) UIColor *alertColor;
@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIColor *messageTextColor;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic, strong) ZEROAlertFrameManager *frameManager;
@end

@implementation ZEROAlertView

#pragma mark - init method

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message clickHandle:(ClickHandleWithIndex)clickHandle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    NSMutableArray *btnArray  = [NSMutableArray array];
    
    if (cancelButtonTitle) {
        
        [btnArray addObject:cancelButtonTitle];
    }
    
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
    
    ZEROAlertViewType type = btnArray.count == 2 ? ZEROAlertViewTypeDefault : ZEROAlertViewTypeButtons;
    return [self initWithType:type Title:title message:message clickHandle:clickHandle cancelButtonTitle:cancelButtonTitle customView:nil buttons:btnArray];
}

- (instancetype)initWithCustomView:(UIView *)customView clickHandle:(ClickHandleWithIndex)clickHandle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    NSMutableArray *btnArray  = [NSMutableArray array];
    
    if (cancelButtonTitle) {
        
        [btnArray addObject:cancelButtonTitle];
    }
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
    
    ZEROAlertViewType type = btnArray.count == 2 ? ZEROAlertViewTypeCustomDefault : ZEROAlertViewTypeCustomButtons;
    return [self initWithType:type Title:nil message:nil clickHandle:clickHandle cancelButtonTitle:cancelButtonTitle customView:customView buttons:btnArray];
}

- (instancetype)initWithType:(ZEROAlertViewType)type Title:(NSString *)title message:(NSString *)message clickHandle:(ClickHandleWithIndex)clickHandle cancelButtonTitle:(NSString *)cancelButtonTitle customView:(UIView *)customView buttons:(NSArray *)buttons{
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.dismissWhenTouchBackground = NO;
        
        self.alertViewType      = type;
        self.title              = title;
        self.message            = message;
        self.clickIndexHandle   = clickHandle;
        self.cancelButtonTitle  = cancelButtonTitle;
        self.customView         = customView;
        self.buttons            = buttons;
        self.backgroundColor    = [UIColor whiteColor];
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    self.layer.cornerRadius  = 10;
    self.layer.masksToBounds = YES;
    
    self.titleLabel     = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentScroll  = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.horizontalLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.buttonsList    = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _titleLabel.textAlignment       = NSTextAlignmentCenter;
    _titleLabel.numberOfLines       = 0;
    _titleLabel.text                = _title;
    
    _messageLabel.textAlignment     = NSTextAlignmentCenter;
    _messageLabel.numberOfLines     = 0;
    _messageLabel.text              = _message;
    
    _buttonsList.delegate           = self;
    _buttonsList.dataSource         = self;
    _buttonsList.scrollEnabled      = NO;
    _buttonsList.separatorStyle     = UITableViewCellSeparatorStyleNone;
    
    switch (_alertViewType) {
            
        case ZEROAlertViewTypeDefault:{
            
            [_contentScroll addSubview:_messageLabel];
            [self addSubview:_horizontalLine];
            [self addSubview:_titleLabel];
        }
            break;
        case ZEROAlertViewTypeButtons:{
            
            [_contentScroll addSubview:_messageLabel];
            [self addSubview:_titleLabel];
            [self addSubview:_buttonsList];
        }
            break;
        case ZEROAlertViewTypeCustomDefault:{
            
            [_contentScroll addSubview:_customView];
            [self addSubview:_horizontalLine];
        }
            break;
        case ZEROAlertViewTypeCustomButtons:{
            
            [_contentScroll addSubview:_customView];
            [self addSubview:_buttonsList];
        }
            break;
        default:
            break;
    }
    
    [self addSubview:_contentScroll];
}

#pragma mark - config Alert subviews

- (void)configAlert{
    
    self.backgroundColor            = self.alertColor;
    _titleLabel.font                = self.titleFont;
    _titleLabel.textColor           = self.titleTextColor;
    _messageLabel.font              = self.messageFont;
    _messageLabel.textColor         = self.messageTextColor;
    _titleLabel.backgroundColor     = [UIColor clearColor];
    _messageLabel.backgroundColor   = [UIColor clearColor];
    _contentScroll.backgroundColor  = self.backgroundColor;
    _horizontalLine.backgroundColor = self.lineColor;
    _buttonsList.backgroundColor    = self.backgroundColor;
    
    self.frameManager = [[ZEROAlertFrameManager alloc] initWithType:_alertViewType title:_title titleFont:_titleFont message:_message messageFont:_messageFont customView:_customView buttons:_buttons];
    
    _titleLabel.frame           = _frameManager.titleLabelFrame;
    _messageLabel.frame         = _frameManager.messageLabelFrame;
    _contentScroll.frame        = _frameManager.contentScrollViewFrame;
    _customView.frame           = _frameManager.customViewFrame;   //比较迷得一个bug，xib创建view。在customScroll设置frame之后，宽高会增加一倍。再更新下frame
    _horizontalLine.frame       = _frameManager.horizontalLineFrame;
    _buttonsList.frame          = _frameManager.buttonsListFrame;
    _contentScroll.contentSize  = _frameManager.contentScolllViewContentSize;
    
    switch (_alertViewType) {
            
        case ZEROAlertViewTypeDefault:{
            
            UIView *verticalLine = [[UIView alloc] initWithFrame:[_frameManager verticalLineFrame]];
            verticalLine.backgroundColor = self.lineColor;
            [self addSubview:verticalLine];
            
            [_buttons enumerateObjectsUsingBlock:^(ZEROAlertItem *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = [self alertButtonWith:item];
                button.frame     = [_frameManager calculateNormalButtonFrame:idx];
                button.tag       = buttonTag + idx;
                
                [self addSubview:button];
            }];
        }
            break;
        case ZEROAlertViewTypeButtons:{
            
            _buttonsList.scrollEnabled = _frameManager.buttonsListScrollEnabled;
            _horizontalLine.hidden = YES;
        }
            break;
        case ZEROAlertViewTypeCustomDefault:{
            
            UIView *verticalLine = [[UIView alloc] initWithFrame:[_frameManager verticalLineFrame]];
            verticalLine.backgroundColor = self.lineColor;
            [self addSubview:verticalLine];
            
            [_buttons enumerateObjectsUsingBlock:^(ZEROAlertItem *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = [self alertButtonWith:item];
                button.frame     = [_frameManager calculateNormalButtonFrame:idx];
                button.tag       = buttonTag + idx;
                
                [self addSubview:button];
            }];
            
            _contentScroll.bounces = NO;
        }
            break;
        case ZEROAlertViewTypeCustomButtons:{
            
            _buttonsList.scrollEnabled = _frameManager.buttonsListScrollEnabled;
            _contentScroll.bounces = NO;
        }
            break;
        default:
            break;
    }
    
    self.frame  = CGRectMake(0, 0, _frameManager.alertWidth, _frameManager.alertHeight);
    self.center = CGPointMake(WIDTH / 2, HEIGHT / 2);
    
}

- (UIButton *)alertButtonWith:(ZEROAlertItem *)item{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundColor:item.backgroundColor];
    [button setTitleColor:item.textColor forState:UIControlStateNormal];
    [button setTitle:item.text forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
- (void)buttonsButtonClick:(UIButton *)sender{
    
    NSInteger index = 0;
    
    switch (_alertViewType) {
            
        case ZEROAlertViewTypeDefault:
        case ZEROAlertViewTypeCustomDefault:
            
            index = sender.tag - buttonTag;
            break;
        case ZEROAlertViewTypeButtons:
        case ZEROAlertViewTypeCustomButtons:
            
            index = sender.tag - buttonTag;
            break;
        default:
            break;
    }
    
    [self dismissWithCompletion:^{
        
        if (self.clickIndexHandle) {
            
            self.clickIndexHandle(index);
        }
    }];
}

#pragma mark - delegate method

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_frameManager) {
        
        return _frameManager.buttonsListCellHeight;
    }
    return 50.0;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _buttons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZEROAlertButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZEROAlertButtonsCell"];
    if (!cell) {
        
        cell = [[ZEROAlertButtonsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZEROAlertButtonsCell"];
        cell.delegate = self;
    }
    
    ZEROAlertItem *item = _buttons[indexPath.row];
    item.buttonFrame = [_frameManager calculateButtonListButtonFrame];
    [cell configAlertButtons:_buttons[indexPath.row]];
    
    return cell;
    
    
}

#pragma mark - set method
- (void)setButtons:(NSArray *)buttons{
    
    __block NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    __block NSInteger buttonType  = 0;
    
    [buttons enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (buttons.count == 2) {
            // -----如果只有两个按钮，为Alert标准模式
            if (idx == 0) {
                
                buttonType = ZEROAlertViewButtonTypeNomalCancel;
            }
            else{
                
                buttonType = ZEROAlertViewButtonTypeNomalOK;
            }
        }
        else{
            // -----按钮列表模式
            if (idx == 0 && _cancelButtonTitle) {
                // -----第一个是cancel
                buttonType = ZEROAlertViewButtonTypeButtonsCancel;
            }
            else{
                // -----非cancel
                buttonType = ZEROAlertViewButtonTypeButtonsDefault;
            }
        }
        
        ZEROAlertItem *item = [[ZEROAlertItem alloc] initWithText:obj index:idx buttonType:buttonType buttonFrame:CGRectZero];
        
        if (buttons.count == 2) {
            
            [items addObject:item];
        }
        else{
            
            [items insertObject:item atIndex:0];
        }
    }];
    
    _buttons = items;
}

- (void)setOtherButtons:(NSArray<NSDictionary *> *)otherButtons{
    
    NSMutableArray *allButtons = [NSMutableArray arrayWithArray:otherButtons];
    if (_cancelButtonTitle) {
        
        [allButtons insertObject:@{@(0):_cancelButtonTitle} atIndex:0];
    }
    
    __block NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    [otherButtons enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        ZEROAlertItem *item = [[ZEROAlertItem alloc] initWithText:[[obj allValues] firstObject] index:idx buttonType:[[[obj allKeys] firstObject] integerValue] buttonFrame:CGRectZero];
        [items addObject:item];
    }];
    
    _buttons = items;
    
    [self configAlertViewType];
}

- (void)configAlertViewType{
    
    if (_buttons.count == 2) {
        
        if (_customView) {
            
            _alertViewType = ZEROAlertViewTypeCustomDefault;
        }
        else{
            
            _alertViewType = ZEROAlertViewTypeDefault;
        }
    }
    else{
        
        if (_customView) {
            
            _alertViewType = ZEROAlertViewTypeCustomButtons;
        }
        else{
            
            _alertViewType = ZEROAlertViewTypeButtons;
        }
    }
}

#pragma mark - get method

- (UIColor *)alertColor{
    
    if (!_alertColor) {
        
        _alertColor = [UIColor whiteColor];
    }
    return _alertColor;
}

- (UIColor *)titleTextColor{
    
    if (!_titleTextColor) {
        
        _titleTextColor = UIColorRGBA(55, 52, 71, 1);
    }
    return _titleTextColor;
}

- (UIColor *)messageTextColor{
    
    if (!_messageTextColor) {
        
        _messageTextColor = UIColorRGBA(55, 52, 71, 1);
    }
    return _messageTextColor;
}

- (UIColor *)lineColor{
    
    if (!_lineColor) {
        
        _lineColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    }
    return _lineColor;
}

- (UIFont *)titleFont{
    
    if (!_titleFont) {
        
        _titleFont = [UIFont systemFontOfSize:19];
    }
    return _titleFont;
}

- (UIFont *)messageFont{
    
    if (!_messageFont) {
        
        _messageFont = [UIFont systemFontOfSize:17];
    }
    return _messageFont;
}
// Duplicate UIView
// 完全复制一个UIView和对象的时候可以使用对象序列化方法
- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
@end

