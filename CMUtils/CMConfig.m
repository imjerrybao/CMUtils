//
//  CMConfig.m
//  CMUtilsDemo
//
//  Created by apple on 9/12/15.
//  Copyright (c) 2015 Cmgine Inc. All rights reserved.
//

#import "CMConfig.h"

@implementation CMConfig

+ (NSString *)getCurrentLanguage
{
    NSString *lan = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([lan isEqualToString:@"zh-HK"]) {
        return @"zh-Hant";
    }
    return lan;
}

+ (NSString *)useLanguage
{
    if([[self getCurrentLanguage] isEqualToString:@"zh-Hant"])
    {
        return @"zh-Hant";
    }
    else if([[self getCurrentLanguage] isEqualToString:@"zh-Hans"])
    {
        return @"zh-Hans";
    }
    else
    {
        return @"en";
    }
}

@end
