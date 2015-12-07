//
//  PhotoAlbumNaView.h
//  seafishing2
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+hex.h"
@class HQPhotoAlbumNaView;
@protocol HQPhotoAlbumNaViewDelegate <NSObject>
@required
- (void)photoAlbumDidFinish:(NSMutableArray *)photoArray;
- (void)photoAlbum:(HQPhotoAlbumNaView *)nav didFinish:(NSMutableArray *)photoArray;
@end

@interface HQPhotoAlbumNaView : UINavigationController
@property (nonatomic,weak) id<HQPhotoAlbumNaViewDelegate> albumdelegate;

/**
 *  初始化相薄
 *
 *  @param toplimit 上限
 *  @param delegate 代理
 *
 *  @return 相薄实例
 */
- (id)initWithToplimit:(int)toplimit checkedPhoto:(NSArray *)checkedPhoto delegate:(id<HQPhotoAlbumNaViewDelegate>)delegate;


/**
 *  照片选择完成
 *
 *  @param animated   是否要动画
 */
- (void)dismissAlbum:(BOOL)animated;

- (void)presentModalViewControllerAnimated:(BOOL)animated;
- (void)dismissModalViewControllerAnimated:(BOOL)animated;
@end
