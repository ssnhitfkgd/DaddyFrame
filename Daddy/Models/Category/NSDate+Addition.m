//
//  NSDate+Addition.m
//  BaseTrunk
//
//  Created by wangyong on 13-3-25.
//  Copyright (c) 2013年 wangyong. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate(Addition)

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

-(int)compareDate:(NSDate *)date{
    int ci;
    NSComparisonResult result = [self compare:date];
    switch (result)
    {
            //date比自己大
        case NSOrderedAscending: ci=1; break;
            //date比自己小
        case NSOrderedDescending: ci=-1; break;
            //相等
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", date, self); break;
    }
    return ci;
}


+ (NSString *)getFeedFormatTime:(NSDate *)date 
{
    if (!date) {
        return nil;
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDoesRelativeDateFormatting:YES];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    NSDate *fromdate=date;
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    NSInteger lTime = labs((long)intervalTime);
    NSInteger iDays = lTime/60/60/24;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:localeDate];
    NSInteger yearLocal=[comps year];
    
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    
    if(yearLocal - year < 1)
    {
        if(iDays < 2)
        {
            [formatter setDateStyle:NSDateFormatterNoStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            NSString *time = [formatter stringFromDate:date];
            time = [time stringByReplacingOccurrencesOfString:@"今天" withString:@""];
            time = [time stringByReplacingOccurrencesOfString:@"昨天" withString:@""];

            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterNoStyle];

            return [[formatter stringFromDate:date] stringByAppendingFormat:@" %@",time];
        }
        else
        {
            NSString *hourString = [NSString stringWithFormat:@"%@%ld",[comps hour]>9?@"":@"0",(long)[comps hour]];
            NSString *minuteString = [NSString stringWithFormat:@"%@%ld",[comps minute]>9?@"":@"0",(long)[comps minute]];
            return [NSString stringWithFormat:@"%ld/%ld %@:%@", (long)month, (long)day, hourString, minuteString];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];
    }
}


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
    return [self getFormatTime:date format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        time2 = [dateFormatter dateFromString:time];
    } else {
        
    }
    return time2;
}

+ (NSDate *)convertTime:(NSString *)time
{
    return [self convertTime:time format:@"yyyy-MM-dd HH:mm:ss"];
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
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
        NSString *s = [self getFormatTime: time2];
        rTime = [self convertTime: s];
    }
    return rTime;
}

+ (NSString *)convertToDay:(NSDate *)date
{
    return [self getFormatTime:date format:@"yyyy-MM-dd"];
}

+ (NSString *)convertToDayWithDot:(NSDate *)date
{
    return [self getFormatTime:date format:@"yyyy.MM.dd"];
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

+ (NSString *)getDisplayTime:(NSDate *)date
{
    NSString *str = nil;
    NSTimeInterval interval = 0-[date timeIntervalSinceNow];
    if (interval > 24*60*60) {
        str = [NSString stringWithFormat:@"%d天", (int)(interval/(24*60*60))];
    } else if (interval > 60*60) {
        str = [NSString stringWithFormat:@"%d小时", (int)(interval/(60*60))];
    } else if (interval >= 60) {
        str = [NSString stringWithFormat:@"%d分钟", (int)(interval/60)];
    } else {
        str = @"刚刚";
    }
    return str;
}

+ (NSString *)getCellDisplayTime:(NSDate *)date
{
    
    if (!date) {
        return nil;
    }
    
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setLocale:[NSLocale currentLocale]];
    [format setDoesRelativeDateFormatting:YES];
    
    NSDate *fromdate=date;
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = labs((long)intervalTime);
    NSInteger iDays = lTime/60/60/24;
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:localeDate];
    NSInteger yearLocal=[comps year];
    
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger week = [comps weekday];
    
    if(yearLocal - year < 1)
    {
        if(iDays < 1)
        {
            [format setDateStyle:NSDateFormatterNoStyle];
            [format setTimeStyle:NSDateFormatterShortStyle];
            NSString *time = [format stringFromDate:date];
            
            [format setDateStyle:NSDateFormatterMediumStyle];
            [format setTimeStyle:NSDateFormatterNoStyle];
            return time;//[[format stringFromDate:date] stringByAppendingFormat:@" %@",time];

        }
        else if(iDays == 1)
        {
            return @"昨天";
        }
        else if(iDays < 6)
        {
            return arrWeek[week-1];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld-%ld",(long)month, (long)day];
        }
    }
    else
    {
        [format setTimeStyle:NSDateFormatterNoStyle];
        return [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];
    }

}

+ (NSDateComponents *)getComponenet:(NSDate *)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return comps;
}


