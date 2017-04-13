//
//  DDItemParseBase.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDConfig.h"

@interface DDItemParseBase : DDConfig
{
    NSMutableDictionary *resultDictnary;
}


- (id)init:(NSString *)dict;
- (BOOL)parseData:(NSDictionary *)result;
- (NSMutableDictionary*)dtoResult;
- (void)setDtoResult:(NSDictionary*)result;
- (NSDictionary *)toDictionary;
+ (NSDictionary *)toDictionaryWithModle:(id)model;

+ (NSInteger)getIntValue:(NSNumber *)num;
+ (float)getFloatValue:(NSNumber *)num;
+ (BOOL)getBoolValue:(NSNumber *)num;
+ (NSString *)getStrValue:(NSString *)str;
+ (double)getDoubleValue:(NSNumber *)num;

- (NSInteger)getIntValue:(NSNumber *)num;
- (float)getFloatValue:(NSNumber *)num;
- (BOOL)getBoolValue:(NSNumber *)num;
- (NSString *)getStrValue:(NSString *)str;
- (double)getDoubleValue:(NSNumber *)num;
- (long long)getLonglongValue:(NSNumber *)num;

@end
