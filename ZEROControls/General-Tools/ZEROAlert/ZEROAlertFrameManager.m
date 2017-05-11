//
//  ZEROAlertFrameManager.m
//  Alert
//
//  Created by ZWX on 2016/11/28.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertFrameManager.h"
#import "NSString+LabelWidthAndHeight.h"

static const CGFloat AlertDefaultWidth      = 270.0;    //alert默认宽度
static const CGFloat AlertGap               = 20.0;     //间隔
static const CGFloat TitleMarginTop         = 20.0;     //标题上边距(也当无message时的下边距)
static const CGFloat TitleMarginLeft        = 20.0;     //标题左边距
static const CGFloat MessageMarginTop       = 18.0;     //title和message间距
static const CGFloat MessageMarginBottom    = 20.0;     //message和横线间距
static const CGFloat MessageMarginLeft      = 15.0;     //alert内容左边距
static const CGFloat TopHeightMin           = 70.0;     //上半部分最小高度
static const CGFloat NormalButtonHeight     = 46.0;     //标准alert 按钮高度(左右两个的时候)
static const CGFloat ButtonsCellHeight      = 50.0;     //多个按钮alert 按钮列表cell高度
static const CGFloat ButtonsButtonHeight    = 40.0;     //多个按钮alert 按钮高度
static const CGFloat ButtonsLeftMargin      = 20.0;     //按钮列表 按钮左边距
static const CGFloat ButtonsGap             = 10.0;     //按钮列表上边距


@interface ZEROAlertFrameManager()

@property (nonatomic)         ZEROAlertViewType type;
@property (nonatomic, copy)   NSString          *title;
@property (nonatomic, copy)   NSString          *message;
@property (nonatomic, strong) UIView            *customView;
@property (nonatomic, strong) NSArray           *buttons;
@property (nonatomic, strong) UIFont            *titleFont;
@property (nonatomic, strong) UIFont            *messageFont;

@property (nonatomic) CGFloat alertWidthMax;
@property (nonatomic) CGFloat alertHeigthtMax;

@property (nonatomic, readwrite) CGFloat alertWidth;
@property (nonatomic, readwrite) CGFloat alertHeight;
@property (nonatomic, readwrite) CGFloat customViewHeight;
@property (nonatomic, readwrite) CGRect  customViewFrame;
@property (nonatomic, readwrite) CGFloat buttonsListCellHeight;

@end

@implementation ZEROAlertFrameManager

- (instancetype)initWithType:(ZEROAlertViewType)type title:(NSString *)title titleFont:(UIFont *)titleFont message:(NSString *)message messageFont:(UIFont *)messageFont customView:(UIView *)customView buttons:(NSArray *)buttons{
    
    if (self = [super init]) {
        
        self.type        = type;
        self.title       = title;
        self.titleFont   = titleFont;
        self.message     = message;
        self.messageFont = messageFont;
        self.customView  = customView;
        self.buttons     = buttons;
        
        self.alertWidthMax          = WIDTH  - AlertGap * 2;
        self.alertHeigthtMax        = HEIGHT - AlertGap * 2;
        self.customViewFrame        = _customView.frame;
        self.customViewHeight       = _customView.frame.size.height;
        self.buttonsListCellHeight  = ButtonsCellHeight;
        
        [self alertWidth];
        [self calculateTitleLabelFrame];
        [self calculateMessageLabelFrame];
        [self calculateContentScrollViewFrame];
        [self calculateHorizontalLineFrame];
        [self calculateVerticalLineFrame];
        [self calculateButtonsListFrame];
    }
    return self;
}

#pragma mark - get method

- (CGFloat)alertWidth{
    
    if (!_alertWidth) {
        
        if (_customView) {
            
            _alertWidth = _customView.width;
            if (_alertWidth > _alertWidthMax) {
                
                _alertWidth = _alertWidthMax;
            }
        }
        else{
            
            _alertWidth = AlertDefaultWidth;
        }
    }
    return _alertWidth;
}

