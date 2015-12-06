//
//  APIClient+image.h
//  CMUtils
//
//  Created by LiuHuanQing on 15/3/20.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "APIClient.h"

typedef void(^imageHandlerSuccess)(NSString *imageId, UIImage *image);
typedef void(^imageHandlerFailure)(NSHTTPURLResponse *response ,NSError *error);

@interface APIClient (image)
//图片存储路径
- (NSString *)imageRootPath;

//获取图片存储路径
- (NSString *)getPathForImage:(NSString *)imageId;
- (NSString *)getPathForImage:(NSString *)imageId size:(CGSize)size;

//删除图片
- (BOOL)deleteImageWithId:(NSString *)imageId;
- (BOOL)deleteImageWithId:(NSString *)imageId size:(CGSize)size;

//下载图片
- (void)downloadImage:(NSString *)imageId success:(imageHandlerSuccess)success failure:(fHandler)failure;
- (void)downloadImage:(NSString *)imageId size:(CGSize)size success:(imageHandlerSuccess)success failure:(fHandler)failure;

//通过图片Id获取图片，先缓存，没缓存再下载。
- (void)getImageWithId:(NSString *)imageId success:(imageHandlerSuccess)success failure:(fHandler)failure;
- (void)getImageWithId:(NSString *)imageId size:(CGSize)size success:(imageHandlerSuccess)success failure:(fHandler)failure;

//上传图片
- (void)uploadImage:(NSData *)imageData success:(void(^)(NSString *imageId))success failure:(fHandler)failure;

/**
 *  通过ImageId上传图片,并检查是否已上传
 *
 *  @param newImageId 新的图片ID
 *  @param success 成功
 *  @param failure 失败
 */
- (void)uploadImageWithImageId:(NSString *)imageId success:(void(^)(NSString *newImageId))success failure:(fHandler)failure;

/**
 *  批量上传图片 使用HQAsset
 *
 *  @param assets   HQAsset数组
 *  @param complete 完成回调
 */
- (void)multiUploadImageWithHQAsset:(NSArray *)assets complete:(void(^)(NSArray *imageIds,NSArray *failImageIds))complete;

/**
 *  批量上传图片
 *
 *  @param imageIds 图片ID数组
 *  @param complete 完成回调
 */

- (void)multiUploadImageWithImageIds:(NSArray *)imageIds complete:(void(^)(NSArray *imageIds,NSArray *failImageIds))complete;

/**
 *  批量上传图片
 *
 *  @param imageIds     图片ID数组
 *  @param successMaps  **使用时无需关心,请传nil
 *  @param failImageIds **使用时无需关心,请传nil
 *  @param complete     完成回调
 */
- (void)multiUploadImageWithImageId:(NSArray *)imageIds
                        successMaps:(NSMutableDictionary *)successMaps
                       failImageIds:(NSMutableArray *)failImageIds
                           complete:(void(^)(NSDictionary *imageIdMaps,NSArray *failImageIds))complete;
//检测图片是否存在
- (void)checkExist:(NSString *)MD5 sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler;

//清空缓存
- (void)clearCache;
//获取缓存大小
- (long long)getCacheSize;

/**
 *  保存图片
 *
 *  @param image 图片Image
 *
 *  @return 图片id
 */
- (NSString *)saveImage:(UIImage *)image;

/**
 *  保存图片 指定图片size
 *
 *  @param image 图片
 *  @param size  图片size
 *
 *  @return 图片id
 */
- (NSString *)saveImage:(UIImage *)image size:(CGSize)size;
/**
 *  替换旧的图片
 *
 *  @param image 图片Image
 *  @param imageId 图片URL
 *  @param size    size
 *
 *  @return 图片id
 */
- (NSString *)saveImage:(UIImage *)image imageId:(NSString *)imageId size:(CGSize)size;


/**
 *  修改图片imageId
 *
 *  @param imageId    旧的imageId
 *  @param newFilename 新的imageId
 *  @param size        图片尺寸
 */
- (void)modifyImageId:(NSString *)imageId newImageId:(NSString *)newImageId size:(CGSize)size;

// 返回image的url路径, size是CGSizeZero时下载完整图片
- (NSString *)imageUrlForId:(NSString *)imageId size:(CGSize)size;


- (UIImage *)getCachedImageById:(NSString *)imageId;
- (UIImage *)getCachedImageById:(NSString *)imageId size:(CGSize)size;
- (void)getCachedImageById:(NSString *)imageId size:(CGSize)size finish:(void(^)(UIImage *image))result;
@end
