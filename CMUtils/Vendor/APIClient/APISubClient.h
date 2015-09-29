//
//  APISubClient.h
//  CMUtils
//
//  Created by Jerry on 15/3/20.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef NS_ENUM(NSInteger,APIErrorCode)
{
    TOKEN_NOT_FOUND_OR_ILLEGAL  = 12000,//没传token, 或token不合法
    INVALID_SESSION             = 102001,//无效的会话参数
    SESSION_EXPIRED             = 101308,//section过期
    ACCOUNT_EXISTS              = 103005,//账号已存在
    SENDSMS_FAIL                = 110002,//短信发送失败
    CODE_EXPIRE                 = 103006,//验证码过期
    ACCOUNT_NOT_EXISTS          = 103002,//账号不存在
    INCORRECT_ACCOUNT_PASSWORD  = 103008,//账号活密码错误
    NICKNAME_EXCEEDS_LIMIT      = 100013, //昵称修改限制
    INVALID_VCODE               = 102026, //验证码错误
    SMSG_SEND_FAILED            = 110000,
    DATA_SUBMITED_TOO_OFEN      = 100008, //数据提交过于频繁
};
//passwordChange.accountOrPasswordError
typedef void (^sHandlerArray)(NSArray *array);//成功Block Type
typedef void (^sHandler)(id responseObject);//成功Block Type
typedef void (^sModelHandler)(id model);//成功Block Type
typedef void (^fHandler)(NSError *error);//成功Block Type

#define ERROR_UNKNOWN(x) \
NSError *err = [APISubClient rightResponse:responseObject];\
if(err == nil)\
{\
    err = [[NSError alloc] initWithDomain:@"未知的错误" code:-1 userInfo:responseObject];\
}\
if(x)x(err);

#define ERROR_JSONERROR(x) \
NSError *err = [APISubClient rightResponse:responseObject];\
if(err == nil)\
{\
err = [[NSError alloc] initWithDomain:@"JSON解析失败" code:-1 userInfo:responseObject];\
}\
if(x)x(err);

@interface APISubClient : NSObject

- (void)statusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block;
- (instancetype)initWithBaseURL:(NSString *)url;
- (void)setTimeout:(NSTimeInterval)timeoutInterval;
/**
 *  请求的错误处理目前没有完成,目前直接用NSError
 */
//Get请求
- (void)apiGetPath:(NSString *)path parameters:(NSDictionary *)params sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler;
//Post请求
- (void)apiPostPath:(NSString *)path parameters:(NSDictionary *)params sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler;

- (void)apiPostPath:(NSString *)path parameters:(NSDictionary *)params constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> fromData))block sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler;
//delete请求
- (void)apiDelete:(NSString *)path parameters:(NSDictionary *)params sHandler:(sHandler)sHandler fHandler:(fHandler)fHander;

/**
 *  错误码处理
 *
 *  @param responseObject 收到的数据
 *
 *  @return NSError
 */
+ (NSError *)rightResponse:(id)responseObject;

/**
 *  将响应结果转对象数组
 *
 *  @param responseObject 响应体
 *  @param cla            对象
 *  @param sHandlerArray  成功
 *  @param fHandler       失败
 */
+ (void)response2Array:(id)responseObject cla:(Class)cla sHandler:(sHandlerArray)sHandlerArray fHandler:(fHandler)fHandler;

/**
 *  将响应结果转对象
 *
 *  @param responseObject 响应体
 *  @param cla            对象
 *  @param sHandlerArray  成功
 *  @param fHandler       失败
 */
+ (void)response2Model:(id)responseObject cla:(Class)cla sHandler:(sModelHandler)sModelHandler fHandler:(fHandler)fHandler;
@end
