//
//  UIImage+Color.h
//  CMUtils
//
//  Created by Jerry on 15/3/26.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage *)ImageWithColor:(UIColor*)color;
+ (UIImage *)ImageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage *)imageWithFrame:(CGSize)size color:(UIColor *)color;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
@end
