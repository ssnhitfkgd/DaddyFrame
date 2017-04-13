//
//  DDItemParseBase.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDItemParseBase.h"
#import <objc/runtime.h>
#import "GlobalHelper.h"


@implementation DDItemParseBase
//@synthesize dtoResult = _dtoResult;

- (id)init:(NSString *)str
{
    self = [super init];
    if (self) {
        NSDictionary *dict = [NSDictionary modelWithJSON:str];
        BOOL tf = [self parseData:dict];
        if (tf == NO) {
            self = nil;
        }
    }
    return self;
}

+ (NSInteger)getIntValue:(NSNumber *)num
{
    NSInteger n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num intValue];
    }
    return n;
}

+ (float)getFloatValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num floatValue];
    }
    return n;
}

+ (double)getDoubleValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num doubleValue];
    }
    return n;
}

+ (BOOL)getBoolValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num boolValue];
    }
    return n;
}

+ (NSString *)getStrValue:(NSString *)str
{
    NSString *s = @"";
    if ((NSObject *)str != [NSNull null] && str != nil) {
        s = [NSString stringWithFormat:@"%@",str];
    }
    return s;
}
////////
- (NSInteger)getIntValue:(NSNumber *)num
{
    NSInteger n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num intValue];
    }
    return n;
}

- (long long )getLonglongValue:(NSNumber *)num
{
    long long  n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num longLongValue];
    }
    return n;
}

- (float)getFloatValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num floatValue];
    }
    return n;
}

- (double)getDoubleValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num doubleValue];
    }
    return n;
}

- (BOOL)getBoolValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num boolValue];
    }
    return n;
}

- (NSString *)getStrValue:(NSString *)str
{
    NSString *s = @"";
    if ((NSObject *)str != [NSNull null] && str != nil) {
        s = [NSString stringWithFormat:@"%@",str];
    }
    return s;
}

- (NSMutableDictionary*)dtoResult
{
    if(OBJ_IS_NIL(resultDictnary) || ![resultDictnary isKindOfClass:[NSMutableDictionary class]])
    {
        if(OBJ_IS_NIL(resultDictnary))
        {
            resultDictnary = [NSMutableDictionary new];
            return resultDictnary;
        }
        resultDictnary = [[NSMutableDictionary alloc] initWithDictionary:resultDictnary];
    }
    return resultDictnary;
}

- (void)setDtoResult:(NSDictionary*)result
{
    if([result isKindOfClass:[NSMutableDictionary class]])
        resultDictnary = (NSMutableDictionary*)result;
    else resultDictnary = [[NSMutableDictionary alloc] initWithDictionary:result];
}

- (BOOL)isNull:(id)value
{
    if (value != [NSNull null] && value != nil) {
        return NO;
    }
    return YES;
}

- (BOOL)parseData:(NSDictionary *)result
{
    if (result && (NSObject *)result != [NSNull null]) {
    
        [self setDtoResult:result];
        [self modelSetWithJSON:result];
        
        return YES;
        
    }
    return NO;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dictionaryFormat = [self modelToJSONObject];

    return dictionaryFormat;
}

+ (NSDictionary *)toDictionaryWithModle:(id)model
{
    NSMutableDictionary *dictionaryFormat = [model modelToJSONObject];

    return dictionaryFormat;
}

@end
