//
//  DDUserInfoObject.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDUserInfoObject.h"
#import "DateHelper.h"
#import <objc/runtime.h>

#define USER_DEFAULTS_SYSTEM_USER @"USER_DEFAULTS_SYSTEM_USER"
@implementation DDUserParamsObject
- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.url = @"/user/joinin";
        self.post = YES;
    }
    
    return self;
}
@end


@implementation DDPushTokenObject

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.url = @"/push/registerPushToken";
        self.post = YES;
    }
    
    return self;
}

@end

@implementation DDBindTokenObject

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.url = @"/push/registerPushDeviceToken";
        self.post = YES;
        
        self.appCode = @"mentor";
    }
    
    return self;
}

@end




@implementation DDUserInfoObject

+ (instancetype)sharedInstance {
    static DDUserInfoObject *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (BOOL)parseUserInfo:(NSDictionary *)user_dict
{
    if (user_dict && (NSObject *)user_dict != [NSNull null]) {
//        [self mj_setKeyValues:user_dict];
        [self modelSetWithDictionary:user_dict];
        return YES;
        
    }
    return NO;
}

- (void)setUid:(NSString *)uid
{
    _uid = [NSString stringWithFormat:@"%@", uid];
}

- (BOOL)isNull:(id)value
{
    if (value != [NSNull null] && value != nil) {
        return NO;
    }
    return YES;
}
//Alc6uXsCJ7D1xOPEEG2entM
- (BOOL)parseData:(NSDictionary *)user_dict
{
    NSDictionary *result = [user_dict objectForKey:@"info"];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [self parseUserInfo:result];
        
    }
    self.token = [user_dict objectForKey:@"token"];
    self.uid = [user_dict objectForKey:@"uid"];
  
    if(self.token && [self.token isKindOfClass:[NSString class]])
    {
        return YES;
    }
   
    return NO;
}

/*与存储相关*/
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int ptcnt = 0;
    Class cls = [self class];

    objc_property_t *propertys = class_copyPropertyList(cls, &ptcnt);
    
    @try {
        for (const objc_property_t *p = propertys; p < propertys + ptcnt; ++p)
        {
            objc_property_t const property = *p;
            const char *name = property_getName(property);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [self valueForKey:key];
            
            if(!OBJ_IS_NIL(value))
            {
                [aCoder encodeObject:value forKey:key];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    free(propertys);
}

/*与读取相关*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
       
        unsigned int ptcnt = 0;
        Class cls = [self class];
        
        objc_property_t *propertys = class_copyPropertyList(cls, &ptcnt);
        
        @try {
            for (const objc_property_t *p = propertys; p < propertys + ptcnt; ++p)
            {
                objc_property_t const ivar = *p;
                const char *name = property_getName(ivar);
                NSString *key = [NSString stringWithUTF8String:name];
                id value = [aDecoder decodeObjectForKey:key];
                if(!OBJ_IS_NIL(value))
                {
                    [self setValue:value forKey:key];
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
       
        free(propertys);
        
    }
    
    return self;
}

+ (void)saveUserInfo:(DDUserInfoObject *)loginUserInfo
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:loginUserInfo];
    
    if(userData){
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:USER_DEFAULTS_SYSTEM_USER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)activeLoginUserInfo
{
    DDUserInfoObject *user = [DDUserInfoObject loginUserInfo];
    
    [DDUserInfoObject sharedInstance].uid = user.uid;
    [DDUserInfoObject sharedInstance].token = user.token;
    
    [DDUserInfoObject sharedInstance].name = user.name;
    [DDUserInfoObject sharedInstance].avatar = user.avatar;
    [DDUserInfoObject sharedInstance].mobile  = user.mobile;
    [DDUserInfoObject sharedInstance].gender = user.gender;
    
}

+ (DDUserInfoObject *)loginUserInfo
{
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_SYSTEM_USER];
    if (userData) {
        DDUserInfoObject *user = [[DDUserInfoObject alloc] init];
        user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return user;
    }
    
    return nil;
}

- (NSString*)getToken
{
    if([self.token isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    else return self.token;
}

+ (BOOL)isLogin{
    //判断登录状态
    NSString *token = [DDUserInfoObject sharedInstance].token;
    
    if (OBJ_IS_NIL(token)) {
        return NO;
    }
    return YES;
}

#pragma mark - Clear Local Data
+ (void)cleanAccountInfo
{
    [DDUserInfoObject sharedInstance].uid = nil;
    [DDUserInfoObject sharedInstance].token = nil;
    
    [DDUserInfoObject sharedInstance].name = nil;
    [DDUserInfoObject sharedInstance].avatar = nil;
    [DDUserInfoObject sharedInstance].birthday = 0;
    [DDUserInfoObject sharedInstance].mobile  = nil;
    [DDUserInfoObject sharedInstance].gender = 1;
    
    [DDUserInfoObject sharedInstance].createTime = 0;
      
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_SYSTEM_USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
