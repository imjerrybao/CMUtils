//
//  Userinfo.h
//  iBoost
//
//  Created by Jerry on 15/7/22.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "JSONModel.h"
/**
 *  用户信息
 */
@interface Userinfo : JSONModel

@property (nonatomic,strong) NSString *userno;         //用户ID
@property (nonatomic,strong) NSString *avatar;         //头像
@property (nonatomic,assign) int        gender;        //性别 1: 男; 2: 女; 0: 未知 default: 0
@property (nonatomic,strong) NSString *nickname;       //昵称
@property (nonatomic,assign) long long lasttime;       //最后上线时间,我的(返回按钮)

@property (nonatomic,strong) NSString<Optional> *sign;            //个性签名
@property (nonatomic,strong) NSString<Optional> *birthday;        //生日
@property (nonatomic,strong) NSString<Optional> *idd;             //国家码
@property (nonatomic,strong) NSString<Optional> *mobile;          //手机号
@property (nonatomic,strong) NSArray<Optional>  *tags;            //感兴趣栏目

@end
