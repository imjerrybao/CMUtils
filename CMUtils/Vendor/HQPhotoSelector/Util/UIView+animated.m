//
//  UIView+animated.m
//  seafishing2
//
//  Created by mac on 14/11/28.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "UIView+animated.h"

@implementation UIView (animated)
+ (void)viewSpring:(UIView *)view
{
//    [UIView animateWithDuration:0.1 animations:^{
//        view.transform=CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
//    } completion:^(BOOL finished)
//     {
         [UIView animateWithDuration:0.2 animations:^
          {
              view.transform=CGAffineTransformScale(CGAffineTransformIdentity,0.8, 0.8);
          } completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.1 animations:^
               {
                   view.transform=CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
               } completion:^(BOOL finished)
               {
                   [UIView animateWithDuration:0.1 animations:^{
                       view.transform=CGAffineTransformScale(CGAffineTransformIdentity,1.0, 1.0);
                   } completion:^(BOOL finished) {
                       
                   }];
               }];
          }];
//     }];
}
@end