- (CGFloat)alertHeight{
    
    switch (_type) {
        case ZEROAlertViewTypeDefault:
            
            return _verticalLineFrame.origin.y + _verticalLineFrame.size.height;
            break;
        case ZEROAlertViewTypeButtons:
            
            if (_buttons.count == 0 && _title == nil && _message == nil) {
                
                return AlertGap;
            }
            if (_buttons.count == 0) {
                
                return _contentScrollViewFrame.origin.y + _contentScrollViewFrame.size.height;
            }
            
            return _buttonsListFrame.origin.y + _buttonsListFrame.size.height + ButtonsGap / 2.0;
            break;
        case ZEROAlertViewTypeCustomDefault:
            
            return _verticalLineFrame.origin.y + _verticalLineFrame.size.height;
            break;
        case ZEROAlertViewTypeCustomButtons:
            
            if (_buttons.count == 0 && _customView == nil) {
                
                return AlertGap;
            }
            if (_buttons.count == 0) {
                
                return _contentScrollViewFrame.origin.y + _contentScrollViewFrame.size.height;
            }
            
            return _buttonsListFrame.origin.y + _buttonsListFrame.size.height + ButtonsGap / 2.0;
            break;
        default:
            break;
    }
}

- (CGRect)customViewFrame{
    
    return CGRectMake(0, 0, _alertWidth, _customViewHeight);
}

/**
 * @brief 计算标题title的frame
 */
- (void)calculateTitleLabelFrame{
    
    CGFloat top         = 0.0;
    CGFloat TitleWidth  = _alertWidth - TitleMarginLeft * 2;
    CGFloat titleHeight = [_title heightWithStringFont:_titleFont fixedWidth:TitleWidth];
    
    if (titleHeight > 0) {
        
        top = TitleMarginTop;
    }
    
    _titleLabelFrame = CGRectMake(TitleMarginLeft, top, TitleWidth, titleHeight);
}


/**
 * @brief 计算内容message的frame
 */
- (void)calculateMessageLabelFrame{
    
    CGFloat MessageWidth  = _alertWidth - MessageMarginLeft * 2;
    CGFloat messageHeight = [_message heightWithStringFont:_messageFont fixedWidth:MessageWidth];
    CGFloat top           = 0.0;
    
    if (_titleLabelFrame.size.height > 0) {
        // -----如果title不为nil
        if (messageHeight > 0) {
            // -----message不为nil，message的originY就是 MessageMarginTop的1/2(另一半是contentScroll的originY)
            top = MessageMarginTop / 2.0;
        }
        else{
            
            [self configTitleFrame];
        }
    }
    else{
        // -----如果title为nil，message不为nil时，messageLabel的originY为 3/4(另 1/4 是contentScroll的originY)
        if (messageHeight > 0) {
            
            top = MessageMarginTop / 2.0 + MessageMarginTop / 4.0;
        }
    }
    
    _messageLabelFrame = CGRectMake(MessageMarginLeft, top, MessageWidth, messageHeight);
}


/**
 * @brief 在只有title，没有message的时候，根据TopHeightMin更新下title的高度
 */
- (void)configTitleFrame{
    
    CGFloat titleHeight = _titleLabelFrame.size.height;
    
    // -----message为nil，message高度为0时，调整titleLabel的高度，判断是否小于最小高度
    if (titleHeight < (TopHeightMin - TitleMarginTop * 2)) {
        
        _titleLabelFrame.size.height = TopHeightMin - TitleMarginTop * 2;
    }
}


/**
 * @brief 计算contentScroll的frame
 */
