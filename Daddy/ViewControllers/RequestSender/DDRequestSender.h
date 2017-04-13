//
//  DDRequestSender.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DDParamsBaseObject.h"
typedef enum
{
    ERROR_CODE_SUCCESS = 0,
    ERROR_CODE_NORMAL,
    ERROR_CODE_NEED_AUTH = 20020,
    ERROR_CODE_NEED_AUTH_TOKEN_FAIL = 20033,
}API_GET_CODE;


@interface DDRequestSender : NSObject

@property (nonatomic, weak)   id requestDelegate;
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, strong) DDParamsBaseObject *paramsObject;

@property (nonatomic) SEL completeSelector;
@property (nonatomic) SEL errorSelector;
@property (nonatomic) SEL argumentSelector;

+ (id)requestSenderWithParams:(id)params
                       cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                          delegate:(id)requestDelegate
                  completeSelector:(SEL)completeSelector
                     errorSelector:(SEL)errorSelector
                  argumentSelector:(SEL)argumentSelector;


+ (NSMutableURLRequest *)getRequestWithURL:(NSString *)url;
- (void)send;
- (void)uploadData;
+ (instancetype)currentClient;
+ (void)addHttpHeader:(NSMutableURLRequest *)request;
+ (void)clearSection;
+ (AFURLSessionManager *)getRequestManager;
- (id)transitionData:(id)data cache:(BOOL)cache;
- (NSURLSessionUploadTask *)getUploadTaskWithompletion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock;

@end
