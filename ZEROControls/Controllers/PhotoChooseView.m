//
//  PhotoChooseView.m
//  ZEROControls
//
//  Created by ZWX on 2016/12/3.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "PhotoChooseView.h"
#import "UIButton+WebCache.h"
#import "ZEROSheetView.h"

static const NSInteger photoButtonTag = 100;

@interface PhotoChooseView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    // 用于赋值CGPoint
    CGPoint valuePoint;
    // 开始拖动的view的下一个view的CGPoint（如果开始位置是0 结束位置是4 nextPoint值逐个往下算）
    CGPoint nextPoint;
}
@property (nonatomic, strong) NSMutableArray      <UIButton *>*photoButtonArray;
@property (nonatomic, strong) NSMutableArray      *photoFrameArray;
@property (nonatomic, strong) NSMutableArray      <UIImage *>*photoArray;
@property (nonatomic, strong) NSMutableDictionary *photoDic;

@end

@implementation PhotoChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoButtonArray = [NSMutableArray array];
        self.photoArray       = [NSMutableArray array];
        self.photoFrameArray  = [NSMutableArray array];
        self.photoDic         = [NSMutableDictionary dictionary];
    
        [self createPhotoButtons];
    }
    return self;
}

#pragma mark - ---- set method ----

- (void)setPhotos:(NSArray *)photos{
    
    _photos = photos;
    [_photoArray removeAllObjects];
    
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx >= _photoButtonArray.count) {
            *stop = YES;
        }
        UIButton *photoButton = _photoButtonArray[idx];
        if ([obj isKindOfClass:[UIImage class]]) {
            // -----images
            [photoButton setImage:obj forState:UIControlStateNormal];
            [_photoArray addObject:obj];
        }
        else if ([obj isKindOfClass:[NSString class]]){
            // -----strings
            if ([obj hasPrefix:@"http"]) {
                // -----url string
                [photoButton sd_setImageWithURL:[NSURL URLWithString:obj]
                                       forState:UIControlStateNormal
                               placeholderImage:[UIImage imageNamed:@"placeholder"]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          
                                          if (image) {
                                              
                                              [_photoArray addObject:image];
                                          }
                                          else{
                                              
                                              [_photoArray addObject:[UIImage imageNamed:@"placeholder"]];
                                          }
                                      }];
            }else{
                // -----image name
                if ([UIImage imageNamed:obj]) {
                    
                    [photoButton setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
                    [_photoArray addObject:[UIImage imageNamed:obj]];
                }
            }
        }else if ([obj isKindOfClass:[NSURL class]]){
            // -----url
            [photoButton sd_setImageWithURL:obj
                                   forState:UIControlStateNormal
                           placeholderImage:[UIImage imageNamed:@"placeholder"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                      if (image) {
                                          
                                          [_photoArray addObject:image];
                                      }
                                      else{
                                          
                                          [_photoArray addObject:[UIImage imageNamed:@"placeholder"]];
                                      }
                                  }];
        }
    }];
}

#pragma mark - ---- get method ----
- (NSArray *)currentPhotos{
    
    return _photoArray;
}

#pragma mark - ---- create method ----
#pragma mark buttons
- (void)createPhotoButtons{
    
    [self calculatePhotoFrames];
    
    for (NSInteger idx = 0; idx < 6; idx ++) {
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        photoButton.frame                 = CGRectFromString(_photoFrameArray[idx]);
        photoButton.backgroundColor       = UIColorRGBA(189, 187, 191, 1);
        photoButton.layer.cornerRadius    = 3;
        photoButton.layer.masksToBounds   = YES;
        photoButton.tag                   = photoButtonTag + idx;
        photoButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [photoButton setImage:[UIImage imageNamed:@"photo_upload_add"] forState:UIControlStateNormal];
        [photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [photoButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(photoLongPress:)]];
        
        [self addSubview:photoButton];
        
        [_photoButtonArray addObject:photoButton];
    }
}

/**
 @brief 计算6个图片按钮frame
 */
