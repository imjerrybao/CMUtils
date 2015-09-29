//
//  UIImageView+imageId.m
//  iBoost
//
//  Created by Jerry on 13-12-5.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//
#import "APIClient+image.h"
#import "UIImageView+imageId.h"
#import "UIImageView+AFNetworking.h"
#import "CMUtils.h"
#define SCREEN_SCALE [UIScreen mainScreen].scale
@implementation UIImageView (imageId)

- (void)setImageWithImageId:(NSString *)imageId placeHolder:(UIImage *)placeHolderImage
{
    [self setImageWithImageId:imageId size:CGSizeZero placeHolder:placeHolderImage];
}

- (void)setImageWithImageId:(NSString *)imageId scaleSize:(CGSize)scaleSize placeHolder:(UIImage *)placeHolderImage {
    CGFloat scale = [UIScreen mainScreen].scale;
    [self setImageWithImageId:imageId size:CGSizeMake(scaleSize.width*scale, scaleSize.height*scale) placeHolder:placeHolderImage beforeHook:nil afterHook:nil];
}

- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage {
    [self setImageWithImageId:imageId size:size placeHolder:placeHolderImage beforeHook:nil afterHook:nil];
}

- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage
                 beforeHook:(void (^)(UIImage *))hook {
    [self setImageWithImageId:imageId size:size placeHolder:placeHolderImage beforeHook:hook afterHook:nil];
}

- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage
                 beforeHook:(void (^)(UIImage *))hook afterHook:(void (^)(UIImage *))afterhook {
    [self setImageWithImageId:imageId size:size placeHolder:placeHolderImage progressBlock:nil beforeHook:hook afterHook:afterhook];
}


- (void)setImageWithImageId:(NSString *)imageId size:(CGSize)size placeHolder:(UIImage *)placeHolderImage
              progressBlock:(void (^)(NSUInteger, long long, long long))progress
                 beforeHook:(void (^)(UIImage *))hook
                  afterHook:(void (^)(UIImage *))afterhook
{
    //图片id为空使用默认图片
    if (imageId == nil || imageId.length == 0)
    {
        if (placeHolderImage) {
            self.image = placeHolderImage;
        }
        return;
    }
    
    //将图片id转换成NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[APIClient sharedInstance] imageUrlForId:imageId size:size]]];
    void(^success)(UIImage *image) = ^(UIImage *image)
    {
        if (hook)
        {
            hook(image);
        }
        //使用图片,存入缓存
        self.image = image;
        [[UIImageView sharedImageCache] cacheImage:image forRequest:request];
        if (afterhook)
        {
            afterhook(image);
        }
    };
    //从内存缓存中查找是否有图片 key->NSURLRequest
    UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:request];
    if (cachedImage)
    {
        if (success)
        {
            success(cachedImage);
        }
    }
    else
    {
        if (placeHolderImage)
        {
            self.image = placeHolderImage;
        }
        //从本地缓存中查找是否有图片
        __weak UIImageView *wSelf = self;
        [[APIClient sharedInstance] getCachedImageById:imageId size:size finish:^(UIImage *image)
         {
             if (image != nil)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if(success)success(image);
                 });
             }
             else
             {
                 if (imageId.length == 0) {
                     return;
                 }
                 //最后请求网络
                 [wSelf setImageWithURLRequest:request placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                     if (image != nil)
                     {
                         if(success)success(image);
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                             [[APIClient sharedInstance] saveImage:image imageId:imageId size:size];
                         });
                     }
                     else
                     {
                         DLOG(@"save image nil for: %@, size: %@", imageId, NSStringFromCGSize(size));
                     }
                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                 }];
             }
         }];
    }
    
}
//圆角图片
//原来的接口无法beforeHook,afterHook无法满足图片处理的需求
//为了兼容性,不改变原始逻辑单独写了一个方法
- (void)setImageWithImageId:(NSString *)imageId
                placeHolder:(UIImage *)placeHolderImage
               cornerRadius:(CGFloat)cornerRadius
{
    CGSize size = CGSizeMake(self.width * SCREEN_SCALE, self.height * SCREEN_SCALE);
    //图片id为空使用默认图片
    if(imageId == nil || imageId.length == 0)
    {
        if (placeHolderImage) {
            self.image = placeHolderImage;
        }
        return;
    }
    
    //将图片id转换成NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[APIClient sharedInstance] imageUrlForId:imageId size:size]]];
    void(^success)(UIImage *) = ^(UIImage *image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *cornerImage;
            CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
            UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
            [[UIBezierPath bezierPathWithRoundedRect:frame
                                        cornerRadius:cornerRadius] addClip];
            [image drawInRect:frame];
            cornerImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                //使用图片,存入缓存
                self.image = cornerImage;
                [[UIImageView sharedImageCache] cacheImage:image forRequest:request];
            });
        });
    };
    
    //从内存缓存中查找是否有图片 key->NSURLRequest
    UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:request];
    if (cachedImage)
    {
        if (success)
        {
            success(cachedImage);
        }
    }
    else
    {
        if (placeHolderImage)
        {
            self.image = placeHolderImage;
        }
        //从本地缓存中查找是否有图片
        __weak UIImageView *wSelf = self;
        [[APIClient sharedInstance] getCachedImageById:imageId size:size finish:^(UIImage *image)
         {
             if (image != nil)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if(success)success(image);
                 });
             }
             else
             {
                 if (imageId.length == 0) {
                     return;
                 }
                 //最后请求网络
                 [wSelf setImageWithURLRequest:request placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                     if (image != nil)
                     {
                         if(success)success(image);
                         
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                             [[APIClient sharedInstance] saveImage:image imageId:imageId size:size];
                         });
                     }
                     else
                     {
                         DLOG(@"save image nil for: %@, size: %@", imageId, NSStringFromCGSize(size));
                     }
                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                 }];
             }
         }];
    }
    
}
 
- (void)cancelDownload {
    [self cancelImageRequestOperation];
}

@end
