//
//  MarqueeCell.m
//  MarqueeControl
//
//  Created by ZWX on 2019/1/14.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import "MarqueeCell.h"
#import "MarqueeModel.h"

@implementation MarqueeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadContent {
    
    _contentLabel.text = self.dataModel.contentStr;
}

- (void)contentOffset:(CGPoint)point {
    
    
}

- (void)willDisplay {
    
    
}

- (void)didEndDisplaying {
    
    
}

@end
