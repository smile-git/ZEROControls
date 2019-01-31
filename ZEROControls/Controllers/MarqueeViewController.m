//
//  MarqueeViewController.m
//  ZEROControls
//
//  Created by ZWX on 2019/1/31.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import "MarqueeViewController.h"
#import "MarqueeControl.h"
#import "MarqueeModel.h"

@interface MarqueeViewController ()

@end

@implementation MarqueeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSArray *datas = @[@{@"contentStr": @"1 111111 111111111111 111111111", @"urlStr": @"www.baidu.com"},
                       @{@"contentStr": @"2 222222 222222222222 222222222 2222222222222 2222222222", @"urlStr": @"www.baidu.com"},
                       @{@"contentStr": @"3 333333 333333333333 333333333", @"urlStr": @"www.baidu.com"}];
    
    NSMutableArray *models = [NSMutableArray array];
    [datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MarqueeModel *model = [[MarqueeModel alloc] init];
        [model setValuesForKeysWithDictionary:obj];
        [models addObject:model];
    }];
    
    MarqueeControl *controlH = [[MarqueeControl alloc] initWithFrame:CGRectMake(10, 100, WIDTH - 20, 80) scrollDirection:UICollectionViewScrollDirectionHorizontal models:models];
    
    [self.view addSubview:controlH];
    
    [controlH startLoopAnimated:YES];
    
    MarqueeControl *controlV = [[MarqueeControl alloc] initWithFrame:CGRectMake(0, 300, WIDTH, 80) scrollDirection:UICollectionViewScrollDirectionVertical models:models];
    
    [self.view addSubview:controlV];
    
    [controlV startLoopAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
