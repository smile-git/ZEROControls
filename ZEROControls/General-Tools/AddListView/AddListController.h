//
//  AddListController.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/18.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddSelectListItem;

typedef void(^AddListSelectCompletion)(NSInteger selectIndex);


@interface AddListController : UIViewController

+ (instancetype)addListControllerWithItems:(NSArray <AddSelectListItem *>*)items;

@property (nonatomic, strong) NSArray <AddSelectListItem *>*items;

@property (nonatomic, copy)   AddListSelectCompletion selectCompletion;

- (void)showInViewController:(UIViewController *)viewController completion:(void (^)(NSInteger selectIndex))completion;
@end
