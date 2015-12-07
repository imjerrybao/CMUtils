//
//  BlogImgView.h
//  seafishing2
//
//  Created by mac on 14/12/19.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQThumbnail;
@protocol HQThumbnailDelegate <NSObject>
/**
 *  移除缩略图
 *
 *  @param thumbnail 缩略图引用
 */
- (void)removeThumbnail:(HQThumbnail *)thumbnail;

/**
 *  显示原图
 *
 *  @param thumbnail 缩略图引用
 */
- (void)showOriginal:(HQThumbnail *)thumbnail;
@end



@interface HQThumbnail : UIImageView
@property (nonatomic,weak) id<HQThumbnailDelegate> delegate;

/**
 *  UIImage or NSString
 */
@property (nonatomic,strong) id asset;



- (void)showRemoveButton:(BOOL)show;
- (void)setPlusAction:(id)target action:(SEL)action;

@end
