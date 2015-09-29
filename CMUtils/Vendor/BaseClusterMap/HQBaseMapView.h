//
//  HQBaseMapView.h
//  iBoost
//
//  Created by Jerry on 15/5/11.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "HQBaseAnnoView.h"
#import "HQBaseClusterAnnoView.h"



#pragma mark - HQBaseMapViewDelegate
@protocol HQBaseMapViewDelegate <NSObject>

/**
 *  地图聚合点的点击响应
 *  @param mapView mapView
 *  @param view    HQBaseAnnoView
 */
- (void)mapView:(MKMapView *)mapView didSelectClusterAnno:(HQBaseClusterAnnoView *)view;

/**
 *  地图标注点的点击响应
 *      !canShowCallout = YES是不响应的 默认只有带有ImageId的才支持
 *
 *  @param mapView mapView
 *  @param view    HQBaseAnnoView
 */
- (void)mapView:(MKMapView *)mapView didSelectAnno:(HQBaseAnnoView *)view;

/**
 *  气泡左视图被点击
 */
- (void)leftViewDidSelect:(id)data;

/**
 *  气泡右视图被点击
 */
- (void)rightViewDidSelect:(id)data;

@end

#pragma mark - HQBaseMapView
@interface HQBaseMapView : REVClusterMapView

@property (nonatomic,weak) id mapDelegate;
/**
 *  设置标注的图片与尺寸
 *  !尺寸只对imageId生效
 *  @param pinImage 图片
 *  @param pinSize  尺寸
 */
- (void)pinImage:(UIImage *)pinImage pinSize:(CGSize)pinSize;

/**
 *  设置聚合的图片与尺寸
 *  !尺寸只对imageId生效
 *  @param clusterImage 图片
 *  @param clusterSize  尺寸 
 */
- (void)clusterImage:(UIImage *)clusterImage clusterSize:(CGSize)clusterSize;

/**
 *  开始搜索动画
 *
 *  @param p 坐标
 */
- (void)addSearch:(CLLocationCoordinate2D)p;

/**
 *  普通标注
 *
 *  @param p 坐标
 */
- (void)addPinAnnotation:(CLLocationCoordinate2D)p;

/**
 *  停止搜索动画
 */
- (void)stopSearch;

/**
 *  放大地图
 */
- (void)zoomIn;

/**
 *  缩小地图
 */
- (void)zoomOut;

/**
 *  指定位置放大位置
 *
 *  @param region MKCoordinateRegion
 */
- (void)zoomIn:(MKCoordinateRegion) region;
@end
