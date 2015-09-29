//
//  UIImage+Util.m
//  CMUtils
//
//  Created by Jerry on 15/4/2.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "UIImage+Util.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CMConfig.h"
@implementation UIImage (Util)
- (NSDictionary *)metadata
{
    NSData *imageData = UIImageJPEGRepresentation(self,1);
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    NSDictionary *metaData = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));//转出信息数据
    return metaData;
}

/**
 *  UIimage+metedata生成一张新的图片
 *
 *  @param image    UIimage
 *  @param metadata metedata
 *  @param mimetype @"image/jpeg"
 *
 *  @return UIimage
 */
- (NSData *)imageWithMetadata:(NSDictionary *)metadata mimetype:(NSString *)mimetype
{
    NSMutableData *imageData = [NSMutableData data];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)mimetype, NULL);
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, uti, 1, NULL);
    
    if (imageDestination == NULL)
    {
        DLOG(@"Failed to create image destination");
        imageData = nil;
    }
    else
    {
        CGImageDestinationAddImage(imageDestination, self.CGImage, (__bridge CFDictionaryRef)metadata);
        
        if (CGImageDestinationFinalize(imageDestination) == NO)
        {
            DLOG(@"Failed to finalise");
            imageData = nil;
        }
        CFRelease(imageDestination);
    }
    CFRelease(uti);
    return imageData;
}

- (NSData *)image2Data
{
    return UIImageJPEGRepresentation(self, 1.0);
}

- (UIImage *)compression
{
    return [UIImage imageWithData:UIImageJPEGRepresentation(self, 0.6)];
}

@end
