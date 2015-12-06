//
//  PhotoWallView.m
//  CMUtils
//
//  Created by Jerry on 15/6/17.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoWallViewDelegate <NSObject>
@optional
- (void)photoHasTapWithIndex:(NSInteger)index imageArr:(NSArray *)imageArr;
@end

@interface PhotoWallView : UIView
@property (nonatomic, weak) id<PhotoWallViewDelegate> delegate;           // 代理

- (void)photoWithArray:(NSArray *)arrayImage;
+ (CGSize)PhotoWallHeight:(NSArray *)arrayImage;
@end
