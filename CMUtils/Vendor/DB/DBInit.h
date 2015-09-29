//
//  DBInit.h
//  CMUtils
//
//  Created by Jerry on 15/4/8.
//  Copyright (c) 2015年 Jerry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBInit : NSObject
/**
 *  数据库初始化
 *
 *  @param classes 模型类数组，例如@[[ClassNameA clsss], [ClassNameB clsss], ...]
 */
+ (void)dbInitWithClasses:(NSArray *)classes;
@end
