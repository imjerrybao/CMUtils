//
//  APIClient.m
//  CMUtils
//
//  Created by Jerry on 15/3/20.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "APIClient.h"


static APIClient *_sharedClient = nil;
@interface APIClient ()
@property AFNetworkReachabilityStatus status;
@end

@implementation APIClient
+ (APIClient *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] init];
    });
    return _sharedClient;
}

- (void)setLoginHost:(NSString *)loginHost
              imageHost:(NSString *)imageHost
            serviceHost:(NSString *)serviceHost
         imageUrlPrefix:(NSString *)imageUrlPrefix
{
    self.loginClient   = [[APISubClient alloc] initWithBaseURL:loginHost];
    self.imageClient   = [[APISubClient alloc] initWithBaseURL:imageHost];
    self.serviceClient = [[APISubClient alloc] initWithBaseURL:serviceHost];
    _imageUrlPrefix = imageUrlPrefix;
    [self onNetwork];
}

//监听网络状态
- (void)onNetwork
{
    __weak APIClient *wSelf = self;
    [self.serviceClient statusChangeBlock:^(AFNetworkReachabilityStatus status) {
        wSelf.status = status;
    }];
}


- (BOOL)isNetOk
{
    return (self.status == AFNetworkReachabilityStatusReachableViaWWAN) || (self.status == AFNetworkReachabilityStatusReachableViaWiFi)|| (self.status == AFNetworkReachabilityStatusUnknown)|| (self.status == AFNetworkReachabilityStatusNotReachable);
}
@end