- (void)calculateContentScrollViewFrame{
    
    CGFloat top           = 0.0;
    CGFloat height        = 0.0;
    CGFloat contentHeight = 0.0;
    CGFloat messageHeight = _messageLabelFrame.size.height;
    CGFloat messageBottom = _messageLabelFrame.origin.y + messageHeight;
    switch (_type) {
        case ZEROAlertViewTypeDefault:{
            
            top = [self contentScrollViewTop];
            
            if (messageHeight > 0) {
                
                height = messageBottom + MessageMarginBottom;
                if (height > (_alertHeigthtMax - top - NormalButtonHeight)) {
                    
                    height = _alertHeigthtMax - top - NormalButtonHeight;
                }
            }
            
            if (messageHeight > 0) {
                
                contentHeight = messageBottom + MessageMarginBottom;
            }
        }
            break;
        case ZEROAlertViewTypeButtons:{
            
            top = [self contentScrollViewTop];
            if (messageHeight > 0) {
                
                
                height = [self configCustomScrollHeight:messageBottom top:top];
            }
            if (messageHeight > 0) {
                
                contentHeight = messageBottom;
            }
        }
            break;
        case ZEROAlertViewTypeCustomDefault:{
            
            height = _customView.height;
            if (height > _alertHeigthtMax - NormalButtonHeight) {
                
                height = _alertHeigthtMax - NormalButtonHeight;
            }
            contentHeight = _customView.height;
        }
            break;
        case ZEROAlertViewTypeCustomButtons:{
            
            height = [self configCustomScrollHeight:_customView.height top:top];;
            contentHeight = _customView.height;
        }
            break;
        default:
            break;
    }
    
    _contentScolllViewContentSize = CGSizeMake(_alertWidth, contentHeight);
    _contentScrollViewFrame = CGRectMake(0, top, _alertWidth, height);
    
    [self configCustomScrollFrame];
}


/**
 * @brief 在只有message，没有title的时候，根据TopHeightMin更新下message和contentScroll的高度
 */
- (void)configCustomScrollFrame{
    
    if (_type == ZEROAlertViewTypeDefault || _type == ZEROAlertViewTypeButtons) {
        // -----无title时
        if (_title == nil && _message) {
            
            CGFloat customScrollBottom = _contentScrollViewFrame.origin.y + _contentScrollViewFrame.size.height;
            
            if (customScrollBottom < TopHeightMin) {
                // -----height < TopHeightMin, 更新下坐标
                _messageLabelFrame            = CGRectMake(0, 0, _alertWidth, TopHeightMin);
                _contentScolllViewContentSize = CGSizeMake(_alertWidth, TopHeightMin);
                _contentScrollViewFrame       = CGRectMake(0, 0, _alertWidth, TopHeightMin);
            }
        }
    }
}


/**
 @brief 根据button的个数，对contentScrollView的高度进行更新
 
 @param height contentScrollView's height
 @param top    contentScrollView's top
 
 @return contentScrollView's height(new)
 */
- (CGFloat)configCustomScrollHeight:(CGFloat)height top:(CGFloat)top{
    
    
    if (_buttons.count <= 0) {
        // -----如果按钮个数为0
        if (height + top > _alertHeigthtMax) {
            
            return _alertHeigthtMax - top;
        }
        else{
            
            return height;
        }
    }
    
    // -----下半部分高度(按钮列表+ButtonGap)
    CGFloat bottomtHeight = _buttons.count * ButtonsCellHeight + ButtonsGap;
    
    // -----总高度 > 允许最大高度的时候
    if (top + height + bottomtHeight > _alertHeigthtMax) {
        
        // -----如果上半部分 > 允许最大高度的一半
        if (top + height > (_alertHeigthtMax / 2.0)) {
            
            // -----下半部分 > 允许最大高度的一半(上下两部分都 > 允许最大高度的一半)
            if (bottomtHeight > (_alertHeigthtMax / 2.0)) {
                
                return _alertHeigthtMax / 2.0 - top;
            }
            else{
                // -----下半部分 <= 允许最大高度的一半
                return _alertHeigthtMax - bottomtHeight - top;
            }
        }
    }
    return height;
}

/**
 * @brief 根据titleLabel的frame、messageLabel的frame，计算contentScroll的top
 * @return contentScroll's top
 */
