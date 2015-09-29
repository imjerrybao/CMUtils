//
//  NSString+util.m
//  CMUtils
//
//  Created by Jerry on 15/3/23.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "NSString+util.h"
#import <Foundation/NSCalendar.h>
#import "CMUtils.h"

static uint64_t encoding_value(NSString *s, NSStringEncoding enc) {
    NSData *data;
    uint64_t value = 0;
    
    if (s.length == 0) {
        return 0;
    } else if (s.length > 1) {
        s = [s substringWithRange:NSMakeRange(0, 1)];
    }
    data = [s dataUsingEncoding:enc];
    if (data.length == 1) {
        char c;
        [data getBytes:&c length:1];
        value = c & 0xff;
    } else if (data.length == 2) {
        char c[2];
        [data getBytes:&c length:2];
        value = ((c[0]&0xff) << 8) | (c[1]&0xff);
    } else if (data.length == 3) {
        char c[3];
        [data getBytes:&c length:3];
        value = ((c[0]&0xff) << 16) | ((c[1]&0xff) << 8) | (c[2]&0xff);
    } else if (data.length == 4) {
        char c[4];
        [data getBytes:&c length:4];
        value = ((c[0]&0xff) << 24) | ((c[1]&0xff) << 16) | ((c[2]&0xff) << 8) | (c[3]&0xff);
    }
    return value;
}

uint64_t shiftjis_value(NSString *s) {
    return encoding_value(s, NSShiftJISStringEncoding);
}

uint64_t gbk_value(NSString *s) {
    return encoding_value(s, CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000));
}

uint64_t unicode_value(NSString *s) {
    return encoding_value(s, CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8));
}

@implementation NSString (util)

// ios 字符串判断非空
//排除空格
+ (BOOL)isBlankString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]])
    {
        return YES;
    }
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
// 不排除空格
+ (BOOL)isNullString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isEqualsIgnorecase:(NSString *)str
{
    return [self caseInsensitiveCompare:str] == NSOrderedSame;
}

- (BOOL)contains:(NSString *)str
{
    return [self rangeOfString:str].location != NSNotFound;
}

- (NSString *)encryptUseAesKey:(NSString *)key IV:(NSString *)iv {
    if (self == nil || self.length == 0) {
        return self;
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    SF_AESkeyLength len;
    if (key.length == 32) {
        len = SFAES128;
    } else if (key.length == 64) {
        len = SFAES256;
    } else {
        [NSException raise:@"KeyLengthError" format:@"hex key length must 32 or 64, now %lu", (unsigned long)key.length];
    }
    data = [data AESUseMode:SFAESModeECB padding:SFPKCS7Padding WithKey:key keyLength:len IV:iv isEncrypt:YES];
    return [data toHexString];
}

- (NSString *)dencryptUseAesKey:(NSString *)key IV:(NSString *)iv {
    if (self == nil || self.length == 0) {
        return self;
    }
    NSData *data = dataWithHexString(self);
    SF_AESkeyLength len;
    if (key.length == 32) {
        len = SFAES128;
    } else if (key.length == 64) {
        len = SFAES256;
    } else {
        [NSException raise:@"KeyLengthError" format:@"hex key length must 32 or 64, now %lu", (unsigned long)key.length];
    }
    data = [data AESUseMode:SFAESModeECB padding:SFPKCS7Padding WithKey:key keyLength:len IV:iv isEncrypt:NO];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

+ (BOOL)isEmail:(NSString *)string {
    if ([self isBlankString:string]) {
        return NO;
    }
    NSString *re = @"^[A-Za-z0-9._%+-]{1,64}@[A-Za-z0-9.-]{1,64}\\.(([A-Za-z]{2,6})|([A-Za-z]{2,3}\\.[A-Za-z]{2}))$";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:re options:NSRegularExpressionCaseInsensitive error:&error];
    if (error != nil) {
        DLOG(@"NSRegularExpression create error: %@", error);
        return NO;
    }
    NSUInteger n = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return n != 0;
}

- (id)toJSONObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        DLOG(@"to json error: %@ for string: %@", error, self);
        return nil;
    }
    return obj;
}

//判断是否整数
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否浮点数
+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否正整数
+ (BOOL)isPositiveInt:(NSString *)string
{
    if ([self isPureInt:string]) {
        if ([string integerValue] > 0) {
            return YES;
        }
    }
    return NO;
}

- (CGSize)strSizeWithFont:(UIFont *)font size:(CGSize)size
{
    return [self strSizeWithFont:font size:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)strSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = (NSMutableParagraphStyle *)[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
    return rect.size;
}

/**
 *  用户名长度检测
 *
 *  @param src       输入
 *  @param maxLength Ascii字符个数
 *
 *  @return 截取后字符串
 */
+ (NSString *)substringWithAsciiLen:(NSString *)src maxLength:(int)maxLength
{
    NSMutableString *dst = [NSMutableString string];
    int len = 0;
    for (int i = 0; i < src.length; i++)
    {
        NSString *tmp = [src substringWithRange:NSMakeRange(i, 1)];
        len += [NSString getStringLength:tmp];
        if(len <= maxLength)
        {
            [dst appendString:tmp];
        }
        else
        {
            break;
        }
    }
    return dst;
}

+  (int)getStringLength:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p != '\0') {
            
            strlength++;
        }
        p++;
    }
    return strlength;
    
}

+ (NSString *)brithdayToAge:(NSString *)birthday
{
    if (birthday.length == 0) {
        return @"0";
    }
    
    NSString *resultAge;
    NSString *birthYear = [[birthday componentsSeparatedByString:@"-"] objectAtIndex:0];
    NSDate *currentDate = [NSDate date];
    int year = [currentDate year];
    int age = year - [birthYear integerValue];
    if (age < 0) {
        age = 0;
    }
    resultAge = [NSString stringWithFormat:@"%d", age];
    if (resultAge == nil) {
        resultAge = @"0";
    }
    return resultAge;
}
@end
