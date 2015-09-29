//
//  CMConfig.h
//  CMUtilsDemo
//
//  Created by apple on 9/12/15.
//  Copyright (c) 2015 Cmgine Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MYNSLog(frmt, ...)  NSLog(@"[%@:%@ %d]  %@", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent],   \
NSStringFromSelector(_cmd), \
__LINE__,   \
[NSString stringWithFormat:(frmt), ##__VA_ARGS__])
/**
 *  Log
 */
#if DEBUG
#define DLOG(frmt, ...)   MYNSLog(frmt, ##__VA_ARGS__)
#define ERRLOG(frmt, ...) MYNSLog(frmt, ##__VA_ARGS__)
#else
#define DLOG(frmt, ...)
#define ERRLOG(frmt, ...)
#endif

#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define AbandonHeight ((IsIOS7?(20.0f+44.0f):44.0f))//应该减去的高度
#define IOS7ViewHeight (UIKeyWindow.height - (IsIOS7?(20.0f+44.0f):0.0f))

#define WEB_AES_KEY                 @"FA6247A59DF5C1F4E18F743FB3E76249"

#define Locale(str)            NSLocalizedString(str, nil)
#define LOADIMAGE(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:(fileName) ofType:@"png"]]
#define LOADJPEG(fileName)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:(fileName) ofType:@"jpeg"]]
#define SharedApp  ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UIKeyWindow [[UIApplication sharedApplication] keyWindow]

#define MobileIsoCountryCode        @"MobileIsoCountryCode"

#define WEAK_SELF __typeof(self) wSelf = self

@interface CMConfig : NSObject
+ (NSString *)getCurrentLanguage;
+ (NSString *)useLanguage;
@end
