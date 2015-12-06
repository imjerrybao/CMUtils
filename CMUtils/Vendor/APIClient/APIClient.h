//
//  APIClient.h
//  CMUtils
//
//  Created by Jerry on 15/3/20.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "APISubClient.h"

@interface APIClient : NSObject
@property (nonatomic,strong) NSString *loginHost;
@property (nonatomic,strong) NSString *imageHost;
@property (nonatomic,strong) NSString *serviceHost;
@property (nonatomic,strong) NSString *imageUrlPrefix;
@property (nonatomic,strong) APISubClient *loginClient;
@property (nonatomic,strong) APISubClient *imageClient;
@property (nonatomic,strong) APISubClient *serviceClient;

+ (APIClient *)sharedInstance;

- (void)setLoginHost:(NSString *)loginHost
              imageHost:(NSString *)imageHost
            serviceHost:(NSString *)serviceHost
         imageUrlPrefix:(NSString *)imageUrlPrefix;

/**
 *  网络是否可用
 *
 *  @return 网络状态
 */
- (BOOL)isNetOk;
@end
