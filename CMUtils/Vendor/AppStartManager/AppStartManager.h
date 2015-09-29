//
//  AppStartManager.h
//  CMUtils
//
//  Created by Jerry on 15/4/14.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_START_NUMBER      @"APP_START_NUMBER"
#define HQCAMERA_START_NUMBER @"HQCAMERA_START_NUMBER"
#define MEASURE_START_NUMBER  @"MEASURE_START_NUMBER"
@interface AppStartManager : NSObject
/**
 *  页面启动计数
 *
 *  @param key 页面的Key
 */
+ (void)startCountWithKey:(NSString *)key;

/**
 *  获取启动次数
 *
 *  @param key 页面的Key
 *
 *  @return 启动次数
 */
+ (NSInteger)getCount:(NSString *)key;

/**
 *  是第一次进入?
 *
 *  @param key 页面的Key
 *
 *  @return 第一次进入返回YES
 */
+ (BOOL)firstEnter:(NSString *)key;
@end
