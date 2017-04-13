//
//  DDRequestSender.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDRequestSender.h"
#import "DDFileClient.h"
#import "FileHelper.h"
#import "DDUserInfoObject.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+MultiFormat.h"


static const float TIME_OUT_INTERVAL = 15.0f;
static const float TIME_OUT_UPLOAD = 1000.0f;


@implementation DDRequestSender
@synthesize argumentSelector;
@synthesize requestDelegate;
@synthesize completeSelector;
@synthesize errorSelector;
@synthesize cachePolicy;

+ (instancetype)currentClient
{
    static DDRequestSender *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[DDRequestSender alloc] init];
    });
    return sharedInstance;
}

+ (id)requestSenderWithParams:(id)params
                  cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                     delegate:(id)requestDelegate
             completeSelector:(SEL)completeSelector
                errorSelector:(SEL)errorSelector
             argumentSelector:(SEL)argumentSelector;
{
    DDRequestSender *requestSender = [[DDRequestSender alloc] init];
    requestSender.requestDelegate = requestDelegate;
    requestSender.completeSelector = completeSelector;
    requestSender.errorSelector = errorSelector;
    requestSender.argumentSelector = argumentSelector;
    requestSender.cachePolicy = cachePolicy;
    requestSender.paramsObject = params;
    return requestSender;
    
}


+ (NSMutableURLRequest *)getRequestWithURL:(NSString *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[self class] addHttpHeader:request];
    return request;
}

+ (void)addHttpHeader:(NSMutableURLRequest *)request
{
    if([DDUserInfoObject sharedInstance].token)
    {
        [request addValue:[DDUserInfoObject sharedInstance].token forHTTPHeaderField:@"token"];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [request addValue:@"1" forHTTPHeaderField:@"deviceType"];
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [request addValue:@"2" forHTTPHeaderField:@"deviceType"];
    }
}

+ (void)clearSection
{
    requestManager = nil;
}

AFURLSessionManager *requestManager = nil;
+ (AFURLSessionManager *)getRequestManager
{
    if(!requestManager)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *managerTemp = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//        managerTemp.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
        managerTemp.securityPolicy.validatesDomainName = NO;
        managerTemp.responseSerializer = [AFHTTPResponseSerializer serializer];
                ((AFHTTPResponseSerializer*)managerTemp.responseSerializer).acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        requestManager = managerTemp;
    }
    
    return requestManager;
}

- (void)send
{
    NSString *bodyString = [self httpBodyString:self.paramsObject];
    NSString *url = self.paramsObject.url;
    
    if(!self.paramsObject.post)
    {
        url = [self.paramsObject.url stringByAppendingString:[NSString stringWithFormat:@"?%@",bodyString]];
    }
    
    NSMutableURLRequest *request = [[self class] getRequestWithURL:url];
    [request setCachePolicy:self.cachePolicy];
    [request setTimeoutInterval:TIME_OUT_INTERVAL];
    [request setHTTPMethod:self.paramsObject.post?@"POST":@"GET"];
    
    
    if(self.paramsObject.post)
    {
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    __weak typeof(self)weak_self = self;
    NSURLSessionDataTask *dataTask = [[[self class] getRequestManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if(!error)
        {
            if(self.requestDelegate)
            {
                //            NSLog(@"get Data sucess");
                id object = responseObject;
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if(weak_self.completeSelector && [weak_self.requestDelegate respondsToSelector:weak_self.completeSelector])
                {
                    if(weak_self.paramsObject.request_type == RT_JSON)
                    {
                        object = [weak_self transitionData:responseObject cache:NO];
                    }
                    //去皮
                    
                    if (object)
                    {
//                    NSLog(@"deal Data sucess");
                        
                        if ([object isKindOfClass:[NSError class]])
                        {
                            if(weak_self.errorSelector){
                            [weak_self.requestDelegate performSelector:weak_self.errorSelector withObject:(NSError *)object];
                            }
                           
                        }
                        else
                        {
                            if(weak_self.completeSelector)
                            [weak_self.requestDelegate performSelector:weak_self.completeSelector withObject:object];
                        }
                    }
                    else if(weak_self.errorSelector)
                    {
                        [weak_self.requestDelegate performSelector:weak_self.errorSelector withObject:(NSError *)object];
                    }
                    //                NSLog(@"return Data sucess");
                    
                }
                else if(weak_self.errorSelector)
                {
                    [weak_self.requestDelegate performSelector:weak_self.errorSelector withObject:(NSError *)object];
                }
#pragma clang diagnostic pop
                
            }
        }
        else
        {
            if(weak_self.requestDelegate)
            {
                NSLog(@"return Data error");
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                
                if(weak_self.errorSelector && [weak_self.requestDelegate respondsToSelector:self.errorSelector])
                {
                    NSLog(@"return Data error1");
                    NSMutableDictionary *reasonDict = reasonDict = [NSMutableDictionary new];
                    NSString *strFailText = @"网络异常，请稍后重试";
                    [reasonDict setObject:strFailText forKey:@"reason"];
                    if(weak_self.paramsObject.timesp)
                    {
                        NSLog(@"return Data error2");
                        
                        [reasonDict setObject:self.paramsObject.timesp forKey:@"timesp"];
                    }
                    
                    NSError *errorr = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:reasonDict];
                    [weak_self.requestDelegate performSelector:weak_self.errorSelector withObject:errorr];
                }
#pragma clang diagnostic pop
                
            }
        }
    }];
    [dataTask resume];
}

