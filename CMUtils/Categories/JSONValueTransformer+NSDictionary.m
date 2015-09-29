//
//  JSONValueTransformer+NSDictionary.m
//  CMUtils
//
//  Created by Jerry on 15/4/8.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "JSONValueTransformer+NSDictionary.h"
#import "CMUtils.h"

@implementation JSONValueTransformer (NSDictionary)

- (NSString *)NSStringFromNSDictionary:(NSDictionary *)dictionary
{
    return [dictionary toJSON];
}

@end
