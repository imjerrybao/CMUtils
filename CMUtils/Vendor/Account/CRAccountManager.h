//
//  CRAccountManager.h
//  CMUtils
//
//  Created by Jerry on 15/3/27.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRAccount.h"

#define CRACCOUNT_LOGIN_NOTIFY @"CRACCOUNT_LOGIN_NOTIFY"  //单位设置改变的通知
#define CRACCOUNT_LOGOUT_NOTIFY @"CRACCOUNT_LOGOUT_NOTIFY"  //单位设置改变的通知
#define CRACCOUNT_RELOAD_NOTIFY @"CRACCOUNT_RELOAD_NOTIFY"//页面刷新

@interface CRAccountManager : NSObject

@property (nonatomic,strong) CRAccount *crAccount;

+ (CRAccountManager *)sharedInstance;

/**
 *  保存账户信息到本地
 *
 */
- (void)saveCRAccount;

/**
 *  从本地读取账户信息
 *
 */
- (void)loadCRAccount;

/**
 *  退出登陆
 */
+ (void)logout;

/**
 *  自动登出
 */
+ (void)autoLogout;

/**
 *  登陆状态
 *  !!!这个方法从本地数据中读取信息,内存中的信息不用,请注意
 *  @return 返回登陆状态
 */
+ (BOOL)isLogin;

/**
 *  获得个人信息
 *
 *  @return 获得个人信息
 */
//+ (SFUserinfo *)userinfo;

/**
 *  修改个人信息
 *
 *  @param userinfo 个人信息实例
 */
//+ (void)setUserinfo:(SFUserinfo *)userinfo;
@end
