//
//  DirectoryUtil.h
//  CMUtils
//
//  Created by Jerry on 15/4/3.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectoryUtil : NSObject
+ (NSString *)docPath;      // /doucment
+ (NSString *)libPrefPath;  // /library/Preferences
+ (NSString *)libCachePath; // /library/Caches
+ (NSString *)tmpPath;      // /temp

//+ (BOOL)creatDirectoryInPath:(NSString *)path; //在该路径下面创建目录
@end
