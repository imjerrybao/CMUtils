//
//  HQModel.m
//  CMUtils
//
//  Created by Jerry on 15/4/3.
//  Copyright (c) 2015年 Jerry Inc. All rights reserved.
//

#import "HQModel.h"
#import "HQDatabaseManager.h"
#import "HQModelClassProperty.h"
#import "objc/message.h"
#import "CMUtils.h"
@implementation HQModel
+ (void)initialize
{
    Class cls = [self class];
    if (cls == [HQModel class]) {
        return;
    }
    [[HQDatabaseManager sharedInstance] inspectDBModel:cls];
}
//@"f":@"float", @"i":@"int", @"d":@"double", @"l":@"long", @"c":@"BOOL", @"s":@"short", @"q":@"long", @"I":@"NSInteger", @"Q":@"NSUInteger", @"B":@"BOOL", @"@?":@"Block"
- (instancetype)initWithResultSet:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
        id value = nil;
        for (HQModelClassProperty *dbProperty in dbModelMetadate.propertys)
        {
            if([dbProperty.type isEqualToString:@"NSDate"])
            {
                value = [rs dateForColumn:dbProperty.name];
            }
            else if([dbProperty.type isEqualToString:@"NSData"])
            {
                value = [rs dataForColumn:dbProperty.name];
            }
            else if(([dbProperty.type isEqualToString:@"f"]) || ([dbProperty.type isEqualToString:@"d"]))
            {
                value = @([rs doubleForColumn:dbProperty.name]);
            }
            else if([dbProperty.type isEqualToString:@"c"] || [dbProperty.type isEqualToString:@"B"])
            {
                value = @([rs boolForColumn:dbProperty.name]);
            }
            else if([dbProperty.type isEqualToString:@"i"] || [dbProperty.type isEqualToString:@"I"])
            {
                value = @([rs intForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"l"])
            {
                value = @([rs longForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"q"])
            {
                value = @([rs longLongIntForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"Q"])
            {
                value = @([rs unsignedLongLongIntForColumn:dbProperty.name]);
            }
            else
            {
                value = [rs objectForColumnName:dbProperty.name];
            }
            
            if(![value isKindOfClass:[NSNull class]])
            {
                [self setValue:value forKey:dbProperty.name];
            }
            
        }
    }
    return self;
}

+ (BOOL)executeUpdate:(NSString *)sql
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}


+ (NSString *)create
{
    return [[HQDatabaseManager sharedInstance] dbModelMetadate:self].createSQL;
}

+ (NSString *)insert
{
    return [[HQDatabaseManager sharedInstance] dbModelMetadate:self].insertSQL;
}

- (BOOL)insert
{
    Class cla = [self class];
    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:dbModelMetadate.insertSQL withParameterDictionary:[self toDictionary]];
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    
    return success;
}

+ (BOOL)insertAll:(NSArray *)dataSource
{
    Class cla = [self class];
    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:cla];
    __block BOOL success = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (id obj in dataSource)
        {
            success = [db executeUpdate:dbModelMetadate.insertSQL withParameterDictionary:[obj toDictionary]];
        }
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

- (BOOL)delete
{
    Class cla = [self class];
    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    id keyValue = objc_msgSend(self,NSSelectorFromString(dbModelMetadate.primaryKey));
    
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:dbModelMetadate.delectSQL,keyValue];
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

+ (BOOL)deleteAll
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ ",NSStringFromClass(cla)]];
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

+ (BOOL)deleteByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",NSStringFromClass(cla),propertyName],propertyValue];
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

- (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    id keyValue = objc_msgSend(self,NSSelectorFromString(dbModelMetadate.primaryKey));
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",NSStringFromClass(cla),propertyName,dbModelMetadate.primaryKey],propertyValue,keyValue];
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

+ (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue keyValue:(id)keyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        if(keyValue)
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",NSStringFromClass(cla),propertyName,dbModelMetadate.primaryKey],propertyValue,keyValue];
        }
        else
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? ",NSStringFromClass(cla),propertyName],propertyValue];
        }
        
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

+ (BOOL)updateByWHERE:(NSString *)sql propertyName:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@",NSStringFromClass(cla),propertyName,sql],propertyValue];
    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

+ (BOOL)updateByPropertyMaps:(NSDictionary *)propertyMaps updatePropertyMaps:(NSDictionary *)updatePropertyMaps
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        
        NSMutableString *where = [NSMutableString string];
        NSMutableString *set = [NSMutableString string];
        NSArray *allKeys = [propertyMaps allKeys];
        
        for ( int i=0; i<allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if(i == allKeys.count -1)
            {
                [where appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [where appendFormat:@" %@ = :%@,",key,key];
            }
        }
        
        allKeys = [updatePropertyMaps allKeys];
        
        for ( int i=0; i<allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if(i == allKeys.count-1 )
            {
                [where appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [where appendFormat:@" %@ = :%@ AND",key,key];
            }
        }
        
        if(set.length == 0)
        {
            success = NO;
            return;
        }
        
        if(where.length)
        {
            NSMutableDictionary *maps = [NSMutableDictionary dictionaryWithDictionary:propertyMaps];
            [maps addEntriesFromDictionary:updatePropertyMaps];
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",NSStringFromClass(cla),set,where] withParameterDictionary:maps];
        }
        else
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@",NSStringFromClass(cla),set]];
        }

    }];
#ifdef DEBUG
    if(success)
        DDLogInfo(@"%s:操作成功",__FUNCTION__);
    else
        DDLogError(@"%s:操作失败",__FUNCTION__);
#endif
    return success;
}

+ (NSArray *)all
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue * queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}


+ (NSArray *)selectByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",NSStringFromClass(cla),propertyName],propertyValue];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

+ (NSArray *)selectByPropertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableString *where = [NSMutableString string];
        NSArray *allKeys = [propertyMaps allKeys];
        for (int i = 0; i< allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if( i == allKeys.count -1 )
            {
                [where appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [where appendFormat:@" %@ = :%@ AND",key,key];
            }
        }

        FMResultSet *rs;
        if(where.length)
        {
            rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",NSStringFromClass(cla),where] withParameterDictionary:propertyMaps];
        }
        else
        {
            rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
        }
        
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

+ (NSArray *)selectBySQL:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db)
    {
        FMResultSet *rs = [db executeQuery:sql withParameterDictionary:propertyMaps];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            if(keyValue)
            {
                [array addObject:obj];
            }
            
        }
        [rs close];
    }];
    return array;
}


+ (NSArray *)selectByWHERE:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[HQDatabaseManager sharedInstance] getDBQueueWithClass:cla];
    HQModelMetadate *dbModelMetadate = [[HQDatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",NSStringFromClass(cla),sql] withParameterDictionary:propertyMaps];
         while ([rs next])
         {
             id obj = [[cla alloc] initWithResultSet:rs];
             id keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
             if(keyValue)
             {
                 [array addObject:obj];
             }
         }
         [rs close];
     }];
    return array;
}


@end
