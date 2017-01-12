//
//  ZEROImagePickerController.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/27.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEROPhotoManager.h"
@class ZEROImagePickerController;

@protocol ZEROImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(ZEROImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;

- (void)imagePickerController:(ZEROImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos;

- (void)imagePickerControllerDidCancel:(ZEROImagePickerController *)picker;

- (void)imagePickerController:(ZEROImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset;

- (void)imagePickerController:(ZEROImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)sourceAssets;

@end

@interface ZEROImagePickerController : UINavigationController

#pragma mark - ---- init method ----

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<ZEROImagePickerControllerDelegate>)delegate;

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<ZEROImagePickerControllerDelegate>)delegate;

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<ZEROImagePickerControllerDelegate>)delegate isPushPhoto:(BOOL)isPushPhotoPicker;

/** * @brief This init method just for previewing photos / 用这个初始化方法预览图片 */
- (instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets selectedPhotos:(NSMutableArray *)selectedPhotos index:(NSInteger)index;

/** * @brief This init method for crop photo / 这个初始化方法裁剪图片 */
- (instancetype)initCropTypeWithAsset:(id)asset photo:(UIImage *)photo completion:(void (^)(UIImage *cropImage, id asset))completion;

// ----- 默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

// ----- 默认最小可选0张图片
@property (nonatomic, assign) NSInteger minImagesCount;

// ----- 默认每行照片个数< 2 --- 6 >
@property (nonatomic, assign) NSInteger columnNumber;

// ----- Default is YES 对照片按照修改时间排序，如果为NO，最新的照片会显示在最前面，内部的拍照按钮排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

// ----- Default is 828px
@property (nonatomic, assign) CGFloat photoWidth;

// ----- Default is 600px 图片预览中图片像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

// ----- Default is 15  读取照片超时时间，当读取照片超时未成功时，自动 dismiss HUD < 5 <-> 60 >
@property (nonatomic, assign) NSInteger hudTimeout;

// ----- Default is YES 如果设置为NO，原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

// ----- Default is YES 如果设置为NO，用户将不能选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;

// ----- Default is NO  如果设置为YES，用户可以选择gif图片
@property (nonatomic, assign) BOOL allowPickingGif;

// ----- Default is YES 如果设置为NO，用户将不能选择图片
@property (nonatomic, assign) BOOL allowPickingImage;

// ----- Default is YES 如果设置为NO，用户将不能选择拍照
@property (nonatomic, assign) BOOL allowTakePicture;

// ----- Default is YES 如果设置为NO，预览按钮将隐藏，用户将不能预览照片
@property (nonatomic, assign) BOOL allowPreviewImage;

// ----- Default is YES 如果设置为NO，照片选择器将不能自动dismiss
@property (nonatomic, assign) BOOL autoDismiss;


// ----- 用户选中过的图片数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray <ZEROAssetModel *> *selectedModels;

// ----- 最小可选中的图片的 宽 高, Default is 0, 小于这个狂傲的图片不可选
@property (nonatomic, assign) CGFloat minPhotoWidthSelectAble;
@property (nonatomic, assign) CGFloat minPHotoHeightSelectAble;

// ----- 隐藏不可选中的图片, Default is NO, 不推荐设置为YES
@property (nonatomic, assign) BOOL hideWhenCanNotSelect;

// ----- 在单选模式下，照片列表页中，显示选择按钮, Default is NO ; 也代表单选模式
@property (nonatomic, assign) BOOL showSelectBtn;

// ----- 允许裁剪, Default is YES, showSelectBtn为NO时有效
@property (nonatomic, assign) BOOL allowCrop;

// ----- 裁剪框尺寸
@property (nonatomic, assign) CGRect cropRect;

// ----- 需要圆形裁剪框
@property (nonatomic, assign) BOOL needCircleCrop;

// ----- 圆形裁剪框半径
@property (nonatomic, assign) NSInteger circleCropRadius;

// ----- 自定义裁剪框其他属性
@property (nonatomic, copy) void (^cropViewSettingHandle)(UIView *cropView);

// ----- 是否选择原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@property (nonatomic, weak) id<ZEROImagePickerControllerDelegate> pickerDelegate;

@property (nonatomic, copy) NSString *takePictureImageName;
@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;
@property (nonatomic, copy) NSString *photoOriginSelImageName;
@property (nonatomic, copy) NSString *photoOriginDefImageName;
@property (nonatomic, copy) NSString *photoPreviewOriginDefImageName;
@property (nonatomic, copy) NSString *photoNumberIconImageName;

@property (nonatomic, strong) UIColor *okBtnNormalTitleColor;
@property (nonatomic, strong) UIColor *okBtnDisableTitleColor;
@property (nonatomic, strong) UIColor *barItemTextColor;
@property (nonatomic, strong) UIFont  *barItemTextFont;

@property (nonatomic, copy) NSString *doneBtnTitleStr;
@property (nonatomic, copy) NSString *cancelBtnTitleStr;
@property (nonatomic, copy) NSString *previewBtnTitleStr;
@property (nonatomic, copy) NSString *fullImageBtnTitleStr;
@property (nonatomic, copy) NSString *settingBtnTitleStr;
@property (nonatomic, copy) NSString *processHintStr;

#pragma mark - ---- Public method ----

- (void)showAlertWithTitle:(NSString *)title;
- (void)showProgressHUD;
- (void)hideProgressHUD;


/** * @brief nav cancel click */
- (void)cancelButtonClick;

#pragma mark - ---- handle property ----
// ----- 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的handle
// ----- 你也可以设置autoDissmiss属性为NO，选择器就不会自己dismissle
// ----- 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// ----- 你可以通过一个asset获得原图，通过这个方法：[[ZEROPhotoManager shareManager] getOriginalPhotoWithAsset:completion:]
// ----- photos数组里的UIImage对象，默认是828像素宽，你可以通过photoWidth属性的值来改变它

/** * @brief 照片选择器 dismiss 时的回调 */
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray <UIImage *>*photos, NSArray *assets, BOOL isSelectOriginalPhoto);

@property (nonatomic, copy) void (^didFinishPickingPhotosWithInfosHandle)(NSArray <UIImage *>*photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray <NSDictionary *>*infos);

@property (nonatomic, copy) void(^imagePickerControllerDidCancelHandle)();

// ----- 如果用户选择了一个视频，下面的handle会被执行
@property (nonatomic, copy) void (^didFinishPickingVideoHandle)(UIImage *coverImage, id asset);

// ----- 如果用户选择了一个gif图片，下面的handle会被执行
@property (nonatomic, copy) void (^didFinishPickingGifImageHandle)(UIImage *animatedImage, id sourceAssets);
@end





























