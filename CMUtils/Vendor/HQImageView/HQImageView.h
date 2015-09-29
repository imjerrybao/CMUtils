//
//  HQImageView.h
//  iBoost
//
//  Created by Jerry on 15/6/16.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQImageView : UIImageView
/**
 *  用颜色初始化带有遮罩的HQImageView
 *
 *  @param frame     frame
 *  @param image     图片
 *  @param maskColor 遮罩颜色
 *
 *  @return HQImageView
 */
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image maskColor:(UIColor *)maskColor;

/**
 *  设置遮罩颜色
 *
 *  @param image     图片
 *  @param maskColor 遮罩颜色
 */
- (void)setImage:(UIImage *)image maskColor:(UIColor *)maskColor;

/**
 *  初始化HQImageView
 *
 *  @param frame frame
 *  @param image image
 *
 *  @return HQImageView
 */
- (instancetype)initMaskWithFrame:(CGRect)frame image:(UIImage *)image;

/**
 *  设置图片
 *
 *  @param image 图片
 */
- (void)setMaskImage:(UIImage *)image;
@end
