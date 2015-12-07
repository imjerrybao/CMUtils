//
//  HQPhotoPageVC.h
//  seafishing2
//
//  Created by mac on 14/11/28.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HQPhotoPageOneDelegate <NSObject>
- (void)HQPhotoPageOneAppear:(int)index;
@end
@interface HQPhotoPageOne : UIViewController
@property (nonatomic,assign) int index;
@property (nonatomic,weak) id delegate;

/**
 *  返回一个Page页
 *
 *  @param asset       1,资源ALAsset 或者 2,图片Url
 *  @param index       下标
 *  @param placeHolder 默认图 仅asset为2的时候才起作用
 *
 *  @return HQPhotoPageOne
 */
+ (HQPhotoPageOne *)HQPhotoPageVCWithAsset:(id)asset index:(int)index placeHolder:(UIImage *)placeHolder;
@end
