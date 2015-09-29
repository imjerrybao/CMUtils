//
//  JSONValueTransformer+NSArray.m
//  CMUtils
//
//  Created by Jerry on 15/4/7.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "JSONValueTransformer+NSArray.h"
#import "NSArray+Util.h"
@implementation JSONValueTransformer (NSArray)
- (NSString *)NSStringFromNSArray:(NSArray *)array
{
    return [array toJSON];
}
@end
