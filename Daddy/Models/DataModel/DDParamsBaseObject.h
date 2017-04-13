//
//  DDParamsBaseObject.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDConfig.h"

//uploadtype
typedef NS_ENUM(NSUInteger, REQUEST_TYPE){
    RT_JSON = 0,
    RT_Stream,
};

@interface DDParamsBaseObject : DDConfig

@property (nonatomic, assign) REQUEST_TYPE request_type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *uploadUrl;
@property (nonatomic, copy) NSString *timesp;   //自带检验
@property (nonatomic, copy) NSString *ct; //校验用 时间戳
@property (nonatomic, assign) BOOL post;
@property (nonatomic, strong) id file;

@end
