//
//  UILabel+CalcRect.m
//  iBoost
//
//  Created by Jerry on 15/6/25.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "UILabel+CalcRect.h"

@implementation UILabel (CalcRect)
+ (UILabel *)sharedInstance
{
    static dispatch_once_t onceToken;
    static UILabel *_sharedClient = nil;
    dispatch_once(&onceToken, ^{
        _sharedClient = [UILabel new];
    });
    return _sharedClient;
}

- (CGSize)sizeWithString:(NSString *)str font:(CGFloat)font width:(CGFloat)width lines:(NSInteger)lines
{
    self.font = [UIFont systemFontOfSize:font];
    self.text = str;
    self.numberOfLines = lines;
    return [self sizeThatFits:CGSizeMake(width, 0)];
}

- (CGSize)sizeWithString:(NSString *)str font:(CGFloat)font width:(CGFloat)width
{
    return [self sizeWithString:str font:font width:width lines:0];
}

@end
