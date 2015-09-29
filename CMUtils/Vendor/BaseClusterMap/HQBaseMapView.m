//
//  HQBaseMapView.m
//  iBoost
//
//  Created by Jerry on 15/5/11.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "HQBaseMapView.h"
#import "SFOutAnimatedCircleView.h"
#import "HQBaseAnnotation.h"
#import "CMUtils.h"
#import <BlocksKit/BlocksKit.h>
#import <UIKit/UIKit.h>
#define TIME_SPAN               2



@interface HQBaseMapView()

@property (nonatomic,weak) SFOutAnimatedCircleView *outCircleView;


@property (nonatomic,strong) UIImage *clusterImage;
@property (nonatomic,strong) UIImage *pinImage;

@property (nonatomic,assign) CGSize clusterSize;
@property (nonatomic,assign) CGSize pinSize;
@end

@implementation HQBaseMapView

//聚合点图片与尺寸
- (void)clusterImage:(UIImage *)clusterImage clusterSize:(CGSize)clusterSize
{
    self.clusterImage = clusterImage;
    self.clusterSize  = clusterSize;
}

//标注点图片与尺寸
- (void)pinImage:(UIImage *)pinImage pinSize:(CGSize)pinSize
{
    self.pinImage = pinImage;
    self.pinSize  = pinSize;
}

