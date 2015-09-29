//
//  HQBaseAnnotation.h
//  iBoost
//
//  Created by Jerry on 15/5/14.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//地图标注
@interface HQBaseAnnotation : NSObject<MKAnnotation>
//增加一个标志,可以支持多种类型的标注
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSString *imageId;//图片URL
@property (nonatomic,strong) id data;//存放标注对应的数据
@end

//大头针标注
@interface HQPinAnnotation : NSObject<MKAnnotation>
@property (nonatomic,copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

//搜索标注
@interface HQSearchAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
