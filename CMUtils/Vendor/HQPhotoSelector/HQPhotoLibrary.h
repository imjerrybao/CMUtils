//
//  PhotoLibrary.h
//  seafishing2
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define HQPHOTO_LIBARARY ([HQPhotoLibrary sharedInstance])
@interface HQPhotoLibrary : NSObject
+ (HQPhotoLibrary *)sharedInstance;

/**
 *  设置图片选择上限
 *
 *  @param toplimit 上限
 */
- (void)setPhotoToplimit:(int)toplimit;

/**
 *  返回图片选择上限
 *
 *  @return 上限
 */
- (int)photoToplimit;

/**
 *  返回系统资源库
 *
 *  @return 资源库
 */
- (ALAssetsLibrary *)assetsLibrary;

/**
 *  已选择的图片
 */
@property (nonatomic,strong) NSMutableArray *selectedPhoto;

/**
 *  网络图片
 */
@property (nonatomic,strong) NSMutableArray *netPhoto;
/**
 *  已选照片的url hash列表
 */
@property (nonatomic,strong) NSMutableDictionary *existsHash;

/**
 *  判断选择的照片是否超过限制
 *
 *  @return 是否超出
 */
- (BOOL)limitExceeded;
/**
 *  判断资源是否被勾选
 *
 *  @param asset 资源
 *  @param assetHandle 是否添加或者删除assetHandle
 *  @return 是否
 */
- (BOOL)assetExistsWithAsset:(id)asset assetHandle:(BOOL)assetHandle;

/**
 *  清除所有数据
 */
- (void)cleanData;

/**
 *  已选则
 *
 *  @return 已选图片数量
 */
- (int)selectedCount;
@end