- (DateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz{
    
    
    DateInformation info;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:tz];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear |
                                                    NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond)
                                          fromDate:self];
    info.day = [comp day];
    info.month = [comp month];
    info.year = [comp year];
    
    info.hour = [comp hour];
    info.minute = [comp minute];
    info.second = [comp second];
    
    info.weekday = [comp weekday];
    
    
    return info;
    
}
- (DateInformation) dateInformation{
    
    DateInformation info;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear |
                                                    NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond)
                                          fromDate:self];
    info.day = [comp day];
    info.month = [comp month];
    info.year = [comp year];
    
    info.hour = [comp hour];
    info.minute = [comp minute];
    info.second = [comp second];
    
    info.weekday = [comp weekday];
    
    
    return info;
}
+ (NSDate*) dateFromDateInformation:(DateInformation)info timeZone:(NSTimeZone*)tz{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:tz];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    [comp setDay:info.day];
    [comp setMonth:info.month];
    [comp setYear:info.year];
    [comp setHour:info.hour];
    [comp setMinute:info.minute];
    [comp setSecond:info.second];
    [comp setTimeZone:tz];
    
    return [gregorian dateFromComponents:comp];
}
+ (NSDate*) dateFromDateInformation:(DateInformation)info{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    [comp setDay:info.day];
    [comp setMonth:info.month];
    [comp setYear:info.year];
    [comp setHour:info.hour];
    [comp setMinute:info.minute];
    [comp setSecond:info.second];
    //[comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [gregorian dateFromComponents:comp];
}


- (NSInteger) daysBetweenDate:(NSDate*)d{
    
    NSTimeInterval time = [self timeIntervalSinceDate:d];
    return fabs(time / 60 / 60/ 24);
    
}

// ------------------
- (NSString*) month{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    return [dateFormatter stringFromDate:self];
}
- (NSString*) year{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:self];
}
// ------------------


+ (NSDate*) firstOfCurrentMonth{
    
    NSDate *day = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
    [comp setDay:1];
    return [gregorian dateFromComponents:comp];
    
}
+ (NSDate*) lastOfCurrentMonth{
    NSDate *day = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
    [comp setDay:0];
    [comp setMonth:comp.month+1];
    return [gregorian dateFromComponents:comp];
}

- (NSDate*) timelessDate {
    NSDate *day = self;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:day];
    return [gregorian dateFromComponents:comp];
}
- (NSDate*) monthlessDate {
    NSDate *day = self;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
    return [gregorian dateFromComponents:comp];
}


- (NSDate*) firstOfCurrentMonthForDate {
    
    NSDate *day = self;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
    [comp setDay:1];
    return [gregorian dateFromComponents:comp];
    
}
- (NSDate*) firstOfNextMonthForDate {
    NSDate *day = self;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:day];
    [comp setDay:1];
    [comp setMonth:comp.month+1];
    return [gregorian dateFromComponents:comp];
}


- (NSNumber*) dayNumber{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    return [NSNumber numberWithInt:[[dateFormatter stringFromDate:self] intValue]];
}
- (NSString*) hourString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h a"];
    return [dateFormatter stringFromDate:self];
}
- (NSString*) monthString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    return [dateFormatter stringFromDate:self];
}
- (NSString*) yearString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:self];
}
- (NSString*) monthYearString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    return [dateFormatter stringFromDate:self];
}



- (NSInteger) weekday{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    NSInteger weekday = [comps weekday];
    return weekday;
}


// Calendar starting on Monday instead of Sunday (Australia, Europe against US american calendar)
- (NSInteger) weekdayWithMondayFirst{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    NSInteger weekday = [comps weekday];
    
    CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
    if (CFCalendarGetFirstWeekday(currentCalendar) == 2) {
        weekday -= 1;
        if (weekday == 0) {
            weekday = 7;
        }
    }
    CFRelease(currentCalendar);
    
    return weekday;
}

+ (NSDate*) yesterday{
    DateInformation inf = [[NSDate date] dateInformation];
    inf.day--;
    return [NSDate dateFromDateInformation:inf];
}




/* ----- start snippet from http://www.alexcurylo.com/blog/2009/07/25/snippet-naturaldates/ ----- */
- (NSInteger) differenceInDaysTo:(NSDate *)toDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay
                                                fromDate:self
                                                  toDate:toDate
                                                 options:0];
    NSInteger days = [components day];
    return days;
}
- (NSInteger) differenceInMonthsTo:(NSDate *)toDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth
                                                fromDate:[self monthlessDate]
                                                  toDate:[toDate monthlessDate]
                                                 options:0];
    NSInteger months = [components month];
    return months;
}
- (BOOL) isSameDay:(NSDate*)anotherDate{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSDateComponents* components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
    return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}
- (BOOL) isToday{
    return [self isSameDay:[NSDate date]];
}
/* ----- end snippet ----- */


- (NSString*) dateDescription{
    return [[self description] substringToIndex:10];
}
- (NSDate *) dateByAddingDays:(NSUInteger)days {
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *datePortion = [dateFormatter stringFromDate:aDate];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timePortion = [dateFormatter stringFromDate:aTime];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *dateTime = [NSString stringWithFormat:@"%@ %@",datePortion,timePortion];
    return [dateFormatter dateFromString:dateTime];
}

//add
+ (NSDateComponents *)dateFormatterFromBTime:(UInt64)time
{
    NSDate* creteDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];  //NSGregorianCalendar
    NSDateComponents *components = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday|NSCalendarUnitMonth) fromDate:creteDate];
    
    return components;
}

+ (NSString*)monthAndDayToString:(UInt64)time
{
    NSDate* creteDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    return [formatter stringFromDate:creteDate];
}

+ (NSString *)getTimeNow
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

@end
