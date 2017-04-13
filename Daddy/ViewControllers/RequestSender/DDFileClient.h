//
//  DDFileClient.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDRequestSender.h"
#import "DDParamsBaseObject.h"

typedef NS_ENUM(NSInteger, NetWorkingType) {
    NetWorkingType_None = 0,
    NetWorkingType_3G   = 1,
    NetWorkingType_Wifi = 2,
};
typedef void(^Block_Network_Status)(NSInteger status);

@interface DDFileClient : NSObject
{
    NetWorkingType nNetworkingType;
}
@property (nonatomic, copy)Block_Network_Status network_status;

+ (instancetype)sharedInstance;
- (BOOL)isNetworkingDisconnect;
- (int)getNetworkingType;



- (void)request_send:(DDParamsBaseObject*)model cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;


typedef void(^Block_Complete)(id obj);
typedef void(^Block_Error)(id obj);

@property (nonatomic, copy) Block_Complete block_complete;
@property (nonatomic, copy) Block_Error block_error;

- (void)request_send:(DDParamsBaseObject*)model
                  cachePolicy:(NSURLRequestCachePolicy)cachePolicy
             completeSelector:(Block_Complete)complete
                errorSelector:(Block_Error)error;

@end


