//
//  NSArray+Util.m
//  CMUtils
//
//  Created by Jerry on 15/4/7.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)
- (NSString *)toJSON
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
