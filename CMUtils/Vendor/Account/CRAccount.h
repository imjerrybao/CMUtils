//
//  CRAccount.h
//  CMUtils
//
//  Created by Jerry on 15/3/27.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "JSONModel.h"
#import "Userinfo.h"
#import <UIKit/UIKit.h>

/**
 *  积分信息
 */
@protocol AccountInfo
@end

@interface AccountInfo : JSONModel
@property (nonatomic,strong) NSString *accountid;
@property (nonatomic,strong) NSString *amount;      //积分
@property (nonatomic,strong) NSString *currency;    //币种
@property (nonatomic,strong) NSString *flag;
@end
/**
 *  账户信息
 */
@interface CRAccount : Userinfo

@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString<Optional> *aed_price;
@property (nonatomic,strong) NSArray<AccountInfo,Optional> *account;

/**
 *  获得我的积分
 *
 *  @return 积分字符串
 */
- (CGFloat)amount;
@end
