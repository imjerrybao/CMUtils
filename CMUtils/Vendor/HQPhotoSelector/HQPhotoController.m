//
//  HQPhotoController.m
//  buddy
//
//  Created by LiuHuanQing on 15/7/24.
//  Copyright (c) 2015年 solot01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQPhotoController.h"
#import "HQPhotoAlbumNaView.h"
#import "PECropViewController.h"
#import "HQPhotoLibrary.h"
#import "HQAsset.h"
#import "StyledNavigaitonController.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/UIActionSheet+BlocksKit.h>
@interface HQPhotoController()<HQPhotoAlbumNaViewDelegate,PECropViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,weak) UIViewController *viewController;
@end

@implementation HQPhotoController
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initData];
    }
    return self;
}
- (instancetype)initWithSourceType:(HQPhotoUseType)photoType
{
    self = [super init];
    if (self)
    {
        self.photoType = photoType;
    }
    return self;
}

- (void)initData
{
    _limit = 1;
    _photoType = HQPhotoUseTypeAvatar;
}

//+ (HQPhotoController *)photoController:(HQPhotoUseType)photoType
//{
//    HQPhotoController *photo = [[HQPhotoController alloc] initWithSourceType:photoType];
//    return photo;
//}

//显示选择框
- (void)showActionSheet
{
    WEAK_SELF;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:Locale(@"HQPhotoSelector.uploadImage")];
    self.viewController = [wSelf visibleViewController];
    [actionSheet bk_addButtonWithTitle:Locale(@"app.takeAPicture") handler:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate                 = self;
        picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
        [wSelf.viewController presentViewController:picker animated:YES completion:nil];
    }];
    [actionSheet bk_addButtonWithTitle:Locale(@"app.selectInAlbum") handler:^{
        HQPhotoAlbumNaView *nav = [[HQPhotoAlbumNaView alloc] initWithToplimit:self.limit checkedPhoto:self.checkedPhoto delegate:self];
        [wSelf.viewController presentViewController:nav animated:YES completion:nil];
    }];
    [actionSheet bk_setCancelButtonWithTitle:Locale(@"watermark.dontAdd") handler:nil];
    [actionSheet showInView:UIKeyWindow];
}

//获得最后一层可见的视图控制器
- (UIViewController *)visibleViewController
{
    UIViewController *vc = nil;
    UIViewController *mainVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([mainVC isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabbarVC = (UITabBarController *)mainVC;
        UINavigationController *nav  = (UINavigationController *)tabbarVC.viewControllers[tabbarVC.selectedIndex];
        vc                           = nav.visibleViewController;
    }
    return vc;
}

- (void)editingImage:(UIImage *)image
{
    PECropViewController *controller  = [[PECropViewController alloc] init];
    controller.keepingCropAspectRatio = YES;
    controller.toolbarHidden          = YES;
    controller.cropAspectRatio        = 1.0f;
    controller.delegate               = self;
    controller.image                  = image;
    StyledNavigaitonController *nav       = [[StyledNavigaitonController alloc] initWithRootViewController:controller];
    [self.viewController presentViewController:nav animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] scaleMaxToFitSize:CGSizeMake(960, 960)];
    
    
    switch (self.photoType)
    {
        case HQPhotoUseTypeAvatar:
        {//头像模式存在编辑
            if(self.allowsEditing)
            {
                [self editingImage:image];
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingImage:)])
                {
                    [self.delegate didFinishPickingImage:image];
                }
            }
        }
            break;
        case HQPhotoUseTypeeWall:
        {//照片墙模式不存在编辑
            WEAK_SELF;
            if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingAssets:)])
            {
                [MBProgressHUD showHUDAddedTo:UIKeyWindow animated:YES];
                [[[HQPhotoLibrary sharedInstance] assetsLibrary] writeImageToSavedPhotosAlbum:image.CGImage metadata:[info objectForKey:UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL *assetURL, NSError *error)
                 {//照片保存成功的回调
                     [MBProgressHUD hideHUDForView:UIKeyWindow animated:YES];
                     
                     [[[HQPhotoLibrary sharedInstance] assetsLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset)
                     {//获得照片成功的回调
                         HQAsset *ass = [HQAsset HQAssetWithAsset:asset];
                         NSArray *array = nil;
                         if(wSelf.checkedPhoto)
                         {
                             array = [wSelf.checkedPhoto arrayByAddingObject:ass];
                         }
                         else
                         {
                             array = @[ass];
                         }
                         if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingAssets:)])
                         {
                             [self.delegate didFinishPickingAssets:array];
                         }
                      } failureBlock:^(NSError *error) {
                      }];
                }];
            }
            
        }
            break;
        default:
            break;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PECropViewControllerDelegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingImage:)])
    {
        [self.delegate didFinishPickingImage:croppedImage];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HQPhotoAlbumNaViewDelegate
- (void)photoAlbum:(HQPhotoAlbumNaView *)nav didFinish:(NSMutableArray *)photoArray
{
    switch (self.photoType)
    {
        case HQPhotoUseTypeAvatar:
        {//头像模式存在编辑
            HQAsset *asset = [photoArray lastObject];
            UIImage *image = asset.compressedImage;
            if(self.allowsEditing)
            {//编辑
                [nav dismissModalViewControllerAnimated:NO];
                [self editingImage:image];
            }
            else
            {//不编辑
                [self.delegate didFinishPickingImage:asset.compressedImage];
            }
        }
            break;
        case HQPhotoUseTypeeWall:
        {//照片墙模式不存在编辑
            if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingAssets:)])
            {
                [nav dismissModalViewControllerAnimated:YES];
                [self.delegate didFinishPickingAssets:photoArray];
            }
        }
            break;
        default:
            break;
    }
}

//- (void)photoAlbumDidFinish:(NSMutableArray *)photoArray
//{
//    switch (self.photoType)
//    {
//        case HQPhotoUseTypeAvatar:
//        {//头像模式存在编辑
//            HQAsset *asset = [photoArray lastObject];
//            if(self.allowsEditing)
//            {//编辑
//                [self editingImage:asset.compressedImage];
//            }
//            else
//            {//不编辑
//                [self.delegate didFinishPickingImage:asset.compressedImage];
//            }
//        }
//            break;
//        case HQPhotoUseTypeeWall:
//        {//照片墙模式不存在编辑
//            if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingAssets:)])
//            {
//                [self.delegate didFinishPickingAssets:photoArray];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//}


@end
