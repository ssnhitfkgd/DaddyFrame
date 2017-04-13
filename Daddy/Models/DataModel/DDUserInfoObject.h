//
//  DDUserInfoObject.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

typedef NS_ENUM(NSInteger, ServiceType) {
    //3:信鸽； 7:苹果商店；8:华为；9:小米；11:个推；
    ServiceType_xinge = 3,
    ServiceType_Apple = 7,
    ServiceType_huawei,
    ServiceType_xiaomi,
    ServiceType_getui = 11,
};

typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceType_Android = 1,
    DeviceType_iOS,
};


#import <Foundation/Foundation.h>
#import "DDItemParseBase.h"
#import "DDParamsBaseObject.h"

// login
@interface DDUserParamsObject : DDParamsBaseObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *smscode;
@property (nonatomic, copy) NSString *countryCode;

@end


// push token 登录前
@interface DDPushTokenObject : DDParamsBaseObject

@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *deviceBrand;
@property (nonatomic, assign) DeviceType deviceType;
@property (nonatomic, assign) ServiceType serviceType;
@property (nonatomic, strong) NSNumber *versionCode;

@end

// push token 登录后
@interface DDBindTokenObject : DDParamsBaseObject

@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *deviceBrand;
@property (nonatomic, assign) DeviceType deviceType;
@property (nonatomic, assign) ServiceType serviceType;
@property (nonatomic, strong) NSNumber *versionCode;
@property (nonatomic, copy) NSString *appCode;

@end



@interface DDUserInfoObject : DDItemParseBase

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) NSNumber *birthday;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, copy) NSString *token;

- (BOOL)parseData:(NSDictionary *)user_dict;

+ (instancetype)sharedInstance;
+ (void)saveUserInfo:(DDUserInfoObject *)loginUserInfo;
+ (void)cleanAccountInfo;
+ (void)activeLoginUserInfo;
+ (DDUserInfoObject *)loginUserInfo;
+ (BOOL)isLogin;
- (NSString*)getToken;

@end
