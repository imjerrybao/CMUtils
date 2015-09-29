//
//  HQAsset.h
//  iBoost
//
//  Created by Jerry on 14/12/18.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ALAsset;
@class CLLocation;
@interface HQAsset : NSObject
@property (strong, nonatomic) ALAsset *asset;
@property (strong, nonatomic) NSString *URLString;

+ (HQAsset *)HQAssetWithAsset:(ALAsset *)asset;

/**
 *  获取缩略图
 *
 *  @return 返回UIImage
 */
- (UIImage *)thumbnailImage;

/**
 *  获取压缩图
 *
 *  @return 返回UIImage
 */
- (UIImage *)compressedImage;

- (UIImage *)fullResolutionImage;

/**
 *  获取位置信息
 *
 *  @return CLLocation
 */
- (CLLocation *)locationInfo;

/**
 *  获取时间信息
 *
 *  @return NSDate
 */
- (NSDate *)createTime;
@end
