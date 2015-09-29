//
//  UIImageView+imageId.h
//  iBoost
//
//  Created by Jerry on 13-12-5.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (imageId)

- (void)setImageWithImageId:(NSString *)imageId placeHolder:(UIImage *)image;
- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage;
- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage
                 beforeHook:(void (^)(UIImage *))hook;
- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage
                 beforeHook:(void (^)(UIImage *))hook
                  afterHook:(void (^)(UIImage *))afterhook;
- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage
              progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
                 beforeHook:(void (^)(UIImage *))hook afterHook:(void (^)(UIImage *))afterhook;
- (void)cancelDownload;

/**
 *  按比例请求一个图片
 *
 *  @param imageId          imageId
 *  @param scaleSize        图片尺寸,最终会乘以屏幕比例
 *  @param placeHolderImage 默认图片
 */
- (void)setImageWithImageId:(NSString *)imageId scaleSize:(CGSize)scaleSize placeHolder:(UIImage *)placeHolderImage;
/**
 *  生成圆角图片
 *
 *  @param imageId          图片id
 *  @param size             图片size
 *  @param placeHolderImage 默认图
 *  @param cornerRadius     圆角半径
 */
- (void)setImageWithImageId:(NSString *)imageId
                placeHolder:(UIImage *)placeHolderImage
               cornerRadius:(CGFloat)cornerRadius;
@end
