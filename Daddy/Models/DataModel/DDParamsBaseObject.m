//
//  DDParamsBaseObject.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDParamsBaseObject.h"

@implementation DDParamsBaseObject

- (id)init
{
    self = [super init];
    if(self)
    {
        _request_type = RT_JSON;
        NSNumber *timesNum = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] *1000];
        NSString *timeSp = [NSString stringWithFormat:@"%lld", [timesNum longLongValue]];
        self.ct = timeSp;
    }
    
    return self;
}

- (void)setUrl:(NSString *)api
{
//    if([api isEqualToString:@"http://image.baidu.com/i"])
//    {
//        _url = api;
//        return;
//    }
    
    _url = [self getServerApiUrl:api];
    
}

@end
