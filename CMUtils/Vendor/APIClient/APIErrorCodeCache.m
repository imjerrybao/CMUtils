//
//  APIErrorCodeCache.m
//  CMUtils
//
//  Created by Jerry on 15/3/27.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "APIErrorCodeCache.h"
#import "NSData+util.h"
@implementation APIErrorCodeCache

+ (APIErrorCodeCache *)sharedInstance
{
    static APIErrorCodeCache *api_errorCodeCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        api_errorCodeCache = [[APIErrorCodeCache alloc] init];
    });
    
    return api_errorCodeCache;
}



- (NSString *)errorContentWithCode:(NSNumber *)code
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CMErrorCode" ofType:@"txt"];
    NSDictionary *errorContent = [self objectForKey:filePath];
    if(errorContent == nil)
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        errorContent = [data toJSONObject];
    }
    //这个错误内容给开发者看到,中文就可以了
    NSDictionary *description = [errorContent objectForKey:[code stringValue]];
    if(description)
    {
        return [[description objectForKey:@"VALUES"] objectForKey:@"zh"];
    }
    else
    {
        return nil;
    }
}
@end
