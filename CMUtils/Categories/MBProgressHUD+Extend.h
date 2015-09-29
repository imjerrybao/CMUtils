//
//  MBProgressHUD+Extend.h
//  CMUtils
//
//  Created by Jerry on 4/2/15.
//  Copyright (c) 2015 Jerry. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extend)

+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text delay:(int)delay;

+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text;//不阻止操作

+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover delay:(int)delay;

+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover;

+ (MBProgressHUD *)longTextHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover;

+ (MBProgressHUD *)longTextHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover delay:(int)delay;

@end
