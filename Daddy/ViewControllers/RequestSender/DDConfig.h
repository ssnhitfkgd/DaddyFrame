//
//  DDConfig.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDConfig : NSObject
- (NSString*)getServerApiUrl:(NSString*)api;

+ (NSInteger)socketPort;
+ (NSString*)socketAddr;

@end
