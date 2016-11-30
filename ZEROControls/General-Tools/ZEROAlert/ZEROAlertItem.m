//
//  ZEROAlertItem.m
//  Alert
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertItem.h"

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation ZEROAlertItem

- (instancetype)initWithText:(NSString *)text index:(NSInteger)index buttonType:(ZEROAlertViewButtonType)buttonType buttonFrame:(CGRect)buttonFrame{
    
    if (self = [super init]) {
        
        self.text        = text;
        self.index       = index;
        self.buttonType  = buttonType;
        self.buttonFrame = buttonFrame;
    }
    return self;
}

- (void)setButtonType:(ZEROAlertViewButtonType)buttonType{
    
    _buttonType = buttonType;
    
    switch (_buttonType) {
        case ZEROAlertViewButtonTypeNomalCancel:
            
            self.textColor       = UIColorRGBA(55, 52, 71, 1);
            self.backgroundColor = [UIColor whiteColor];
            
            break;
        case ZEROAlertViewButtonTypeNomalOK:
            
            self.textColor       = UIColorRGBA(251, 80, 114, 1);
            self.backgroundColor = [UIColor whiteColor];

            break;
        case ZEROAlertViewButtonTypeButtonsCancel:
            
            self.textColor       = UIColorRGBA(251, 80, 114, 1);
            self.backgroundColor = [UIColor whiteColor];
            self.layerColor      = UIColorRGBA(251, 80, 114, 1);

            break;
        case ZEROAlertViewButtonTypeButtonsDefault:
            
            self.textColor       = [UIColor whiteColor];
            self.backgroundColor = UIColorRGBA(251, 80, 114, 1);
            self.layerColor      = UIColorRGBA(251, 80, 114, 1);

            break;
        default:
            break;
    }
}
@end
