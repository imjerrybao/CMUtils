//
//  NSDate+util.m
//  CMUtils
//
//  Created by Jerry on 13-4-16.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "NSDate+util.h"
#import "NSString+util.h"
#import "CMConfig.h"

@implementation NSDate (util)

+ (NSDate *)dateFromString:(NSString *)dateString formatString:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSDate *newDate = [dateFormatter dateFromString:dateString];
    return newDate;
}
- (NSDate *)dateByAddingYears:(NSUInteger)years
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:years];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents  toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingYears:(NSUInteger)years
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:-years];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSInteger)year
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:self];
    return dateComponents.year;
}

- (NSInteger)month
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit fromDate:self];
    return dateComponents.month;
}

- (int)getAgeFromBirthday
{
    int year = self.year;
    int month = self.month;
    int age =   [NSDate date].year - year;
    if (([NSDate date].month - month) > 6) {
        age++;
    }
    return age;
}

+ (NSInteger)datesBetween:(NSDate *)from to:(NSDate *)to {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:from
                                                  toDate:to options:0];
    
    NSInteger days = [components day];
    return days;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateComponents = [[NSDateComponents alloc] init];
    [_dateComponents setYear:year];
    [_dateComponents setMonth:month];
    [_dateComponents setDay:day];
    [_dateComponents setHour:0];
    [_dateComponents setMinute:0];
    [_dateComponents setSecond:0];
    
    NSDate *_newDate = [_gregorianCalendar dateFromComponents:_dateComponents];
    
    return _newDate;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minuts:(NSInteger)minuts second:(NSInteger)second {
    
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateComponents = [[NSDateComponents alloc] init];
    [_dateComponents setYear:year];
    [_dateComponents setMonth:month];
    [_dateComponents setDay:day];
    [_dateComponents setHour:hour];
    [_dateComponents setMinute:minuts];
    [_dateComponents setSecond:second];
    
    NSDate *_newDate = [_gregorianCalendar dateFromComponents:_dateComponents];
    
    return _newDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString fmtString:(NSString *)fmtStr {
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
//    [_dateFormatter setLocale:[NSLocale currentLocale]];
    [_dateFormatter setDateFormat:fmtStr];
    
    NSDate *_newDate = [_dateFormatter dateFromString:dateString];
    
    return _newDate;
}

+ (NSDate *)dateFromTimeStamp:(NSString *)dateString {
    return [self dateFromString:dateString fmtString:TIMESTAMP_FORMAT];
}
+ (NSDate *)dateFromTimeStamp1:(NSString *)dateString {
    return [self dateFromString:dateString fmtString:TIMESTAMP_FORMAT1];
}
+ (NSDate *)dateFromDayTime:(NSString *)timeString {
    return [self dateFromString:timeString fmtString:DAYTIME_FORMAT];
}

+ (NSDate *)dateFromISO8601:(NSString *)timeString {
    if ([timeString contains:@"Z"])
    {
        return [self dateFromString:timeString fmtString:ISO8601_FORMAT_Z];
    }
    return [self dateFromString:timeString fmtString:ISO8601_FORMAT];
}
// 时间戳
+ (NSDate *)dateFromTimeLong:(long long)longTime fmtString:(NSString *)fmtStr
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:fmtStr];
    double aa = longTime/1000;
    NSDate *_newDate = [NSDate dateWithTimeIntervalSince1970:aa];
    return _newDate;
}
+ (NSDate *)dateFromTimeLong1:(long long)longTime {
    return [self dateFromTimeLong:longTime fmtString:TIMESTAMP_FORMAT];
}
+ (NSDate *)dateFromTimeLong2:(long long)longTime {
    return [self dateFromTimeLong:longTime fmtString:TIMESTAMP_FORMAT1];
}
+ (NSDate *)dateFromTimeLong3:(long long)longTime {
    return [self dateFromTimeLong:longTime fmtString:DAYTIME_FORMAT];
}
+ (NSDate *)dateFromTimeLong4:(long long)longTime
{
    return [self dateFromTimeLong:longTime fmtString:ISO8601_FORMAT];
}

- (NSDate *)tomorrow {
    return [self dateByAddingDays:1];
}

- (NSDate *)yesterday {
    return [self dateBySubtractingDays:1];
}

- (NSDate *)nextWeek {
    return [self dateByAddingDays:7];
}

- (NSDate *)lastWeek {
    return [self dateBySubtractingDays:7];
}

- (NSDate *)nextMonth {
    return [self dateByAddingMonths:1];
}

- (NSDate *)lastMonth {
    return [self dateBySubtractingMonths:1];
}

- (NSDate *)nextYear {
    return [self dateByAddingYears:1];
}

- (NSDate *)lastYear {
    return [self datebySubtractingYears:1];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setDay:days];
    
    NSDate *_newDate = [_gregorianCalendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    return _newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)days {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setDay:-days];
    
    NSDate *_newDate = [_gregorianCalendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    return _newDate;
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setMonth:months];
    
    NSDate *_newDate = [_gregorianCalendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    return _newDate;
    
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)months {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setMonth:-months];
    
    NSDate *_newDate = [_gregorianCalendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    return _newDate;
}