- (void)calculatePhotoFrames{
    
    NSInteger photoIdx  = 0;
    CGFloat littleWidth = (WIDTH - 20) / 3;
    CGFloat bigWidth    = littleWidth * 2;
    CGRect bigFrame     = CGRectMake(10, 10, bigWidth - 1, bigWidth - 1);
    
    [_photoFrameArray addObject:NSStringFromCGRect(bigFrame)];
    photoIdx ++;
    
    for (NSInteger idx = photoIdx; idx < 2 + photoIdx; idx ++) {
        
        CGRect frame = CGRectMake(bigFrame.origin.x + bigFrame.size.width + 2, bigFrame.origin.y + littleWidth * (idx - photoIdx), littleWidth - 1, littleWidth - 1);
        
        [_photoFrameArray addObject:NSStringFromCGRect(frame)];
    }
    photoIdx += 2;
    
    for (NSInteger idx = photoIdx; idx < 3 + photoIdx; idx ++) {
        
        CGRect frame = CGRectMake(10 + littleWidth * (2 - (idx - photoIdx)), bigFrame.origin.y + bigFrame.size.height + 2, littleWidth - 1, littleWidth - 1);
        
        [_photoFrameArray addObject:NSStringFromCGRect(frame)];
    }
}

#pragma mark - ---- configer method ----
#pragma mark 

/**
 * @brief 在添加、删除新图片之后，更新图片按钮的显示图片
 */
- (void)configerPhotoButtonImage{
    
    [_photoButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *photoButton = [self viewWithTag:idx + photoButtonTag];
        // -----这样写是为了在拖动之后，保证图片按钮顺序（拖动之后，_photoButtonArray顺序并没有改变）
        if (_photoArray.count > idx) {
            
            [photoButton setImage:_photoArray[idx] forState:UIControlStateNormal];
        }
        else{
            
            [photoButton setImage:[UIImage imageNamed:@"photo_upload_add"] forState:UIControlStateNormal];
        }
    }];
}


/**
 * @brief 在图片拖动，顺序更改之后，更新图片数组的顺序
 */
- (void)configPhotoArrayImage{
    
    NSMutableArray *photos = [NSMutableArray array];
    [_photoArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull photo, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *photoButton = [self viewWithTag:idx + photoButtonTag];
        [photos addObject:photoButton.imageView.image];
    }];
    
    _photoArray = [NSMutableArray arrayWithArray:photos];
}

#pragma mark - ---- event method ----
#pragma mark button click

- (void)photoButtonClick:(UIButton *)sender{
    
    [[[ZEROSheetView alloc] initWithTitle:nil cancelButtonTitle:@"Cancel" click:^(NSInteger index) {
        
        if (index == 1 || index == 2) {
            
            [self clickActionWithIndex:index];
        }
        if (index == 3 && _photoArray.count > (sender.tag - photoButtonTag)) {
            // -----点击删除之后，从图片数组中删除该图片，更新图片按钮显示图片
            [_photoArray removeObjectAtIndex:sender.tag - photoButtonTag];
            [self configerPhotoButtonImage];
        }
    } otherButtonTitles:@"拍摄", @"照片库", @"删除", nil] show];
}

- (void)clickActionWithIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    picker.allowsEditing            = YES;
    
    if (buttonIndex == 1) {
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    [[self getCurrentViewController] presentViewController:picker animated:YES completion:nil];
}

