//
//  PhotoWallView.h
//  iBoost
//
//  Created by Jerry on 15/6/17.
//  Copyright (c) 2015年 Jerry Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoWallViewDelegate <NSObject>
@optional
- (void)photoHasTapWithIndex:(NSInteger)index imageArr:(NSArray *)imageArr;
@end

@interface PhotoWallView : UIView
@property (nonatomic, weak) id<PhotoWallViewDelegate> delegate;           // 代理

- (void)photoWithArray:(NSArray *)arrayImage width:(CGFloat)width;
- (CGFloat)photoWallHeight;
@end