- (NSDate *)datebySubtractingYears:(NSInteger)years {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setYear:-years];
    
    NSDate *_newDate = [_gregorianCalendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    return _newDate;
}

- (NSInteger)dayOfWeek {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateComponents = [_gregorianCalendar components:NSWeekdayCalendarUnit fromDate:self];
    
    return _dateComponents.weekday;
}


+ (NSDate *)changeMonthTo:(NSInteger)month from:(NSDate *)from {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSUInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit;
    NSDateComponents *_dateComponents = [_gregorianCalendar components:flag fromDate:from];
    [_dateComponents setMonth:month];
    return [_gregorianCalendar dateFromComponents:_dateComponents];
}

+ (NSDate *)changeYearTo:(NSInteger)year from:(NSDate *)from {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSUInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit;
    NSDateComponents *_dateComponents = [_gregorianCalendar components:flag fromDate:from];
    [_dateComponents setYear:year];
    return [_gregorianCalendar dateFromComponents:_dateComponents];
}

- (NSInteger)day {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateComponents = [_gregorianCalendar components:NSDayCalendarUnit fromDate:self];
    
    return _dateComponents.day;
}

+ (NSDate *)changeDayTo:(NSInteger)day from:(NSDate *)from {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSUInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit;
    NSDateComponents *_dateComponents = [_gregorianCalendar components:flag fromDate:from];
    [_dateComponents setDay:day];
    return [_gregorianCalendar dateFromComponents:_dateComponents];
}

- (NSInteger)hour {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateComponents = [_gregorianCalendar components:NSHourCalendarUnit fromDate:self];
    
    return _dateComponents.hour;
}

+ (NSDate *)changeHourTo:(NSInteger)hour from:(NSDate *)from {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSUInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit;
    NSDateComponents *_dateComponents = [_gregorianCalendar components:flag fromDate:from];
    [_dateComponents setHour:hour];
    return [_gregorianCalendar dateFromComponents:_dateComponents];
}

- (NSInteger)minute {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateComponents = [_gregorianCalendar components:NSMinuteCalendarUnit fromDate:self];
    
    return _dateComponents.minute;
}

+ (NSDate *)changeMinutsTo:(NSInteger)minuts from:(NSDate *)from {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSUInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit;
    NSDateComponents *_dateComponents = [_gregorianCalendar components:flag fromDate:from];
    [_dateComponents setMinute:minuts];
    return [_gregorianCalendar dateFromComponents:_dateComponents];
}

- (NSInteger)second {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSDateComponents *_dateComponents = [_gregorianCalendar components:NSSecondCalendarUnit fromDate:self];
    
    return _dateComponents.second;
}

+ (NSDate *)changeSecondTo:(NSInteger)second from:(NSDate *)from {
    NSCalendar *_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_gregorianCalendar setLocale:[NSLocale currentLocale]];
    [_gregorianCalendar setFirstWeekday:1];
    
    NSUInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit;
    NSDateComponents *_dateComponents = [_gregorianCalendar components:flag fromDate:from];
    [_dateComponents setSecond:second];
    return [_gregorianCalendar dateFromComponents:_dateComponents];
}

- (BOOL)isLaterThanDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
}

- (BOOL)isEarlierThanDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    [_dateFormatter setDateFormat:format];
    NSString *_dateString = [_dateFormatter stringFromDate:self];
    
    return _dateString;
}

- (NSString *)stringWithFormat:(NSString *)format timezone:(NSTimeZone *)tz {
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeZone:tz];
    [_dateFormatter setDateFormat:format];
    NSString *_dateString = [_dateFormatter stringFromDate:self];
    
    return _dateString;
}

- (NSString *)stringWithTimestamp {
    return [self stringWithFormat:TIMESTAMP_FORMAT];
}
- (NSString *)stringWithTimestamp1 {
    return [self stringWithFormat:TIMESTAMP_FORMAT1];
}
- (NSString *)stringWithTimestamp2 {
    return [self stringWithFormat:TIMESTAMP_FORMAT2];
}
- (NSString *)stringWithTimestamp3
{
    return [self stringWithFormat:TIMESTAMP_FORMAT3];
}
- (NSString *)stringWithDaytime {
    return [self stringWithFormat:DAYTIME_FORMAT];
}

- (NSString *)stringWithMonth {
    return [self stringWithFormat:MONTH_DAY];
}

- (NSString *)stringWithComment
{
    if ([NSDate date].year == self.year) {
        return [self stringWithFormat:TIMESTAMP_FORMAT2];
    } else {
        return [self stringWithFormat:TIMESTAMP_FORMAT1];
    }
}