- (UIViewController *)getCurrentViewController{
    
    UIResponder *next = [self nextResponder];
    do {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

#pragma mark gesture
- (void)photoLongPress:(UILongPressGestureRecognizer *)sender{
    
    CGFloat littleWidth = (WIDTH - 20) / 3;
    CGFloat bigWidth    = littleWidth * 2;
    
    UIButton *photoButton = (UIButton *)sender.view;
    
    if (_photoArray.count <= photoButton.tag - photoButtonTag) {
        // -----当长按图片数组之外的按钮时，无反应
        return;
    }
    
    [_photoButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // -----其他图片按钮不可响应
        if (obj != photoButton) {
            
            obj.userInteractionEnabled = NO;
        }
    }];
    
    // ----- 手势相应控件在父视图中的位置（触摸点位置）
    CGPoint recognizerPoint = [sender locationInView:self];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        // ----- valuePoint保存最新的移动位置
        valuePoint = photoButton.center;

        // ----- 开始的时候改变拖动view的外观（放大，改变颜色等）
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat scale = photoButton.tag == photoButtonTag ? littleWidth / bigWidth * 0.8 : 0.8;
            photoButton.transform = CGAffineTransformMakeScale(scale, scale);
            photoButton.alpha = 0.7;
            // ----- 更新pan.view的center
            photoButton.center = recognizerPoint;
        }];
        
        // ----- 把拖动view放到最上层
        [self bringSubviewToFront:photoButton];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged){
        
        // ----- 更新pan.view的center
        photoButton.center = recognizerPoint;
        
        for (UIButton * bt in _photoButtonArray) {
            
            // ----- 判断是否移动到另一个view区域
            // CGRectContainsPoint(rect,point) 判断某个点是否被某个frame包含
            if (CGRectContainsPoint(bt.frame, photoButton.center) && bt != photoButton)
            {
                if (_photoArray.count > bt.tag - photoButtonTag) {

                    // ----- 开始位置
                    NSInteger fromIndex = photoButton.tag - photoButtonTag;
                    
                    // ----- 需要移动到的位置
                    NSInteger toIndex = bt.tag - photoButtonTag;
//                    NSLog(@"开始位置=%ld  结束位置=%ld",fromIndex,toIndex);
                    
                    // ----- 往后移动
                    if ((toIndex - fromIndex) > 0) {
                        
                        // ----- 从开始位置移动到结束位置
                        // ----- 把移动view的下一个view移动到记录的view的位置(valuePoint)，并把下一view的位置记为新的nextPoint，更新valuePoint，并把view的tag值-1,依次类推
                        [UIView animateWithDuration:0.2 animations:^{
                            for (NSInteger i = fromIndex + 1; i <= toIndex; i++) {
                                UIButton * nextBt = (UIButton*)[self viewWithTag:photoButtonTag+i];
                                nextPoint = nextBt.center;
                                nextBt.tag--;
                                
                                if (nextBt.tag == photoButtonTag) {
                                    nextBt.frame = CGRectMake(nextBt.frame.origin.x, nextBt.frame.origin.y, bigWidth - 1, bigWidth - 1);
                                }
                                nextBt.center = valuePoint;
                                valuePoint = nextPoint;
                                
                            }
                            photoButton.tag = photoButtonTag + toIndex;
                        }];
                    }
                    // ----- 往前移动
                    else{
                        // ----- 把移动view的上一个view移动到记录的view的位置(valuePoint)，并把上一view的位置记为新的nextPoint，并把view的tag值+1,依次类推
                        [UIView animateWithDuration:0.2 animations:^{
                            for (NSInteger i = fromIndex - 1; i >= toIndex; i--) {
                                UIButton * nextBt = (UIButton*)[self viewWithTag:photoButtonTag+i];
                                nextPoint = nextBt.center;
                                
                                nextBt.tag++;
                                
                                if (nextBt.tag == photoButtonTag) {
                                    nextBt.frame = CGRectMake(nextBt.frame.origin.x, nextBt.frame.origin.y, bigWidth - 1, bigWidth - 1);
                                }else
                                    nextBt.frame = CGRectMake(nextBt.frame.origin.x, nextBt.frame.origin.y, littleWidth - 1, littleWidth - 1);
                                nextBt.center = valuePoint;
                                valuePoint = nextPoint;
                                
                            }
                            photoButton.tag = photoButtonTag + toIndex;
                        }];
                    }
                }
            }
        }
    }else if(sender.state == UIGestureRecognizerStateEnded){
        
        [self configPhotoArrayImage];
        // ----- 恢复其他按钮的拖拽手势
        for (UIButton * bt in _photoButtonArray) {
            if (bt!=photoButton) {
                bt.userInteractionEnabled = YES;
            }
        }
        
        // ----- 结束时候恢复view的外观（放大，改变颜色等）
        [UIView animateWithDuration:0.2 animations:^{
            photoButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
            photoButton.alpha = 1;
            
            if (photoButton.tag == photoButtonTag) {
                
                photoButton.frame = CGRectMake(photoButton.frame.origin.x, photoButton.frame.origin.y, bigWidth - 1, bigWidth - 1);
            }else
                photoButton.frame = CGRectMake(photoButton.frame.origin.x, photoButton.frame.origin.y, littleWidth - 1, littleWidth - 1);
            photoButton.center = valuePoint;
            
        }];
    }
}

#pragma mark - ---- delegate method ----
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_photoArray addObject:image];
    [self configerPhotoButtonImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
