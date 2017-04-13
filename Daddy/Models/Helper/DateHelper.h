//
//  DateHelper.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSDate *)convertTime:(NSString *)time;
+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format;
+ (NSDate *)convertTimeFromNumber:(NSNumber *)time;
// 矫正时区问题
+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time;
+ (NSDate *)convertTimeFromNumber3:(NSNumber *)time;
+ (NSString *)convertToDay:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;
+ (NSString *)getDisplayTime:(NSString *)date;
+ (NSDateComponents *)getComponenet:(NSDate *)date;

+ (NSInteger)getSinceNowHours:(NSString *)dateString;

+ (NSString *)dateWithTimeByInterval:(long long)value;
+ (NSDate *)convertDay:(NSString *)day;
@end