- (void)uploadData
{
    NSString *url = self.paramsObject.uploadUrl;
    
    __weak typeof(self)weak_self = self;

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //图片压缩至100kb以内
        NSData * data = nil;
        NSString *filePath = nil;
        if([weak_self.paramsObject.file isKindOfClass:[UIImage class]])
        {
//            if(![self.paramsObject.file isKindOfClass:NSClassFromString(@"_UIAnimatedImage")])
            {
                data = UIImageJPEGRepresentation(weak_self.paramsObject.file, 1.0);
                for (float i = 1.0; [data length] > 202400 && i > 0.0; i = i-0.1) {
                    data = UIImageJPEGRepresentation(weak_self.paramsObject.file, i);
                }
                
                NSString *pathComponent = @"avatar.png";
                
                filePath =  [[FileHelper getUploadPath] stringByAppendingPathComponent:pathComponent];
                
                [FileHelper clearFile:filePath];
                [data writeToFile:filePath atomically:YES];
            }
          
        }
        else
        {
             filePath = weak_self.paramsObject.file;
        }
        
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file1" error:nil];
    } error:nil];
    

    [[self class] addHttpHeader:request];
    
    NSURLSessionUploadTask *uploadTask = [[[self class] getRequestManager] uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            NSLog(@"error : %@",error);
            if(weak_self.requestDelegate && weak_self.errorSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if(weak_self.paramsObject.timesp){
                    NSMutableDictionary *reasonDict = nil;
                    
                    if(error.userInfo && [error.userInfo isKindOfClass:[NSDictionary class]]){
                        reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                    }
                    else{
                        reasonDict = [NSMutableDictionary new];
                    }
                    
                    [reasonDict setObject:weak_self.paramsObject.timesp forKey:@"timesp"];
 
                    NSError *errorr = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:[NSDictionary dictionaryWithObject:reasonDict forKey:@"reason"]];
                    [weak_self.requestDelegate performSelector:weak_self.errorSelector withObject:errorr];
                    
                }else{
                    [weak_self.requestDelegate performSelector:weak_self.errorSelector withObject:error];
                }
            }
            
#pragma clang diagnostic pop
        } else {
            if(weak_self.requestDelegate && self.completeSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                //去皮
                id object = [self transitionData:responseObject  cache:NO];
                
                if (object) {
                    if ([object isKindOfClass:[NSError class]]) {
                        [self.requestDelegate performSelector:self.errorSelector withObject:(NSError *)object];
                    }else{
                        [self.requestDelegate performSelector:self.completeSelector withObject:object];
                    }
                }
#pragma clang diagnostic pop
            }
        }
    }];
    
    [uploadTask resume];
}