- (NSString *)stringWithISO8601Format {
    return [self stringWithFormat:ISO8601_FORMAT];
}
//"log.time.minutes" = "%d分の前";
//"log.time.hours" = "%d時間の前";
- (NSString *)hunmanFriendly {
    NSTimeInterval pastSec = -[self timeIntervalSinceNow];
    if (pastSec < 120) {
        if ([[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"] || [[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"] || [[CMConfig getCurrentLanguage] isEqualToString:@"ja"]) {
            return [NSString stringWithFormat:Locale(@"log.time.minutes"),1];
        }
        return [NSString stringWithFormat:@"1 min ago"];
        
    }
    if (pastSec < 3600) {
        return [NSString stringWithFormat:Locale(@"log.time.minutes"), (int)(pastSec / 60)];
    }
    if (pastSec < 3600 * 24) {
        if (pastSec < 3600 * 2) {
            if ((![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"ja"])) {        // 只在英文下
                return [NSString stringWithFormat:@"1 hour ago"];
            }
        }
        return [NSString stringWithFormat:Locale(@"log.time.hours"), (int)(pastSec / 3600)];
    }
    
    
    return [self stringWithDaytime];
}

- (NSString *)hunmanFriendlyAbs
{
    NSTimeInterval pastSec = -[self timeIntervalSinceNow];
    if (pastSec < 120) {
        if ([[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"] || [[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"] || [[CMConfig getCurrentLanguage] isEqualToString:@"ja"]) {
            return [NSString stringWithFormat:Locale(@"log.time.minutes"),1];
        }
        return [NSString stringWithFormat:@"1 min ago"];
        
    }
    if (pastSec < 3600) {
        return [NSString stringWithFormat:Locale(@"log.time.minutes"), (int)(pastSec / 60)];
    }
    if (pastSec < 3600 * 24) {
        if (pastSec < 3600 * 2) {
            if ((![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"ja"])) {        // 只在英文下
                return [NSString stringWithFormat:@"1 hour ago"];
            }
        }
        return [NSString stringWithFormat:Locale(@"log.time.hours"), (int)(pastSec / 3600)];
    }
    
    if (pastSec < 3600 * 24 * 30) {
        if (pastSec < 3600 * 24 * 2) {
            if ((![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"ja"])) {        // 只在英文下
                return [NSString stringWithFormat:@"1 day ago"];
            }
            return [NSString stringWithFormat:Locale(@"date.somedayAgo"), 1];
        }
        return [NSString stringWithFormat:Locale(@"date.somedayAgo"), (int)(pastSec / (3600*24))];
    }
    
    if (pastSec < 3600 * 24 * 30 * 12) {
        if (pastSec < 3600 * 24 * 30 * 2) {
            if ((![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"ja"])) {        // 只在英文下
                return [NSString stringWithFormat:@"1 month ago"];
            }
            
            return [NSString stringWithFormat:Locale(@"date.someMonthAgo"), 1];
        }
        return [NSString stringWithFormat:Locale(@"date.someMonthAgo"), (int)(pastSec / (3600*24*30))];
    }
    
    if (pastSec < 3600 * 24 * 30 * 12 * 2) {
        if ((![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]) && (![[CMConfig getCurrentLanguage] isEqualToString:@"ja"])) {        // 只在英文下
            return [NSString stringWithFormat:@"1 year ago"];
        }
        return [NSString stringWithFormat:Locale(@"date.someYearAgo"), 1];
    }
    return [self stringWithDaytime];
}

- (NSString *)getHourAndMin
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:HOUR_MIN];
    NSString *dateStr = [formatter stringFromDate:self];
    return dateStr;
}

- (NSString *)newsTimeStr
{
    NSString *timeStr = nil;
    NSString *currentLag = [CMConfig getCurrentLanguage];
    if ([self isToday]) {
        //今天
        timeStr = [self getHourAndMin];
    } else if ([self isYeaterday]) {
        //昨天
        NSString *yesterday = nil;
        
        if ([currentLag isEqualToString:@"zh-Hans"] || [currentLag isEqualToString:@"zh-Hant"]) {
            //中文 简繁
            yesterday = @"昨天";
        } else if ([currentLag isEqualToString:@"ja"]) {
            //日文
            yesterday = @"昨日";
        } else {
            //英文
            yesterday = @"yesterday";
        }
        timeStr = [NSString stringWithFormat:@"%@ %@", yesterday, [self getHourAndMin]];
    } else {
        //昨天之前
        NSString *dateFormatterStr = nil;
        if ([currentLag isEqualToString:@"zh-Hans"] || [currentLag isEqualToString:@"zh-Hant"]) {
            //中文 简繁
            dateFormatterStr = @"yyyy年MM月dd日 HH:mm";
        } else if ([currentLag isEqualToString:@"ja"]) {
            //日文
            dateFormatterStr = @"yyyy/MM/dd HH:mm";
        } else {
            //英文
            dateFormatterStr = @"MM/dd/yyyy HH:mm";
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:dateFormatterStr];
        timeStr = [dateFormatter stringFromDate:self];
    }
   
    return timeStr;
}

- (BOOL)isToday
{
    NSDate *today = [NSDate date];
    return (today.day == self.day  && today.month == self.month && today.year == self.year);
}

- (BOOL)isYeaterday
{

    NSDate *yesterday = [[NSDate date] yesterday];
    if (self.year == yesterday.year && self.month == yesterday.month && self.day == yesterday.day) {
        return YES;
    }
    return NO;
    
}
@end
