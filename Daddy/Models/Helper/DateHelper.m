//
//  DateHelper.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format
{
    NSString *time = @"";
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        time = [dateFormatter stringFromDate:date];
        if (time == nil) {
            time = @"";
        }
    } else {
        //time = [NSNull null];
        time = @"";
    }
    return time;
}

+ (NSString *)getFormatTime:(NSDate *)date
{
    return [DateHelper getFormatTime:date format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        time2 = [dateFormatter dateFromString:time];
    } else {
        time2 = [NSDate date];
    }
    return time2;
}

+ (NSDate *)convertTime:(NSString *)time
{
    return [DateHelper convertTime:time format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)convertDay:(NSString *)day
{
    return [DateHelper convertTime:day format:@"yyyy-MM-dd"];
}

+ (NSDate *)convertTimeFromNumber:(NSNumber *)time
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }
    return time2;
}

+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time
{
    NSDate *time2 = nil;
    NSDate *rTime = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        NSLog(@"doubleVlue==%@",time);
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
        NSString *s = [DateHelper getFormatTime: time2];
        NSLog(@"time=%@",s);
        rTime = [DateHelper convertTime: s];
    }
    return rTime;
}

+ (NSDate *)convertTimeFromNumber3:(NSNumber *)time
{
    NSDate *time2 = nil;
    NSDate *rTime = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        time2 = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
        NSString *s = [DateHelper getFormatTime: time2];
        rTime = [DateHelper convertTime: s];
    }
    return rTime;
}

+ (NSString *)convertToDay:(NSDate *)date
{
    return [DateHelper getFormatTime:date format:@"yyyy-MM-dd"];
}

+ (NSString *)dateWithTimeByInterval:(long long)value
{
    return [DateHelper convertToDay:[NSDate dateWithTimeIntervalSince1970:value]];
}


+ (NSNumber *)convertNumberFromTime:(NSDate *)time
{
    NSNumber *time2 = nil;
    if ((NSObject *)time != [NSNull null] && [time isKindOfClass:[NSDate class]]) {
        long long l = [time timeIntervalSince1970];
        time2 = [NSNumber numberWithDouble:l];
    } else {
        time2 = [NSNumber numberWithDouble:0];
    }
    return time2;

}

+ (NSString *)getDisplayTime:(NSString *)dateString
{
    NSDate *date = [DateHelper convertTime:dateString];
    NSString *str = nil;
    NSTimeInterval interval = 0-[date timeIntervalSinceNow];
    if (interval > 24*60*60) {
        str = [NSString stringWithFormat:@"%d天", (int)(interval/(24*60*60))];
        
        if (interval > 7*24*60*60) {
            str = [DateHelper getFormatTime:[DateHelper convertTime:dateString] format:@"MM-dd"];
        }
        
    } else if (interval > 60*60) {
        str = [NSString stringWithFormat:@"%d小时", (int)(interval/(60*60))];
    } else if (interval >= 60*15) {
        str = [NSString stringWithFormat:@"%d分钟", (int)(interval/60)];
    } else {
        str = @"刚刚";
    }
    return str;
}

+ (NSInteger)getSinceNowHours:(NSString *)dateString
{
    NSDate *date = [DateHelper convertTime:dateString];
    NSTimeInterval interval = 0-[date timeIntervalSinceNow];
    
    NSInteger hours = interval/(60*60);
    return hours;
}

+ (NSDateComponents *)getComponenet:(NSDate *)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | kCFCalendarUnitMinute;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

@end