///////////////
- (id)transitionData:(id)data cache:(BOOL)cache
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    jsonString = [self removeUnescapedCharacter:jsonString];
//    NSLog(@"transitionData%@", [data JSONValue]);
    if(jsonString)
    {
         NSMutableDictionary *dict = [jsonString JSONValue];
        
        
        if(dict && [dict isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [dict objectForKey:@"c"];
            if (code && ERROR_CODE_NEED_AUTH == [code intValue])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:AgainLoginNotification object:nil];
            }
            else if (code && ERROR_CODE_SUCCESS == [code intValue])
            {
                id responseObject = [dict objectForKey:@"d"];
                if(OBJ_IS_NIL(responseObject))
                {
                   responseObject = [NSMutableDictionary new];
                }
               
                if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *reasonDictionary = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                    if (self.paramsObject.timesp && reasonDictionary && [reasonDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [reasonDictionary setObject:self.paramsObject.timesp forKey:@"timesp"];
                    }
                  
                    
                    [reasonDictionary setObject:[NSNumber numberWithBool:cache] forKey:@"cache"];
                    return reasonDictionary;
                }

                if(self.paramsObject.timesp && [self.paramsObject.timesp length] > 0)
                {
                    if(responseObject && [responseObject isKindOfClass:[NSArray class]])
                    {
                        NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
                        {
                            [mutableDictionary setObject:self.paramsObject.timesp forKey:@"timesp"];
                            [mutableDictionary setObject:responseObject forKey:@"d"];
                        }
                        return mutableDictionary;
                        
                    }
                   
                }

              
                return responseObject;
            }else{
                
                if(self.paramsObject.timesp)
                {
                    
                    NSMutableDictionary *reasonDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
                    if(self.paramsObject.timesp && reasonDictionary && [reasonDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [reasonDictionary setObject:self.paramsObject.timesp forKey:@"timesp"];
                    }
                  
                    
                    if (!OBJ_IS_NIL([dict objectForKey:@"m"])) {
                        [reasonDictionary setObject:[dict objectForKey:@"m"] forKey:@"reason"];
                    }
  
                    NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:[code intValue] userInfo:[NSDictionary dictionaryWithObject:reasonDictionary forKey:@"reason"]];
                    
                    return error;
                }
                
                if (!OBJ_IS_NIL([dict objectForKey:@"m"])) {
                    NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:[code intValue] userInfo:[NSDictionary dictionaryWithObject:[dict objectForKey:@"m"] forKey:@"reason"]];
                    
                    return error;
                }

                return [NSError errorWithDomain:ERROR_DOMAIN code:[code intValue] userInfo:[NSDictionary dictionaryWithObject:AppDisplayErrorInfo forKey:@"reason"]];
                
            }
        }
    }
    
    return nil;
}

//return http body
- (NSString *)httpBodyString:(id)params
{
    @autoreleasepool {
        NSMutableString *bodyString = [[NSMutableString alloc] init];
        
        Class cls = [params class];
        
        unsigned int ivarsCnt = 0;
        objc_property_t *propertys = class_copyPropertyList(cls, &ivarsCnt);
        
        for (const objc_property_t *p = propertys; p < propertys + ivarsCnt; ++p)
        {
            objc_property_t const ivar = *p;
            
            NSString *key = [NSString stringWithUTF8String:property_getName(ivar)];
            id value = [params valueForKey:key];
            if(!OBJ_IS_NIL(value))
            {
                
                NSString *str = nil;
                if(![value isKindOfClass:[NSString class]])
                {
                    str = [NSString stringWithFormat:@"%@", value];
                }
                else
                {
                    str = value;
                }
                
                
                NSString *encodedValue = nil;
                if (key && [key isEqualToString:@"photo_id"]) {
                    encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                (CFStringRef)str,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8);
                    [bodyString appendFormat:@"&%@=%@", key, encodedValue];

                }
                else if (key && ([key isEqualToString:@"tempRequestBody"])){
                    [bodyString appendFormat:@"%@", str];
                }
                else
                {
                    encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                (CFStringRef)str,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8);
                    [bodyString appendFormat:@"&%@=%@", key, encodedValue];
                }
            }
        }
        
        free(propertys);
        
        return bodyString;
    }
}

- (NSString *)getSecondString:(NSString *)string
{ //取等号后面字符串
    if ([string rangeOfString:@"="].location != NSNotFound) {
        NSInteger location = [string rangeOfString:@"="].location;
        string = [string substringFromIndex:location + 1];
    }
    return string;
}

- (NSString *)removeUnescapedCharacter:(NSString *)inputStr {
    if (inputStr != nil && inputStr.length > 0) {
        NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
        //获取那些特殊字符
        NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];
        //寻找字符串中有没有这些特殊字符
        if (range.location != NSNotFound)
        {
            NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
            while (range.location != NSNotFound)
            {
                [mutable deleteCharactersInRange:range];
                //去掉这些特殊字符
                range = [mutable rangeOfCharacterFromSet:controlChars];
            }
            return mutable;
        }
    } else {
        return @"";
    }
    return inputStr;
}

@end
