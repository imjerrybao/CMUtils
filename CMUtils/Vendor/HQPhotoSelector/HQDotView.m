    //
//  HQDotView.m
//  seafishing2
//
//  Created by mac on 14/12/18.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQDotView.h"
@interface HQDotView()
{
//    UITapGestureRecognizer *_tap;
    UIPanGestureRecognizer *_pan;
    CGPoint originCenter;
    
    CGPoint _originPoint;
    
    
//    CGPoint originCenter; //最初的中点
    CGFloat springConstant;
    CGFloat dampingCoefficient;
    CGFloat mass;
    CGPoint velocity;
    
    UILongPressGestureRecognizer *longPress;
}

@property (nonatomic, strong) UIColor  *dotColor;
@property (nonatomic, strong) UIFont   *font;
@property (nonatomic, strong) NSString *showNum;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation HQDotView
- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dotColor = color;
        self.clipsToBounds = NO;
        originCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        springConstant = 1500;
        dampingCoefficient = 10;
        mass = 1;
        velocity = CGPointZero;
    }
    return self;
}

- (void)setNumber:(int)number
{
    _number = number;
    _showNum = nil;
    if (_number <= 99) {
        _font = [UIFont systemFontOfSize:10];
        _showNum = [NSString stringWithFormat:@"%d", _number];
    } else {
        _font = [UIFont systemFontOfSize:8];
        _showNum = @"99+";
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextAddEllipseInRect(context, rect);
        CGContextSetFillColorWithColor(context, _dotColor.CGColor);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
    }
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    {

        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [_showNum drawInRect:CGRectMake(0, (rect.size.height-_font.lineHeight)*0.5, rect.size.width, _font.lineHeight) withFont:_font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
#pragma clang diagnostic pop
    }
    CGContextRestoreGState(context);
    
    
}

@end
