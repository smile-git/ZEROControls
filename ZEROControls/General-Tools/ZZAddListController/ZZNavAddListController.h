//
//  ZZNavAddListController.h
//  NavAddList
//
//  Created by ZWX on 29/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectCompletion)(NSInteger selectedIndex);

@interface ZZNavAddListController : UIViewController

// ----- icon + title
+ (instancetype)navAddListControllerWithDictionarys:(NSArray <NSDictionary *>*)listDictionarys selectCompletion:(SelectCompletion)selectCompletion;

// ----- only title
+ (instancetype)navAddListControllerWithStrings:(NSArray <NSString *>*)listStrings selectCompletion:(SelectCompletion)selectCompletion;

// ----- icon + title and count
+ (instancetype)navAddListControllerWithDictionarys:(NSArray <NSDictionary *>*)listDictionarys maxListCount:(NSInteger)maxListCount selectCompletion:(SelectCompletion)selectCompletion;

// ----- 纯属娱乐。。。可以不用调用
+ (instancetype)navAddListControllerSelectCompletion:(SelectCompletion)selectCompletion listStrings:(NSString *)listString, ...NS_REQUIRES_NIL_TERMINATION;



- (void)showInViewController:(UIViewController *)viewController;

@end
