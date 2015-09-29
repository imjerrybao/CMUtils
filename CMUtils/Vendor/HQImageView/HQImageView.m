//
//  HQImageView.m
//  iBoost
//
//  Created by Jerry on 15/6/16.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "HQImageView.h"
#import "CMUtils.h"

@implementation HQImageView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image maskColor:(UIColor *)maskColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setImage:image maskColor:maskColor];
    }
    return self;
}


- (void)setImage:(UIImage *)image maskColor:(UIColor *)maskColor
{
    self.image = [UIImage ImageWithColor:maskColor];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.contents = (__bridge id)image.CGImage;
    self.layer.mask = maskLayer;
}

- (instancetype)initMaskWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setMaskImage:image];
    }
    return self;
}

- (void)setMaskImage:(UIImage *)image
{
    [self setImage:image maskColor:COLOR_WITH_HEX(0x48cfae)];
}
@end
