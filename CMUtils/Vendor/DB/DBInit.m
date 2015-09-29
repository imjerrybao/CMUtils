//
//  DBInit.m
//  CMUtils
//
//  Created by Jerry on 15/4/8.
//  Copyright (c) 2015年 Jerry Inc. All rights reserved.
//

#import "DBInit.h"
#import "CMUtils.h"
#import "HQDatabaseManager.h"

/****库名****/
#define DATA_DB @"data.db"

@implementation DBInit
+ (void)dbInitWithClasses:(NSArray *)classes
{
    if ([AppStartManager firstEnter:APP_START_NUMBER])
    {
        NSString *docPath = [DirectoryUtil docPath];
        docPath = [docPath stringByAppendingPathComponent:DATA_DB];
        NSFileManager *filemanager = [[NSFileManager alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"db"];
        [filemanager copyItemAtPath:path toPath:docPath error:NULL];
    }

    [[HQDatabaseManager sharedInstance] createDBQueue:DATA_DB withTalbe:classes]; //@[[ADModel class]]
}


@end
