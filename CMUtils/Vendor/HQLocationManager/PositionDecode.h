//
//  PositionDecode.h
//  iBoost
//
//  Created by Jerry on 14-9-25.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionDecode : NSObject
//+ (void)transform:(double)wgLat wgLon:(double)wgLon mgLat:(double *)mgLat mgLon:(double *)mgLon;
void wgs2gcj(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng);
void gcj2wgs(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt);
void gcj2wgs_exact(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt);
double distance(double latA, double lngA, double latB, double lngB);
@end
