//
//  NSString+util.h
//  CMUtils
//
//  Created by Jerry on 15/3/23.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 返回字符串s第一个字的gbk编码值
 */
extern uint64_t gbk_value(NSString *s);
extern uint64_t shiftjis_value(NSString *s);
extern uint64_t unicode_value(NSString *s);


@interface NSString (util)
+ (BOOL)isBlankString:(NSString *)string;
+ (BOOL)isNullString:(NSString *)string;
- (BOOL)isEqualsIgnorecase:(NSString *)str;
- (BOOL)contains:(NSString *)str;
- (NSString *)encryptUseAesKey:(NSString *)key IV:(NSString *)iv;
- (NSString *)dencryptUseAesKey:(NSString *)key IV:(NSString *)iv;
+ (BOOL)isEmail:(NSString *)string;
- (id)toJSONObject;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;
+ (BOOL)isPositiveInt:(NSString *)string;
+ (NSString *)brithdayToAge:(NSString *)birthday;
/**
 *  最大长度字符串
 *
 *  @param src       输入字符串
 *  @param maxLength 最大长度
 *
 *  @return 输出字符串
 */
+ (NSString *)substringWithAsciiLen:(NSString *)src maxLength:(int)maxLength;
//字符串的size
- (CGSize)strSizeWithFont:(UIFont *)font size:(CGSize)size;
- (CGSize)strSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
