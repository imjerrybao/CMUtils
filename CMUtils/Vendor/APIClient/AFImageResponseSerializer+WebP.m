//
//  AFImageResponseSerializer+WebP.m
//  CMUtils
//
//  Created by Jerry on 15/4/22.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "AFImageResponseSerializer+WebP.h"
#import <UIKit/UIKit.h>

@implementation AFImageResponseSerializer (WebP)
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap",@"image/webp", nil];
    
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    self.imageScale = [[UIScreen mainScreen] scale];
    self.automaticallyInflatesResponseImage = YES;
#endif
    
    return self;
}
@end
