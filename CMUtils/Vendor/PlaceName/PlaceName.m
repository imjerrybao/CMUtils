//
//  PlaceName.m
//  iBoost
//
//  Created by Jerry on 14-6-24.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#import "PlaceName.h"
#import "CMUtils.h"
#import <AFNetworking/AFNetworking.h>

@implementation PlaceName

#pragma mark - 获取位置信息
+ (PlaceName *)sharedInstance {
    static PlaceName *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[PlaceName alloc] init];
    });
    return obj;
}

- (void)getPlaceNameWithLocation:(CLLocation *)loacation andBlogID:(NSString *)topicID isBranch:(BOOL)isBranch completion:(void(^)(NSString *result))completion
{
    if (_locationCache == nil) {
        _locationCache = [[NSCache alloc] init];
    }
    if (self.geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    if (loacation == nil) {
        
        return;
    }
    NSString *loc = [self getCachedLocationBy:loacation isBranch:isBranch];
    
    if (![NSString isBlankString:loc])
    {
        if (completion)
        {
            completion(loc);
        }
        if (![NSString isBlankString:topicID])
        {
            if (![NSString isBlankString:loc]) {
//                [[ApiClient sharedInstance] uploadTopicAddr:topicID lang:[CMConfig getCurrentLanguage] location:loc success:^{
//                    
//                } fail:^(FailResponse *fali) {
//                    
//                }];
            }
        }
        return;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:loacation completionHandler:^(NSArray *placemarks, NSError *error) {
        BOOL isEnglish = NO;
        isEnglish = [[CMConfig getCurrentLanguage] isEqualToString:@"en"];
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *result = @"";
            if (isBranch)//国家分行显示
            {
                if(isEnglish)
                {
                    result = [@"\n" stringByAppendingString:placemark.country];
                }
                else
                {
                    result = [placemark.country stringByAppendingString:@"\n"];
                }
                if(placemark.locality!=nil){
                    if (isEnglish)
                    {
                        result =[NSString stringWithFormat:@"%@%@",placemark.locality,result];
                    }
                    else
                    {
                        result =[NSString stringWithFormat:@"%@%@",result,placemark.locality];
                    }
                }
                if(placemark.thoroughfare!=nil)
                {
                    if(![placemark.thoroughfare isEqualToString:@"Unnamed Road"])//unnamed road
                    {
                        if (isEnglish)
                        {
                            result =[NSString stringWithFormat:@"%@,%@",placemark.thoroughfare,result];
                        }
                        else
                        {
                            result =[NSString stringWithFormat:@"%@ %@",result,placemark.thoroughfare];
                        }
                    }
                }
            }
            else//正常显示
            {
                if(placemark.country!=nil){
                    result=placemark.country;
                }
                if(placemark.locality!=nil){
                    if (isEnglish)
                    {
                        result =[NSString stringWithFormat:@"%@,%@",placemark.locality,result];
                    }
                    else
                    {
                        result =[NSString stringWithFormat:@"%@ %@",result,placemark.locality];
                    }
                }
                if(placemark.thoroughfare!=nil)
                {
                    if(![placemark.thoroughfare isEqualToString:@"Unnamed Road"])//unnamed road
                    {
                        if (isEnglish)
                        {
                            result =[NSString stringWithFormat:@"%@,%@",placemark.thoroughfare,result];
                        }
                        else
                        {
                            result =[NSString stringWithFormat:@"%@ %@",result,placemark.thoroughfare];
                        }
                    }
                }
            }
            [self setCachedLocationBy:loacation value:result isBranch:isBranch];
            if (completion)
            {
//                if (![NSString isBlankString:topicID])
//                {
//                    if (![NSString isBlankString:result]) {
//                        [[ApiClient sharedInstance] uploadTopicAddr:topicID lang:[CMConfig getCurrentLanguage] location:result success:^{
//                            
//                        } fail:^(FailResponse *fali) {
//                            
//                        }];
//                    }
//                }
                completion(result);
            }
        }
        
        if (error) {
            double lat = loacation.coordinate.latitude;
            double lon = loacation.coordinate.longitude;
            NSString *langua;
            if ([[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) {        // 简体中文
                langua = @"zh_CN";
            }
            else if ([[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]){     // 繁体中文
                langua = @"zh_TW";
            }else if ([[CMConfig getCurrentLanguage] isEqualToString:@"ja"]){          // 日文
                langua = @"ja";
            }
            else{                                                                             // 英文
                langua = @"en";
            }
            //latlng=30,120&language=zh_CN&sensor=false
            NSString *urlHost = [[[NSUserDefaults standardUserDefaults] objectForKey:MobileIsoCountryCode] isEqualToString:@"cn"] ?@"http://ditu.google.cn":@"http://maps.googleapis.com";
            NSString *str = [NSString stringWithFormat:@"%@/maps/api/geocode/json?latlng=%f,%f&language=%@&sensor=false",urlHost,lat,lon,langua];
            NSURL *url = [NSURL URLWithString:str];
            //GET请求
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setTimeoutInterval:20];//设置请求时间
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary* dic =[[NSJSONSerialization
                                     JSONObjectWithData:responseObject//1
                                     options:kNilOptions
                                     error:nil] copy];//以JSON格式获取数据
                
                if (dic)
                {
                    NSString *country;
                    NSString *locality;
                    NSString *route;
                    NSString *result = @"";
                    NSArray *results = [dic objectForKey:@"results"];
                    if (results && results.count > 0) {
                        NSArray *address_components = [[results objectAtIndex:0] objectForKey:@"address_components"];
                        for (int i = 0; i < address_components.count; ++i) {
                            NSDictionary *dic = [address_components objectAtIndex:i];
                            if (((NSArray *)[dic objectForKey:@"types"]).count > 0) {
                                if ([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"country"]){
                                    country = [dic objectForKey:@"long_name"];
                                }
                                
                                if ([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"locality"]){
                                    locality = [dic objectForKey:@"long_name"];
                                }
                                if ([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"route"]){
                                    route = [dic objectForKey:@"long_name"];
                                }
                            }
                            
                        }
                    }
                    
                    if (isBranch)
                    {
                        if (country != nil)
                        {
                            if(isEnglish)
                            {
                                result =[NSString stringWithFormat:@"\n%@",country];
                            }
                            else
                            {
                                result =[NSString stringWithFormat:@"%@\n",country];
                            }
                        }
                        if(locality!=nil){
                            if (isEnglish)
                            {
                                result =[NSString stringWithFormat:@"%@%@",locality,result];
                            }
                            else
                            {
                                result =[NSString stringWithFormat:@"%@%@",result,locality];
                            }
                        }
                        if(route!=nil){
                            if (isEnglish) {
                                result =[NSString stringWithFormat:@"%@,%@",route,result];
                            }else{
                                result =[NSString stringWithFormat:@"%@ %@",result,route];
                            }
                        }
                        
                    }
                    else
                    {
                        if (country != nil){
                            result =[NSString stringWithFormat:@"%@",country];
                        }
                        if(locality!=nil){
                            if (isEnglish) {
                                result =[NSString stringWithFormat:@"%@,%@",locality,result];
                            }else{
                                result =[NSString stringWithFormat:@"%@ %@",result,locality];
                            }
                        }
                        if(route!=nil){
                            if (isEnglish) {
                                result =[NSString stringWithFormat:@"%@,%@",route,result];
                            }else{
                                result =[NSString stringWithFormat:@"%@ %@",result,route];
                            }
                        }
                    }
                    
                    [self setCachedLocationBy:loacation value:result isBranch:isBranch];
                    if (completion)
                    {
//                        if (![NSString isBlankString:topicID])
//                        {
//                            if (![NSString isBlankString:result]) {
//                                [[ApiClient sharedInstance] uploadTopicAddr:topicID lang:[CMConfig getCurrentLanguage] location:result success:^{
//                                    
//                                } fail:^(FailResponse *fali) {
//                                    
//                                }];
//                            }
//                        }
                        
                        completion(result);
                    }
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DLOG(@"%@",error);
            }];
            [operation start];
            
        }
        
        
    }];
}

- (void)getPlaceNameWithLocation: (CLLocation *)loacation andBlogID: (NSString *)topicID completion:(void(^)(NSString *result))completion
{
    [self getPlaceNameWithLocation:loacation andBlogID:topicID isBranch:NO completion:completion];
}

- (void) getPlaceNameWithLocation: (CLLocation *)loacation andBlogID: (NSString *)topicID andlabLocation: (UILabel *)labLocation
{
    [self getPlaceNameWithLocation:loacation andBlogID:topicID completion:^(NSString *result) {
        labLocation.text = result;
    }];
}

- (void)setCachedLocationBy:(CLLocation *)location value:(NSString *)value
{
    [self setCachedLocationBy:location value:value isBranch:NO];
}

- (void)setCachedLocationBy:(CLLocation *)location value:(NSString *)value isBranch:(BOOL)isBranch
{
    if (location == nil || value == nil)
    {
        return;
    }
    double lat = location.coordinate.latitude, lng = location.coordinate.longitude;
    NSString *cacheKey;
    if(isBranch)//分行特殊存储
    {
        cacheKey = [NSString stringWithFormat:@"%d,%dB", (int)(lat * 1000), (int)(lng * 1000)];
    }
    else
    {
        cacheKey = [NSString stringWithFormat:@"%d,%d", (int)(lat * 1000), (int)(lng * 1000)];
    }
    
    [self.locationCache setObject:value forKey:cacheKey];
}

- (NSString *)getCachedLocationBy:(CLLocation *)location isBranch:(BOOL)isBranch
{
    if (location == nil) {
        return nil;
    }
    double lat = location.coordinate.latitude, lng = location.coordinate.longitude;
    // 精度在 0.001一下的都认为是同一个地点
    NSString *cacheKey;
    if (isBranch)
    {
        cacheKey = [NSString stringWithFormat:@"%d,%dB", (int)(lat * 1000), (int)(lng * 1000)];
    }
    else
    {
        cacheKey = [NSString stringWithFormat:@"%d,%d", (int)(lat * 1000), (int)(lng * 1000)];
    }
    
    
    return [self.locationCache objectForKey:cacheKey];
}

- (NSString *)getCachedLocationBy:(CLLocation *)location
{
    return [self getCachedLocationBy:location isBranch:NO];
}

@end


