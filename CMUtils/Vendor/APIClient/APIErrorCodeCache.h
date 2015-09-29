//
//  APIErrorCodeCache.h
//  CMUtils
//
//  Created by Jerry on 15/3/27.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIErrorCodeCache : NSCache
+ (APIErrorCodeCache *)sharedInstance;
- (NSString *)errorContentWithCode:(NSNumber *)code;
@end
