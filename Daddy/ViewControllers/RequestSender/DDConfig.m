//
//  DDConfig.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDConfig.h"

#define __OPTIMIZE__MY__

@implementation DDConfig

//0为线上环境，  1为线上测试环境  2为公司开发环境
+ (NSInteger)getScope
{
#ifndef __OPTIMIZE__MY__
    return 1;
#else
    return 0;
#endif
}


+ (NSString*)serverApiUrl
{
#ifndef __OPTIMIZE__MY__
    return @"https://test-api.kinstalk.com";
#else
    return @"https://api.kinstalk.com";
#endif
}



- (NSString*)getServerApiUrl:(NSString*)api
{
    return [NSString stringWithFormat:@"%@/%@", [[self class] serverApiUrl], api];
}

+ (NSInteger)socketPort
{
#ifndef __OPTIMIZE__MY__
    return 8001;
#else
    return 8001;
#endif
}

+ (NSString*)socketAddr
{
#ifndef __OPTIMIZE__MY__
    return @"54.223.154.224";
#else
    return @"54.223.178.102";
#endif
}


@end
