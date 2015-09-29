//
//  NSDate+util.h
//  CMUtils
//
//  Created by Jerry on 13-4-16.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISO8601_FORMAT      @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
#define ISO8601_FORMAT_Z      @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

#define TIMESTAMP_FORMAT    @"yyyy-MM-dd HH:mm:ss"
#define DAYTIME_FORMAT      @"yyyy-MM-dd"
#define TIMESTAMP_FORMAT1   @"yyyy-MM-dd HH:mm"
#define TIMESTAMP_FORMAT2   @"MM-dd HH:mm"
#define TIMESTAMP_FORMAT3   @"yyyy.MM.dd"
#define MONTH_DAY @"MM-dd"

#define HOUR_MIN  @"HH:mm"
@interface NSDate (util)

//年
- (NSInteger)year;

//月
- (NSInteger)month;

//加上X年
- (NSDate *)dateByAddingYears:(NSUInteger)years;

//减去X年
- (NSDate *)dateBySubtractingYears:(NSUInteger)years;

//得到年龄
- (int)getAgeFromBirthday;


/**
 *  根据 日期字符串 和 格式字符串 生成 NSDate实例
 *
 *  @param dateString   日期字符串
 *  @param formatString 格式字符串
 *
 *  @return NSDate实例
 */
+ (NSDate *)dateFromString:(NSString *)dateString formatString:(NSString *)formatString;

+ (NSInteger)datesBetween:(NSDate *)from to:(NSDate *)to;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minuts:(NSInteger)minuts second:(NSInteger)second;

+ (NSDate *)dateFromString:(NSString *)dateString fmtString:(NSString *)fmtStr;
+ (NSDate *)dateFromTimeStamp:(NSString *)dateString;    //yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromDayTime:(NSString *)timeString;      //yyyy-MM-dd
+ (NSDate *)dateFromTimeStamp1:(NSString *)dateString;   //yyyy-MM-dd HH:mm
+ (NSDate *)dateFromISO8601:(NSString *)timeString;

+ (NSDate *)dateFromTimeLong1:(long long)longTime;            //yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromTimeLong2:(long long)longTime;            //yyyy-MM-dd
+ (NSDate *)dateFromTimeLong3:(long long)longTime;            //yyyy-MM-dd HH:mm
+ (NSDate *)dateFromTimeLong4:(long long)longTime;            //@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"


- (NSDate *)tomorrow;
- (NSDate *)yesterday;
- (NSDate *)nextWeek;
- (NSDate *)lastWeek;
- (NSDate *)nextMonth;
- (NSDate *)lastMonth;
- (NSDate *)nextYear;
- (NSDate *)lastYear;

- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateBySubtractingDays:(NSInteger)days;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)datebySubtractingYears:(NSInteger)years;

- (NSInteger)dayOfWeek;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
+ (NSDate *)changeYearTo:(NSInteger)year from:(NSDate *)from;
+ (NSDate *)changeMonthTo:(NSInteger)month from:(NSDate *)from;
+ (NSDate *)changeDayTo:(NSInteger)day from:(NSDate *)from;
+ (NSDate *)changeHourTo:(NSInteger)hour from:(NSDate *)from;
+ (NSDate *)changeMinutsTo:(NSInteger)minuts from:(NSDate *)from;
+ (NSDate *)changeSecondTo:(NSInteger)second from:(NSDate *)from;

- (BOOL)isLaterThanDate:(NSDate *)date;
- (BOOL)isEarlierThanDate:(NSDate *)date;

- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithTimestamp;
- (NSString *)stringWithTimestamp1;
- (NSString *)stringWithTimestamp2;
- (NSString *)stringWithTimestamp3;
- (NSString *)stringWithDaytime;
- (NSString *)stringWithISO8601Format;
- (NSString *)stringWithFormat:(NSString *)format timezone:(NSTimeZone *)tz;
- (NSString *)getHourAndMin;
- (NSString *)hunmanFriendly;
- (NSString *)hunmanFriendlyAbs;

//评论时间
- (NSString *)stringWithComment;

//新闻页面的时间
- (NSString *)newsTimeStr;
@end
