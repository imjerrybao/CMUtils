//
//  DirectoryUtil.m
//  CMUtils
//
//  Created by Jerry on 15/4/3.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "DirectoryUtil.h"

@implementation DirectoryUtil

+ (NSString *)libPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
+ (NSString *)libPrefPath
{
    return  [[DirectoryUtil libPath] stringByAppendingPathComponent:@"Preferences"];
}
+ (NSString *)libCachePath
{
    return [[DirectoryUtil libPath] stringByAppendingPathComponent:@"Caches"];
}
+ (NSString *)tmpPath
{
    return NSTemporaryDirectory();
}

//+ (BOOL)creatDirectoryInPath:(NSString *)path;
//{
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        return YES;
////    }
//}

@end
