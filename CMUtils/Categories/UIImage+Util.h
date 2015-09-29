//
//  UIImage+Util.h
//  CMUtils
//
//  Created by Jerry on 15/4/2.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)
- (NSDictionary *)metadata;
- (NSData *)imageWithMetadata:(NSDictionary *)metadata mimetype:(NSString *)mimetype;

/**
 *  UIImage转NSData
 *
 *  @return 输出NSData
 */
- (NSData *)image2Data;

/**
 *  图片压缩
 *
 *  @return 压缩后的图片
 */
- (UIImage *)compression;
@end
