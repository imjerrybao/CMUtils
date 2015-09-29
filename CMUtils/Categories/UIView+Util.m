//
//  UIView+Util.m
//  CMUtils
//
//  Created by Jerry on 15/4/2.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)
- (UIImage *)createImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
