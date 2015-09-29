//
//  HQModelMetadate.m
//  CMUtils
//
//  Created by Jerry on 15/4/3.
//  Copyright (c) 2015年 Jerry Inc. All rights reserved.
//

#import "HQModelMetadate.h"
#import "HQDatabaseManager.h"
#import "HQModelClassProperty.h"
@implementation HQModelMetadate


- (instancetype)initWithClass:(Class)class
{
    self = [super init];
    if (self)
    {
        [self inspectProperty:class];
    }
    return self;
}

- (void)inspectProperty:(Class)class
{
    NSUInteger count               = 0;
    NSString *className            = NSStringFromClass(class);
    NSMutableArray *tempProperties = [NSMutableArray array];
    objc_property_t *properties    = class_copyPropertyList(class, &count);
    
    for (int i = 0; i < count; i++)
    {
        objc_property_t property      = properties[i];
        HQModelClassProperty *dbModel = [HQModelClassProperty property:property];
        if (dbModel.isPrimaryKey)
        {
            self.primaryKey = dbModel.name;
        }
        [tempProperties addObject:dbModel];
    }
    free(properties);
    self.propertys = [tempProperties copy];
    
    self.insertSQL = [self createINSERTSQL:className];
    self.createSQL = [self createCREATESQL:className];
    self.delectSQL = [self createDELETESQL:className];
    
}

/**
 *  创建插入sql语句
 *      **可以放在inspectProperty中,减少循环的开销.放在这里是为了代码可读性
 *  @param className 类名称
 *
 *  @return sql语句
 */
- (NSString *)createINSERTSQL:(NSString *)className
{
    NSMutableArray *valueNames = [NSMutableArray arrayWithCapacity:self.propertys.count];
    NSMutableArray *propertyNames  = [NSMutableArray arrayWithCapacity:self.propertys.count];
    
    for ( HQModelClassProperty *property in self.propertys)
    {
        [valueNames addObject:[NSString stringWithFormat:@":%@", property.name]];
        [propertyNames addObject:property.name];
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) values (%@)",className,[propertyNames componentsJoinedByString:@","],[valueNames componentsJoinedByString:@","]];
    return sql;
}

/**
 *  创建建表sql语句
 *      **可以放在inspectProperty中,减少循环的开销.放在这里是为了代码可读性
 *  @param className 类名称
 *
 *  @return sql语句
 */
- (NSString *)createCREATESQL:(NSString *)className
{
    NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:self.propertys.count];
    for ( HQModelClassProperty *property in self.propertys)
    {
        NSString *sqliteType = [HQModelMetadate ocType2sqliteType:property.type];
        if(property.isPrimaryKey)
        {
            sqliteType = [NSString stringWithFormat:@"%@ %@",sqliteType,@"PRIMARY KEY"];
        }
        
        if(property.isUnique)
        {
            sqliteType = [NSString stringWithFormat:@"%@ %@",sqliteType,@"UNIQUE"];
        }
        
        [parameters addObject:[NSString stringWithFormat:@"%@ %@",property.name,sqliteType]];
    }
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",className,[parameters componentsJoinedByString:@","]];
    return sql;
}

- (NSString *)createDELETESQL:(NSString *)className
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",className,self.primaryKey];
    return sql;
}
//@"f":@"float", @"i":@"int", @"d":@"double", @"l":@"long", @"c":@"BOOL", @"s":@"short", @"q":@"long", @"I":@"NSInteger", @"Q":@"NSUInteger", @"B":@"BOOL", @"@?":@"Block"
/**
 *  oc数据类型转sqlite数据类型
 *
 *  @param type oc的类型标识
 *
 *  @return sqliteType基本类型
 */
+ (NSString *)ocType2sqliteType:(NSString *)type
{
    NSString *sqliteType = nil;
    if([type isEqualToString:@"f"] || [type isEqualToString:@"d"])
    {
        sqliteType = @"REAL";
    }
    else if([type isEqualToString:@"i"] || [type isEqualToString:@"l"] || [type isEqualToString:@"s"] || [type isEqualToString:@"q"] ||
            [type isEqualToString:@"I"] || [type isEqualToString:@"Q"] || [type isEqualToString:@"B"])
    {
        sqliteType = @"INTEGER";
    }
    else if([type isEqualToString:@"NSDate"])
    {
        sqliteType = @"DATETIME";
    }
    else
    {
        sqliteType = @"TEXT";
    }
    
    return sqliteType;
}

@end
