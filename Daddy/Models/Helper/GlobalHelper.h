//
//  GlobalHelper.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "UIView+Addition.h"
#import "NSArray+Addition.h"
#import "UIAlertView+Addition.h"
#import "NSString+Additions.h"
#import "NSDate+Addition.h"
#import "Colours.h"
#import "DDNavigationController.h"
#import "DateHelper.h"
#import "DDFileClient.h"
#import "FileHelper.h"
#import "DDTableCellProtocol.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "NSObject+YYModel.h"
#import "UIImage+MultiFormat.h"



#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)


#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES
/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

#define TableViewBackGroundColor [UIColor whiteColor]
#define AppDisplayName @"鸡"
#define kKeyboardHeight 258.f
#define kBurnBubbleWidth 114

#define KEYCHAIN_SERVICE_NAME       @"keychain.service.name.com.3daddy.duck"
#define KEYCHAIN_ACCOUNT_UUID       @"keychain.account.uuid.com.3daddy.duck"

#define SHOW_DEBUG_INFO @"com.3daddy.duck.show_debug"

//域名
#define ERROR_DOMAIN @"com.3daddy.duck"


#define OBJ_IS_NIL(s) (s==nil || [NSNull isEqual:s] || [s class]==nil || [@"<null>" isEqualToString:[s description]] ||[@"(null)" isEqualToString:[s description]])

#define Locs(key) NSLocalizedString(key, comment)


extern NSString* const AgainLoginNotification;

#define AppDisplayErrorInfo @"网络好像有点问题哦～"

@interface GlobalHelper : NSObject

UINavigationController *selected_navigation_controller();
NSString *device_id();
NSString *app_version();
NSString *device_os();
void RUN_ON_UI_THREAD(dispatch_block_t block);

@end

