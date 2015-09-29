//
//  HQAsset.m
//  iBoost
//
//  Created by Jerry on 14/12/18.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#import "HQAsset.h"
#import "CMUtils.h"
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface HQAsset()
@property (nonatomic,strong) NSDate     *time;
@property (nonatomic,strong) CLLocation *location;
@end

@implementation HQAsset


+ (HQAsset *)HQAssetWithAsset:(ALAsset *)asset
{
    HQAsset *image = [[HQAsset alloc] init];
    image.asset               = asset;
    image.location            = [asset valueForProperty:ALAssetPropertyLocation];
    image.time                = [asset valueForProperty:ALAssetPropertyDate];
    image.URLString           = [[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
    return image;
}

- (UIImage *)compressedImage
{
//    UIImageOrientation orientation = UIImageOrientationUp;
//    CGImageRef imageRef = self.asset.defaultRepresentation.fullResolutionImage;//获取原始图片
//    
//    //获取图片方向
//    NSNumber* orientationValue = [self.asset valueForProperty:ALAssetPropertyOrientation];
//    if (orientationValue != nil) {
//        orientation = [orientationValue intValue];
//    }
//    
//    //设置图片方向
//    UIImage* image = [UIImage imageWithCGImage:imageRef scale:1 orientation:orientation];
//    UIImage *img = [image scaleMaxToFitSize:CGSizeMake(960, 960)];
//    
//    //调整图片方向
//    img = [img fixOrientation];
    CGImageRef imageRef = self.asset.defaultRepresentation.fullScreenImage;
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    UIImage *img = [image scaleMaxToFitSize:CGSizeMake(960, 960)];
    return img;
}

- (UIImage *)fullResolutionImage
{
    CGImageRef imageRef = self.asset.defaultRepresentation.fullScreenImage;
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}

- (UIImage *)thumbnailImage
{
    return [UIImage imageWithCGImage:self.asset.thumbnail];
}

- (CLLocation *)locationInfo
{
    return self.location;
}

- (NSDate *)createTime
{
    return self.time;
}
//- (void)dealImage {
//    UIImageOrientation orientation = UIImageOrientationUp;
//    NSNumber* orientationValue = [self.asset valueForProperty:ALAssetPropertyOrientation];
//    if (orientationValue != nil) {
//        orientation = [orientationValue intValue];
//    }
//
//    CGFloat scale  = 1;
//    @autoreleasepool {
//        CGImageRef imageRef = self.asset.defaultRepresentation.fullResolutionImage;
//        UIImage* image = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
//        [self compressWithImage:image];
//        [self compressDone];
//    }
//}


//- (NSDate *)createTime {
//    return self.time;
//}

//+ (void)executeMulti:(NSArray *)uploadImages allDone:(void (^)(NSArray *newImage))block {
//    //    static dispatch_queue_t queue;
//    //    static dispatch_once_t onceToken;
//    //    dispatch_once(&onceToken, ^{
//    //        queue = dispatch_queue_create("com.solt.imageDealQueue", NULL);
//    //    });
//    
//    dispatch_async([ApiClient sharedImageQueue], ^{
//        for (int i = 0; i < uploadImages.count; ++i) {
//            if ([uploadImages[i] isKindOfClass:[HQAsset class]]) {
//                HQAsset *assetImage = uploadImages[i];
//                if(assetImage.compressedImageData == nil)
//                {
//                    [assetImage dealLocation];
//                    [assetImage dealImage];
//                }
//            }
//            
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (block) {
//                block(uploadImages);
//            }
//        });
//    });
//}
//
//+ (HQAsset *)executeSingle:(HQAsset *)uploadImages
//{
//    HQAsset *assetImage = uploadImages;
//    static dispatch_queue_t queue;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        queue = dispatch_queue_create("com.solt.imageDealQueue", NULL);
//    });
//    //    dispatch_async(queue, ^{
//    //
//    //    if ([uploadImages isKindOfClass:[HQAsset class]])
//    //    {
//    //        [assetImage dealLocation];
//    //        [assetImage dealImage];
//    //    }
//    //    dispatch_async(queue, ^{
//    if ([uploadImages isKindOfClass:[HQAsset class]])
//    {
//        [assetImage dealLocation];
//        [assetImage dealImage];
//    }
//    //    });
//    
//    
//    return assetImage;
//}

@end
