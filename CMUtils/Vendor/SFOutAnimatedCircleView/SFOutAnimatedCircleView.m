//
//  SFOutAnimatedCircleView.m
//  iBoost
//
//  Created by Jerry on 13-10-12.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "SFOutAnimatedCircleView.h"

@interface SFOutAnimatedCircleView()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation SFOutAnimatedCircleView


- (id)initWithFrame:(CGRect)frame circleCenter:(CGPoint)center
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        float r = frame.size.width * 0.5;
        CGRect imageFrame = CGRectMake(center.x - r, center.y - r, r * 2, r * 2);
        self.imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        self.imageView.center = center;
        self.imageView.image = [UIImage imageNamed:@"map_circle"];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        
        [self start];
    }
    return self;
}

- (void)start
{
    double duration = 1.5;
    float repeatCount = MAXFLOAT;
    CABasicAnimation *opacityAnimation;
    opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration    = duration;
    opacityAnimation.repeatCount = repeatCount;
    opacityAnimation.fromValue   = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue     = [NSNumber numberWithFloat:0];
    
    //resize animation setup
    CABasicAnimation *transformAnimation;
    transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    transformAnimation.duration = duration;
    transformAnimation.repeatCount = repeatCount;
    //transformAnimation.autoreverses=YES;
    transformAnimation.fromValue = [NSNumber numberWithFloat:0.1];
    transformAnimation.toValue = [NSNumber numberWithFloat:1.2];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.repeatCount = repeatCount;
    [group setAnimations:[NSArray arrayWithObjects:opacityAnimation, transformAnimation, nil]];
    group.duration = duration;
    
    //apply the grouped animaton
    [self.imageView.layer addAnimation:group forKey:@"groupAnimation"];
}

- (void)stop
{
    [self.imageView.layer removeAllAnimations];
}

@end
