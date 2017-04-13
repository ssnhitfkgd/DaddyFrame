//
//  GlobalHelper.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "GlobalHelper.h"
#import "SSKeychain.h"
#import "SecureUDID.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"


NSString *const AgainLoginNotification = @"com.again.login";

@implementation GlobalHelper

UINavigationController *selected_navigation_controller()
{
    UINavigationController *selectedNavi = nil;
    
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        selectedNavi = (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
    }
    
    return selectedNavi;
}

NSString *device_id()
{    
   NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:KEYCHAIN_SERVICE_NAME];
    if (!UUID || [UUID isEqualToString:@""]) {
        
        NSString *domain     = KEYCHAIN_SERVICE_NAME;
        NSString *key        = KEYCHAIN_ACCOUNT_UUID;
        NSString *identifier = [SecureUDID UDIDForDomain:[domain stringByAppendingString:@"uuid"] usingKey:[key stringByAppendingString:@"uuid"]];
        //本地没有，创建UUID
        UUID = identifier;
        if (identifier && ![identifier isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:KEYCHAIN_SERVICE_NAME];
        }
    }
    
    return UUID;
}


NSString *app_version()
{
    
    NSString *appVersion = nil;
    NSString *marketingVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *developmentVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (marketingVersionNumber && developmentVersionNumber) {
        
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            
            appVersion = marketingVersionNumber;
        } else {
            
            appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
        }
    } else {
        
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
    }
    
    return appVersion;
}

NSString* device_os()
{
    
    UIDevice *device = [UIDevice currentDevice];
//    NSString*		deviceName = [device model];
    NSString*       deviceName = [GlobalHelper deviceString];
    NSString*		OSName = [device systemName];
    NSString*		OSVersion = [device systemVersion];
    
    NSString *g_os = [NSString stringWithFormat:@"%@/%@/%@",deviceName,OSName,OSVersion];
    return g_os;
}

void RUN_ON_UI_THREAD(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

+ (NSString *)deviceString {
    
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"DEVICE"]) return @"TYPE	PRODUCT NAME";
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone";
    
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (GSM)";
    
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429)";
    
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1529)";
    
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1433/A1453)";
    
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1530)";
    
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPad1,1"]) return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2 (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,4"]) return @"iPad 2 (Wi-Fi, revised)";
    
    if ([deviceString isEqualToString:@"iPad2,5"]) return @"iPad mini (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad2,6"]) return @"iPad mini (A1454)";
    
    if ([deviceString isEqualToString:@"iPad2,7"]) return @"iPad mini (A1455)";
    
    if ([deviceString isEqualToString:@"iPad3,1"]) return @"iPad (3rd gen, Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad3,2"]) return @"iPad (3rd gen, Wi-Fi+LTE Verizon)";
    
    if ([deviceString isEqualToString:@"iPad3,3"]) return @"iPad (3rd gen, Wi-Fi+LTE AT&T)";
    
    if ([deviceString isEqualToString:@"iPad3,4"]) return @"iPad (4th gen, Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad3,5"]) return @"iPad (4th gen, A1459)";
    
    if ([deviceString isEqualToString:@"iPad3,6"]) return @"iPad (4th gen, A1460)";
    
    if ([deviceString isEqualToString:@"iPad4,1"]) return @"iPad Air (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad4,2"]) return @"iPad Air (Wi-Fi+LTE)";
    
    if ([deviceString isEqualToString:@"iPad4,3"]) return @"iPad Air (Rev)";
    
    if ([deviceString isEqualToString:@"iPad4,4"]) return @"iPad mini 2 (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad4,5"]) return @"iPad mini 2 (Wi-Fi+LTE)";
    
    if ([deviceString isEqualToString:@"iPad4,6"]) return @"iPad mini 2 (Rev)";
    
    if ([deviceString isEqualToString:@"iPad4,7"]) return @"iPad mini 3 (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad4,8"]) return @"iPad mini 3 (A1600)";
    
    if ([deviceString isEqualToString:@"iPad4,9"]) return @"iPad mini 3 (A1601)";
    
    if ([deviceString isEqualToString:@"iPad5,1"]) return @"iPad mini 4 (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad5,2"]) return @"iPad mini 4 (Wi-Fi+LTE)";
    
    if ([deviceString isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad5,4"]) return @"iPad Air 2 (Wi-Fi+LTE)";
    
    if ([deviceString isEqualToString:@"iPad6,7"]) return @"iPad Pro (Wi-Fi)";
    
    if ([deviceString isEqualToString:@"iPad6,8"]) return @"iPad Pro (Wi-Fi+LTE)";
    
    if ([deviceString isEqualToString:@"iPod1,1"]) return @"iPod touch";
    
    if ([deviceString isEqualToString:@"iPod2,1"]) return @"iPod touch (2nd gen)";
    
    if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod touch (3rd gen)";
    
    if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod touch (4th gen)";
    
    if ([deviceString isEqualToString:@"iPod5,1"]) return @"iPod touch (5th gen)";
    
    if ([deviceString isEqualToString:@"iPod7,1"]) return @"iPod touch (6th gen)";
    
    return deviceString;
}

@end
