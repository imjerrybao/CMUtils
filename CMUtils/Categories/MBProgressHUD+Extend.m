//
//  MBProgressHUD+Extend.m
//  CMUtils
//
//  Created by Jerry on 4/2/15.
//  Copyright (c) 2015 Jerry. All rights reserved.
//

#import "MBProgressHUD+Extend.h"

@implementation MBProgressHUD (Extend)

+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text delay:(int)delay {
    if (view == nil) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 12.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
    return hud;
}

+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text {
    if (view == nil) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 12.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
    return hud;
}

//不阻止操作
+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover delay:(int)delay
{
    MBProgressHUD * hud = [self textHudInView:view text:text delay:delay];
    [hud setUserInteractionEnabled:isCover];
    return hud;
}

+ (MBProgressHUD *)textHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover
{
    MBProgressHUD * hud = [self textHudInView:view text:text];
    [hud setUserInteractionEnabled:isCover];
    return hud;
}

+ (MBProgressHUD *)longTextHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover
{
    MBProgressHUD *hud = [self textHudInView:view text:text];
    hud.labelText = nil;
    hud.detailsLabelText = text;
    [hud setUserInteractionEnabled:isCover];
    return hud;
}

+ (MBProgressHUD *)longTextHudInView:(UIView *)view text:(NSString *)text isCover:(BOOL)isCover delay:(int)delay
{
    MBProgressHUD *hud = [self textHudInView:view text:text delay:delay];
    hud.labelText = nil;
    hud.detailsLabelText = text;
    [hud setUserInteractionEnabled:isCover];
    return hud;
}

@end
