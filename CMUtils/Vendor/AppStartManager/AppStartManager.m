//
//  AppStartManager.m
//  CMUtils
//
//  Created by Jerry on 15/4/14.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "AppStartManager.h"

@implementation AppStartManager

+ (void)startCountWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *startNumber = [userDefaults objectForKey:key];
    if(startNumber)
    {
        NSInteger number = [startNumber integerValue];
        number++;
        [userDefaults setObject:@(number) forKey:key];
    }
    else
    {
        [userDefaults setObject:@(1) forKey:key];
    }
    [userDefaults synchronize];
}

+ (NSInteger)getCount:(NSString *)key
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue];
}

+ (BOOL)firstEnter:(NSString *)key
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue] == 1)
    {
        return YES;
    }
    return NO;
}

@end
