//
//  NSDictionary+util.m
//  iBoost
//
//  Created by Jerry on 13-12-4.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "NSDictionary+util.h"

@implementation NSDictionary (util)

- (NSString *)toJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
