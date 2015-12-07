//
//  HQPhotoController.h
//  buddy
//
//  Created by LiuHuanQing on 15/7/24.
//  Copyright (c) 2015年 solot01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
/**
 *  照片使用类型
 */
typedef NS_ENUM(NSInteger, HQPhotoUseType){
    /**
     *  头像使用,返回UIImage,代理didFinishPickingImage可用
     */
    HQPhotoUseTypeAvatar,
    /**
     *  照片墙中使用,返回HQAsset的NSArray,代理didFinishPickingAssets可用
     */
    HQPhotoUseTypeeWall,
};

@protocol HQPhotoControllerDelegate<NSObject>
@optional
- (void)didFinishPickingImage:(UIImage *)image;
- (void)didFinishPickingAssets:(NSArray *)Assets;
@end
@interface HQPhotoController : NSObject

@property (nonatomic,weak) id<HQPhotoControllerDelegate> delegate;

@property (nonatomic,assign) HQPhotoUseType photoType;

@property (nonatomic,assign) BOOL allowsEditing;        //照片允许编辑,默认NO,拍照才有有效

@property (nonatomic,assign) NSInteger limit;           //照片上限,默认是1 HQPhotoTypeWall类型有效

@property (nonatomic,weak)  NSArray *checkedPhoto;      //已选中的照片, HQPhotoTypeWall类型有效

- (instancetype)initWithSourceType:(HQPhotoUseType)photoType;

- (void)showActionSheet;
@end
