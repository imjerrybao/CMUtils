//
//  NSData+util.m
//  CMUtils
//
//  Created by Jerry on 15/3/27.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "NSData+util.h"
#import <CommonCrypto/CommonCrypto.h>
#import "CMConfig.h"

@implementation NSData (util)
- (id)toJSONObject
{
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error) {
        DLOG(@"to json error: %@ for string: %@", error, self);
        return nil;
    }
    return obj;
}
- (NSData *)MD5
{
    uint8_t result[16];
    CC_MD5(self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:16];
}

- (NSString *)toHexString
{
    unsigned char *bytes = (unsigned char *)self.bytes;
    NSMutableString *outPut = [[NSMutableString alloc] init];
    for (int i = 0; i < self.length; ++i) {
        [outPut appendFormat:@"%02x", bytes[i]];
    }
    return outPut;
}
@end