- (CGFloat)contentScrollViewTop{
    
    CGFloat top           = 0.0;
    CGFloat titleHeight   = _titleLabelFrame.size.height;
    CGFloat titleBottom   = _titleLabelFrame.origin.y + titleHeight;
    CGFloat messageHeight = _messageLabelFrame.size.height;
    
    if (titleHeight > 0) {
        
        if (messageHeight > 0) {
            
            top = titleBottom + MessageMarginTop / 2.0;
        }
        else{
            
            top = titleBottom + TitleMarginTop;
        }
    }
    else{
        // -----1/4是为了视图美观。。。。。。。
        top = messageHeight > 0 ? MessageMarginTop / 4.0 : 0;
    }
    
    return top;
}


/**
 * @brief 计算横线的frame
 */
- (void)calculateHorizontalLineFrame{
    
    CGFloat contentScrollViewBottom = _contentScrollViewFrame.origin.y + _contentScrollViewFrame.size.height;
    
    CGFloat top    = contentScrollViewBottom > 0 ? contentScrollViewBottom : 0;
    CGFloat height = contentScrollViewBottom > 0 ? 1 : 0;
    
    _horizontalLineFrame = CGRectMake(0, top, _alertWidth, height);
}

/**
 * @brief 计算竖线的frame
 */
- (void)calculateVerticalLineFrame{
    
    CGFloat horizontalLineHeight = _horizontalLineFrame.size.height;
    CGFloat horizontalLineBottom = _horizontalLineFrame.origin.y + horizontalLineHeight;
    
    CGFloat top = horizontalLineHeight > 0 ? horizontalLineBottom : 0;
    
    _verticalLineFrame = CGRectMake(_alertWidth / 2.0 - 0.5, top, 1, NormalButtonHeight);
}

/**
 * @brief 计算两个按钮时，左右两个按钮的frame
 */
- (CGRect)calculateNormalButtonFrame:(NSInteger)idx{
    
    CGFloat horizontalLineHeight = _horizontalLineFrame.size.height;
    CGFloat horizontalLineBottom = _horizontalLineFrame.origin.y + horizontalLineHeight;
    
    CGFloat top = horizontalLineHeight > 0 ? horizontalLineBottom : 0;
    
    return CGRectMake(idx * (_alertWidth / 2.0 + 1),top, _alertWidth / 2.0 - 0.5, NormalButtonHeight);
}

/**
 @brief 在AlertViewType = 1,3 时，buttonTableView的坐标
 */
- (void)calculateButtonsListFrame{
    
    CGFloat contentScrollViewBottom = _contentScrollViewFrame.origin.y + _contentScrollViewFrame.size.height;
    CGFloat horizontalLineBottom    = _horizontalLineFrame.origin.y + _horizontalLineFrame.size.height;
    
    if (_buttons.count <= 0) {
        
        _buttonsListFrame = CGRectMake(0, horizontalLineBottom, _alertWidth, 0);
        return;
    }
    
    CGFloat top    = horizontalLineBottom > 0 ? horizontalLineBottom + ButtonsGap / 2.0 : ButtonsGap / 2.0;
    CGFloat height = ButtonsCellHeight * _buttons.count;
    
    if (ButtonsGap + height + contentScrollViewBottom > _alertHeigthtMax) {
        
        height = _alertHeigthtMax - contentScrollViewBottom - ButtonsGap;
        
        // -----如果下半部分高度 小于 Alert最大高度的一半(上高下矮)，tableView不可滑动
        if (height + ButtonsGap < _alertHeigthtMax / 2.0) {
            
            _buttonsListScrollEnabled = NO;
        }
        else{
            
            _buttonsListScrollEnabled = YES;
        }
    }
    
    _buttonsListFrame = CGRectMake(0, top, _alertWidth, height);
}


- (CGRect)calculateButtonListButtonFrame{
    
    return CGRectMake(ButtonsLeftMargin, (ButtonsCellHeight - ButtonsButtonHeight) / 2.0, _alertWidth - ButtonsLeftMargin * 2, ButtonsButtonHeight);
}
@end
