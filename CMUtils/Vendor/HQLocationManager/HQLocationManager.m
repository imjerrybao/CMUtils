//
//  HQLocationManager.m
//  CMUtils
//
//  Created by Jerry on 15/3/31.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "HQLocationManager.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "GeoHash.h"
#import "PositionDecode.h"
#import "CMConfig.h"
#define HQLAST_LOCATION @"HQLAST_LOCATION"
@interface HQLocationManager()<CLLocationManagerDelegate>
{
    CLLocation *_lastLocation;
}

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSMutableArray *locationResponses;
@property (nonatomic,assign) BOOL uploadError;
@end

@implementation HQLocationManager
+ (instancetype)sharedInstance
{
    static HQLocationManager *_sharedInstance;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (HQLocationServicesState)locationServicesState
{
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        return HQLocationServicesStateDisabled;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        return HQLocationServicesStateNotDetermined;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        return HQLocationServicesStateDenied;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        return HQLocationServicesStateRestricted;
    }
    
    return HQLocationServicesStateAvailable;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _locationManager                 = [[CLLocationManager alloc] init];
        _locationManager.delegate        = self;
        _locationManager.distanceFilter  = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationResponses               = [NSMutableArray array];
        
    }
    return self;
}

- (void)startUpdatingLocationWithCallback:(locationResponseBlock)loctaionResponse
{
    [self.locationResponses addObject:loctaionResponse];
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
        BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
        if (hasAlwaysKey)
        {
            [self.locationManager requestAlwaysAuthorization];
        } else if (hasWhenInUseKey)
        {
            [self.locationManager requestWhenInUseAuthorization];
        } else
        {
            NSAssert(hasAlwaysKey || hasWhenInUseKey, @"在IOS 8+使用定位服务,你需要在Info.plist 添加NSLocationWhenInUseUsageDescription 或 NSLocationAlwaysUsageDescription.");
        }
    }
#endif
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self completeAllLocationResponses];
    [self.locationManager stopUpdatingLocation];
}

- (void)completeAllLocationResponses
{
    HQLocationServicesState status = [HQLocationManager locationServicesState];
    NSArray *array = [NSArray arrayWithArray:self.locationResponses];
    for (locationResponseBlock loctaionResponse in array)
    {
        double lon;
        double lat;
        wgs2gcj(self.lastLocation.coordinate.latitude,self.lastLocation.coordinate.longitude,&lat,&lon);
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        loctaionResponse(location,status);
        [self.locationManager stopUpdatingLocation];
        [self.locationResponses removeObject:loctaionResponse];
    }
}

- (void)processLocationResponses
{
    [self completeAllLocationResponses];
}

+ (NSString *)geohash:(CLLocation *)location
{
    if(location)
        return [GeoHash hashForLatitude:location.coordinate.latitude longitude:location.coordinate.longitude length:8];
    return nil;
}

- (NSString *)lastGeoHash
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:HQLAST_LOCATION];
}

- (void)setLastLocation:(CLLocation *)lastLocation
{
    _lastLocation = lastLocation;
    NSString *geohash = [HQLocationManager geohash:lastLocation];
    [[NSUserDefaults standardUserDefaults] setObject:geohash forKey:HQLAST_LOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CLLocation *)lastLocation
{
    NSString *geohash = [[NSUserDefaults standardUserDefaults] objectForKey:HQLAST_LOCATION];
    if(_lastLocation == nil && geohash)
    {
        GHArea *geo = [GeoHash areaForHash:geohash];
        _lastLocation = [[CLLocation alloc] initWithLatitude:geo.latitude.min.doubleValue longitude:geo.longitude.min.doubleValue];
    }
    return _lastLocation;
}

+ (CLLocation *)geohast2location:(NSString *)geohash
{
    GHArea *geo = [GeoHash areaForHash:geohash];
    if (geo)
    {
        CLLocation  *loc = [[CLLocation alloc] initWithLatitude:geo.latitude.min.doubleValue longitude:geo.longitude.min.doubleValue];
        return loc;
    }
    return nil;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.lastLocation = [locations lastObject];
    self.uploadError = NO;
    [self processLocationResponses];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLOG(@"位置更新错误: %@", [error localizedDescription]);
    self.uploadError = YES;
    [self processLocationResponses];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
    {
        DLOG(@"定位服务受限");
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
#else
    else if (status == kCLAuthorizationStatusAuthorized)
    {
#endif /* __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 */
    }
        
}


    
    
@end

