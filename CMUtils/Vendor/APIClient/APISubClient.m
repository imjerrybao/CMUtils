//
//  APISubClient.m
//  CMUtils
//
//  Created by Jerry on 15/3/20.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "APISubClient.h"
#import "APIErrorCodeCache.h"
#import "UIDevice+hardware.h"
#import "APIRequestOperationManager.h"
#import "CMUtils.h"
#import <JSONModel/JSONModel.h>
#define ERROR_EXPLAIN @"\n  **********************************\n\
  *操作:%@\n\
  *请求:%@\n\
  *状态:%d\n\
  *说明:%@\n  **********************************\n\n"

@interface APISubClient()
@property (nonatomic,strong) APIRequestOperationManager *request;
@end
@implementation APISubClient

- (instancetype)initWithBaseURL:(NSString *)url
{
    self = [super init];
    if(self)
    {
        self.request = [[APIRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
        [self setTimeout:20.0f];
        [self setUserAgent];
        AFSecurityPolicy *s = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        s.allowInvalidCertificates = YES;
        [self.request setSecurityPolicy:s];
    }
    return self;
}

- (void)setTimeout:(NSTimeInterval)timeoutInterval
{
    [self.request.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.request.requestSerializer.timeoutInterval = timeoutInterval;
    [self.request.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

- (void)setUserAgent
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSString *geohash = [[HQLocationManager sharedInstance] lastGeoHash];
    NSString *UserAgent = [NSString stringWithFormat:@"%@/%@ (iOS %@; %@; %@; %@; Scale/%0.2f;%@)"
                           , [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey]
                           , [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey]
                           , [[UIDevice currentDevice] systemVersion]
                           , [[UIDevice currentDevice] platform]
                           , [CMConfig getCurrentLanguage]
                           , [NSString stringWithFormat:@"%d*%d", (int)([UIScreen mainScreen].bounds.size.width * scale), (int)([UIScreen mainScreen].bounds.size.height * scale)]
                           , scale
                           , geohash?geohash:@""];
    [self.request.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
}

- (void)apiGetPath:(NSString *)path parameters:(NSDictionary *)params sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler;
{
    [self.request GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = [APISubClient rightResponse:responseObject];
        DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
        if(err.code == 0)
        {
            if(sHandler)sHandler(responseObject);
        }
        else
        {
            if(fHandler)fHandler(err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [APISubClient rightResponse:operation.responseObject];
        if(err == nil)
        {
            err = error;
        }
        DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
        if(fHandler)fHandler(err);
    }];
}


- (void)apiPostPath:(NSString *)path parameters:(NSDictionary *)params sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler
{
    [self.request POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *err = [APISubClient rightResponse:responseObject];
         DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
         if (err.code == 0)
         {
             if (sHandler)
             {
                 sHandler(responseObject);
             }
         } else
         {
             if (fHandler)
             {
                 fHandler(err);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [APISubClient rightResponse:operation.responseObject];
        DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
        if(err == nil)
        {
            err = error;
        }
        if(fHandler)fHandler(err);
    }];
    
}

- (void)apiPostPath:(NSString *)path parameters:(NSDictionary *)params constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> fromData))block sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler
{
    [self.request POST:path parameters:params constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = [APISubClient rightResponse:responseObject];
        DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
        if (err.code == 0)
        {
            if (sHandler)
            {
                sHandler(responseObject);
            }
        } else
        {
            if (fHandler)
            {
                fHandler(err);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [APISubClient rightResponse:operation.responseObject];
        DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
        if(err == nil)
        {
            err = error;
        }
        if(fHandler)fHandler(err);
    }];
}

- (void)apiDelete:(NSString *)path parameters:(NSDictionary *)params sHandler:(sHandler)sHandler fHandler:(fHandler)fHander
{
    [self.request DELETE:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = [APISubClient rightResponse:responseObject];
        DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
        if (err.code == 0) {
            if (sHandler) {
                sHandler(responseObject);
            } else {
                if (fHander) {
                    fHander(err);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [APISubClient rightResponse:operation.responseObject];
        DDLogInfo(ERROR_EXPLAIN,operation.request.HTTPMethod,operation.request.URL,err.code,err.domain);
        if(err == nil)
        {
            err = error;
        }
        if(fHander)fHander(err);
    }];
}

//检查请求的错误码
+ (NSError *)rightResponse:(id)responseObject
{
    if(![responseObject isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    NSNumber *code = [(NSDictionary *)responseObject objectForKey:@"code"];
    if(code == nil)
    {//一个古老的错误码
        code = [(NSDictionary *)responseObject objectForKey:@"ret"];
    }
    if(code == nil)
    {
        return nil;
    }
    NSString *errorContent = [[APIErrorCodeCache sharedInstance] errorContentWithCode:code];
    if (errorContent == nil)
    {
        errorContent = @"code=0是正确.查询不到code.没有错误信息.(CMErrorCode.txt没有更新?服务的新的错误码?)";
    }
    NSError *error = [[NSError alloc] initWithDomain:errorContent
                                                code:[code integerValue]
                                            userInfo:responseObject];
    if([code integerValue] == 0)
    {
//        DDLogInfo(@"%@",errorContent);
    }
    else
    {
        NSString *errorText = nil;
        switch ([code integerValue])
        {
            case INVALID_SESSION:case SESSION_EXPIRED:case TOKEN_NOT_FOUND_OR_ILLEGAL:
            {
                [CRAccountManager autoLogout];
            }
                break;
            case ACCOUNT_EXISTS:
            {
                errorText = Locale(@"registerView.phoneHasRegistered");
                return error;
            }
                break;
            case SENDSMS_FAIL:
            {
                errorText = Locale(@"app.msgSendFailure");
            }
                break;
            case CODE_EXPIRE:
            {
                errorText = Locale(@"registerView.codeExpire");
            }
                break;
            case ACCOUNT_NOT_EXISTS:
            {
                errorText = Locale(@"registerView.accountNotExist");
            }
                break;
            case INCORRECT_ACCOUNT_PASSWORD:
            {
                errorText = Locale(@"passwordChange.accountOrPasswordError");
            }
                break;
            case INVALID_VCODE:
            {
                errorText = Locale(@"app.securityCodeError");
            }
                break;
            case  SMSG_SEND_FAILED:{
                errorText = Locale(@"app.messageFailure");
            }
                break;
            default:
            {
                errorText = Locale(@"app.networkError");
            }
                break;
        }

        [MBProgressHUD textHudInView:UIKeyWindow text:errorText isCover:NO delay:3.0f];
//        DDLogError(@"错误信息(code=%@):%@",code,errorContent);
        
    }
    
    return error;
}

/**
 *  监听网络状态
 *
 *  @param block 得到的状态block
 */
- (void)statusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block
{
    //监听网络状态
    [self.request.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLOG(@"3G网络已连接");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLOG(@"WiFi网络已连接");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLOG(@"网络连接失败");
                break;
                
            default:
                break;
        }
    }];
    [self.request.reachabilityManager startMonitoring];
}

+ (void)response2Array:(id)responseObject cla:(Class)cla sHandler:(sHandlerArray)sHandlerArray fHandler:(fHandler)fHandler
{
    if([responseObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[responseObject count]];
        for (NSDictionary *map in responseObject)
        {
            id obj = [[cla alloc] initWithDictionary:map error:NULL];
            if(obj)
                [array addObject:obj];
        }
        if (sHandlerArray)
        {
            sHandlerArray(array);
        }
    }
    else
    {
        ERROR_UNKNOWN(fHandler)
    }
}

+ (void)response2Model:(id)responseObject cla:(Class)cla sHandler:(sModelHandler)sModelHandler fHandler:(fHandler)fHandler
{
    if([responseObject isKindOfClass:[NSDictionary class]])
    {
        id obj = [[cla alloc] initWithDictionary:responseObject error:NULL];
        if(obj)
        {
            if (sModelHandler)
            {
                sModelHandler(obj);
            }

        }
        else
        {
            ERROR_JSONERROR(fHandler);
        }
    }
    else
    {
        ERROR_UNKNOWN(fHandler)
    }
}

@end