#pragma mark - MKMapViewDelegate
//放置大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        REVClusterPin *anno = (REVClusterPin *)annotation;
        if ([annotation isKindOfClass:[HQSearchAnnotation class]])
        {
            NSString *identifier = @"HQSearchAnnotation";
            MKPinAnnotationView *annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            return annoView;
        }
        else if ([annotation isKindOfClass:[HQPinAnnotation class]])
        {
            NSString *identifier               = @"HQSearchAnnotation";
            MKPinAnnotationView *annoView      = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            UIButton* bt                       = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annoView.rightCalloutAccessoryView = bt;
            annoView.canShowCallout            = YES;
            annoView.selected                  = YES;
            annoView.draggable                 = YES;
            return annoView;
        }
        else if ([annotation isKindOfClass:[REVClusterPin class]])
        {
            NSString *identifier = @"HQBaseClusterAnnoView";
            //获得聚合View
            HQBaseClusterAnnoView *annoView = (HQBaseClusterAnnoView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if(annoView == nil)
            {
                annoView = [[HQBaseClusterAnnoView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            }
            //设置聚合个数
            [annoView setBadgeText:[NSString stringWithFormat:@"%@",@(anno.nodes.count)]];
            //设置大小
            annoView.imageView.frame = CGRectMake(0, 0, _clusterSize.width, _clusterSize.height);
            annoView.imageView.image = nil;
            
            HQBaseAnnotation *baseAnnotation = [anno.nodes firstObject];
            //检查标注是否带url
            if(baseAnnotation.imageId)
            {
                annoView.size = CGSizeMake(_clusterSize.width, _clusterSize.height);
                [annoView.imageView setImageWithImageId:baseAnnotation.imageId size:_clusterSize placeHolder:nil];
            }
            else
            {//没有url一定要设置默认图
                annoView.image = self.clusterImage;
            }

            return annoView;
        }
        else
        {
            NSString *identifier = @"HQBaseAnnoView";
            //获得标注View
            HQBaseAnnoView *annoView = (HQBaseAnnoView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if(annoView == nil)
            {
                annoView                = [[HQBaseAnnoView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            }
            //设置大小
            annoView.imageView.frame = CGRectMake(0, 0, _pinSize.width, _pinSize.height);
            annoView.imageView.image = nil;
            
            HQBaseAnnotation *baseAnnotation = (HQBaseAnnotation *)annotation;
            //检查标注是否带url
            if(baseAnnotation.imageId)
            {
                annoView.canShowCallout = NO;
                annoView.size = CGSizeMake(_pinSize.width, _pinSize.height);
                [annoView.imageView setImageWithImageId:baseAnnotation.imageId size:_pinSize placeHolder:nil];
            }
            else
            {//没有url一定要设置默认图
                annoView.canShowCallout = YES;
                annoView.image = self.pinImage;
            }
            
            return annoView;
        }
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *aV in views)
    {
        if ([aV.annotation isKindOfClass:[HQSearchAnnotation class]])
        {
            CGRect endFrame = aV.frame;
            aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.frame.size.height, aV.frame.size.width, aV.frame.size.height);
            [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveLinear animations:^{
                aV.frame = endFrame;
            } completion:^(BOOL finished)
            {
                if (finished)
                {
                    [self addOutCircleViewAt:CGPointMake(endFrame.origin.x+8.0f/32.0*endFrame.size.width, endFrame.origin.y + endFrame.size.height)];
                }
            }];
        }
//        else if ([aV.annotation isKindOfClass:[HQPinAnnotation class]])
//        {
//            [self selectAnnotation:aV.annotation animated:YES];
//        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if(newState == MKAnnotationViewDragStateEnding)
    {
        HQPinAnnotation *pinAnno = (HQPinAnnotation *)view.annotation;
        pinAnno.title = [NSString stringWithFormat:@"%.3f,%.3f",pinAnno.coordinate.latitude,pinAnno.coordinate.longitude];
        view.annotation = pinAnno;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[HQBaseClusterAnnoView class]])
    {
        if ([self.mapDelegate respondsToSelector:@selector(mapView:didSelectClusterAnno:)])
        {
            [self.mapDelegate mapView:mapView didSelectClusterAnno:(HQBaseClusterAnnoView *)view];
        }
    }
    else if([view isKindOfClass:[HQBaseAnnoView class]])
    {
        if ([self.mapDelegate respondsToSelector:@selector(mapView:didSelectAnno:)])
        {
            [self.mapDelegate mapView:mapView didSelectAnno:(HQBaseAnnoView *)view];
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([self.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)])
    {
        [self.delegate mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
    }
}
//添加搜索动画
- (void)addOutCircleViewAt:(CGPoint)p
{
    CGRect frame = self.bounds;
    if (self.outCircleView != nil)
    {
        [self.outCircleView removeFromSuperview];
        self.outCircleView = nil;
    }
    SFOutAnimatedCircleView *outCircleView = [[SFOutAnimatedCircleView alloc] initWithFrame:frame circleCenter:p];
    outCircleView = [[SFOutAnimatedCircleView alloc] initWithFrame:frame circleCenter:p];
    self.outCircleView = outCircleView;
    [self performSelector:@selector(stopSearch) withObject:nil afterDelay:10.0];
    [self addSubview:outCircleView];
}

//添加搜索大头针
- (void)addSearch:(CLLocationCoordinate2D)p
{
    HQSearchAnnotation *anno = [[HQSearchAnnotation alloc] init];
    anno.coordinate = p;
    [self addAnnotations:@[anno]];
}

//普通标注
- (void)addPinAnnotation:(CLLocationCoordinate2D)p
{
    HQPinAnnotation *anno = [[HQPinAnnotation alloc] init];
    anno.title = [NSString stringWithFormat:@"%0.3f,%0.3f",p.latitude,p.longitude];
    anno.coordinate = p;
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.annotations];
    [array addObject:anno];
    [self addAnnotations:array];
    [self selectAnnotation:anno animated:YES];
}

//停止搜索动画并移除大头针
- (void)stopSearch
{
    [self.outCircleView removeFromSuperview];
    self.outCircleView = nil;
    NSMutableArray *annos = [NSMutableArray array];
    for (id anno in self.annotations)
    {
        if ([anno isKindOfClass:[HQSearchAnnotation class]])
        {
            [annos addObject:anno];
        }
    }
    [self removeAnnotations:annos];
}

//放大地图
- (void)zoomIn
{
    MKCoordinateRegion region = self.region;
    MKCoordinateSpan span     = region.span;
    span.latitudeDelta /= TIME_SPAN;
    span.longitudeDelta /= TIME_SPAN;
    if (span.longitudeDelta > 0.001 && span.latitudeDelta > 0.001)
    {
        region.span = span;
        [self setRegion:region animated:YES];
    }
}

//缩小地图
- (void)zoomOut
{
    MKCoordinateRegion region = self.region;
    MKCoordinateSpan span     = region.span;
    span.latitudeDelta        *= TIME_SPAN;
    span.longitudeDelta       *= TIME_SPAN;
    if (span.longitudeDelta < 256 && span.latitudeDelta < 165)
    {
        region.span = span;
        [self setRegion:region animated:YES];
    }
}

//指定位置放大位置
- (void)zoomIn:(MKCoordinateRegion)region
{
    MKCoordinateSpan span = self.region.span;
    span.latitudeDelta /= TIME_SPAN;
    span.longitudeDelta /= TIME_SPAN;
    if (span.longitudeDelta > 0.001 && span.latitudeDelta > 0.001) {
        region.span = span;
        [self setRegion:region animated:YES];
    }
}

@end
