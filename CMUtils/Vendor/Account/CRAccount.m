//
//  CRAccount.m
//  CMUtils
//
//  Created by Jerry on 15/3/27.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "CRAccount.h"

@implementation AccountInfo

@end

@implementation CRAccount
//目前版本(1.0)使用只STN
- (CGFloat)amount
{
    NSArray *account = self.account;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"currency = %@",@"STN"];
    AccountInfo *accountInfo =[[account filteredArrayUsingPredicate:pred] lastObject];
    if(accountInfo.amount)
    {
        return [accountInfo.amount floatValue];
    }
    else
    {
        return 0.0f;
    }
}

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"sessionid":@"accessToken",
                                                       }];
}

@end

