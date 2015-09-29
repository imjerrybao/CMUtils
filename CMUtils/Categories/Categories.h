//
//  HQUtil.h
//  iBoost
//
//  Created by Jerry on 14-6-13.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#ifndef iBoost_LHQUtil_h
#define iBoost_LHQUtil_h


#import "JSONValueTransformer+NSArray.h"
#import "JSONValueTransformer+NSDictionary.h"
#import "MBProgressHUD+Extend.h"
#import "NSArray+Util.h"
#import "NSData+AES.h"
#import "NSData+util.h"
#import "NSDate+util.h"
#import "NSDictionary+util.h"
#import "NSString+util.h"
#import "NSString+AES.h"
#import "UIColor+hex.h"
#import "UIDevice+hardware.h"
#import "UIImage+Color.h"
#import "UIImage+Resizing.h"
#import "UIImage+Rotating.h"
#import "UIImage+Saving.h"
#import "UIImage+Util.h"
#import "UILabel+CalcRect.h"
#import "UILabel+StringFrame.h"
#import "UIView+size.h"
#import "UIView+Snapshot.h"
#import "UIView+Util.h"

#define  KeyboardHeight 216

#define CAMERA_HEIGHT SCREEN_WIDTH/3*4

#define SharedApp  ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UIKeyWindow [[UIApplication sharedApplication] keyWindow]
#define ScrollViewAdjusts (IsIOS7?self.automaticallyAdjustsScrollViewInsets = NO:0)

#define STATE_BAR_HEIGHT 20
#define NAV_BAR_HEIGHT 44
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IsIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SCREEN_TOP (IsIOS7?(20.0f+44.0f):0.0f)
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define AbandonHeight ((IsIOS7?(20.0f+44.0f):44.0f))//应该减去的高度

#define SharedApp  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define Distans(p1,p2) sqrtf((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y))

#define COLOR_WITH_HEX(HEX) [UIColor colorWithRed:((HEX & 0xFF0000) >> 16)/255.0 green:((HEX & 0xFF00) >> 8)/255.0 blue:(HEX & 0xFF)/255.0 alpha:1]
#define COLOR_WITH_HEX_ALPHA(HEX,ALPHA) [UIColor colorWithRed:((HEX & 0xFF0000) >> 16)/255.0 green:((HEX & 0xFF00) >> 8)/255.0 blue:(HEX & 0xFF)/255.0 alpha:ALPHA]
//统一背景色
#define UNIFY_BG_COlOR COLOR_WITH_HEX(0xecf2f0)
//统一分割线的颜色
#define SEPERATORLINE_COLOR COLOR_WITH_HEX(0xe6e6e6)

#define WEIGHT_UNIT @"weightUnit"   //重量单位
#define LENGTH_UNIT @"lengthUnit"   //长度单位

#define WEAK_SELF __typeof(self) wSelf = self

#define RELATIVE_SIZE SCREEN_WIDTH/320
#define IPHONE4  480
#define IPHONE5  568
#define IPHONE6  667
#define IPHONE6P 736

#ifdef DEBUG
#define DDLogVerbose(frmt, ...) NSLog(@"%@",[NSString stringWithFormat:(frmt), ##__VA_ARGS__])
#define DDLogError(frmt, ...) NSLog(@"%@",[NSString stringWithFormat:(frmt), ##__VA_ARGS__])
#define DDLogInfo(frmt, ...) NSLog(@"%@",[NSString stringWithFormat:(frmt), ##__VA_ARGS__])
#else
#define DDLogVerbose(frmt, ...)
#define DDLogError(frmt, ...) 
#define DDLogInfo(frmt, ...)
#endif


#endif
