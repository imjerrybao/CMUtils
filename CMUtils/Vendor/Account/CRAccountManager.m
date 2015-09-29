//
//  CRAccountManager.m
//  CMUtils
//
//  Created by Jerry on 15/3/27.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "CRAccountManager.h"
#import "CMUtils.h"
#import <UIKit/UIKit.h>
#import <BlocksKit/UIAlertView+BlocksKit.h>

#define CRACCOUNTKEY ([NSString stringWithFormat:@"CRAccount_%@_0.1", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey]])
@interface CRAccountManager ()

@end
@implementation CRAccountManager
+ (CRAccountManager *)sharedInstance
{
    static CRAccountManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[CRAccountManager alloc] init];
    });
    return obj;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadCRAccount];
    }
    return self;
}

/**
 *  账户信息的读取方法
 *
 */
- (void)loadCRAccount
{
    NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:CRACCOUNTKEY];
    if (data == nil)
    {
        return;
    }
    CRAccount *crAccount = [[CRAccount alloc] initWithDictionary:data error:NULL];
    if(crAccount)
    {
        _crAccount = crAccount;
    }
    else
    {
        _crAccount = [CRAccount new];
    }
    
}

/**
 *  账户信息的存储方法
 *
 */
- (void)saveCRAccount
{
    [[NSUserDefaults standardUserDefaults] setObject:[_crAccount toDictionary] forKey:CRACCOUNTKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)autoLogout
{
    if([CRAccountManager isLogin])
    {
        UIAlertView *alert = [[UIAlertView alloc] bk_initWithTitle: Locale(@"notification.offline") message:Locale(@"notification.offlineDescription")];
        [alert bk_addButtonWithTitle:Locale(@"sm.general.ok") handler:nil];
        [alert show];
    }
    [self logout];
}

+ (void)logout
{
    CRAccount *account = [CRAccountManager sharedInstance].crAccount;
    account.userno = @"";
    account.accessToken = @"";
    [CRAccountManager sharedInstance].crAccount = account;
    [[CRAccountManager sharedInstance] saveCRAccount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CRACCOUNT_LOGOUT_NOTIFY object:nil];
}

+ (BOOL)isLogin
{
    [[CRAccountManager sharedInstance] loadCRAccount];
    CRAccount *account = [CRAccountManager sharedInstance].crAccount;
    if([NSString isBlankString:account.accessToken] || [NSString isBlankString:account.userno])
    {
        return NO;
    }
    return YES;
}

//+ (SFUserinfo *)userinfo
//{
//    return [CRAccountManager sharedInstance].crAccount.userinfo;
//}

//+ (void)setUserinfo:(SFUserinfo *)userinfo
//{
//    [CRAccountManager sharedInstance].crAccount.userinfo = userinfo;
//    [[CRAccountManager sharedInstance] saveCRAccount];
//}
@end
