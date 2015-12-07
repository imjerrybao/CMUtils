//
//  PhotoSquares.h
//  seafishing2
//
//  Created by mac on 14/12/19.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQThumbnail.h"

@protocol HQThumbnailControllerDelegate <NSObject>
- (void)photoSquaresFrame:(CGRect)frame;
- (void)showOriginal:(HQThumbnail *)thumbnail;
@end




#define THUMBNAIL_SPACE 4.0f

@interface HQThumbnailController : UIView
@property (nonatomic) BOOL allowRemove;//允许移除

@property (nonatomic, weak) NSMutableArray *originArr;
- (CGFloat)thumbnailSize;

@property (nonatomic) int limit;//上限

/**
 *  支持:1.url 2.image 
 */
@property (nonatomic,strong) id assle;
/**
 *  初始化照片墙
 *
 *  @param frame frame x坐标和size是没有用的.控件自身会调整大小
 *  @param limit 可选照片上限
 *  @param delegate 代理
 *  @return PhotoSquares
 */
- (id)initWithFrame:(CGRect)frame limit:(int)limit swap:(BOOL)swap delegate:(id<HQThumbnailControllerDelegate>)delgate;

/**
 *  设置子视图,和调整自身大小
 */
- (void)reloadData;

/**
 *  获取DataSource 数据顺序为移动后的顺序
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)getDataSource;


@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isShowAdd; //是否显示加号 (如果不显示加号，则表示不能编辑，当然也不能删除图片)
@end
