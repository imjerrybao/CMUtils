//
//  UILabel+CalcRect.h
//  iBoost
//
//  Created by Jerry on 15/6/25.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CalcRect)
+ (UILabel *)sharedInstance;


/**
 *  计算UILable的高度
 *
 *  @param str   内容
 *  @param font  文字大小
 *  @param width 宽度
 *
 *  @return CGSize
 */
- (CGSize)sizeWithString:(NSString *)str font:(CGFloat)font width:(CGFloat)width;

/**
 *  计算UILable的高度
 *
 *  @param str   内容
 *  @param font  文字大小
 *  @param width 宽度
 *  @param lines 限定行数
 *
 *  @return CGSize
 */
- (CGSize)sizeWithString:(NSString *)str font:(CGFloat)font width:(CGFloat)width lines:(NSInteger)lines;
@end
