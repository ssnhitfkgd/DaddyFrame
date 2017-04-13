//
//  FileHelper.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (BOOL)isExist:(NSString *)file;
+ (NSString *)getApiCachePath;
+ (NSString *)getConfigPath;
+ (NSString *)getHttpServerPath;
+ (NSString *)getFileName:(NSString *)path;
+ (NSString *)getFilePart:(NSString *)name idx:(NSInteger)idx;
+ (NSString *)getFileName:(NSString *)path suffix:(NSString *)suffix;
+ (NSString *)getBasePath;
+ (NSString *)getUploadPath;

+ (BOOL)isLocalFile:(NSString *)path;
+ (BOOL)clearDir:(NSString *)path;
+ (BOOL)clearFile:(NSString *)path;
+ (void)createDir:(NSString *)dirPath;
+ (void)clearCache;
+ (void)clearCacheOutOfAudio;
+ (void)moveItemToDir:(NSString*)file_path dir:(NSString*)dir;

+ (void)showAllFilesUnderLibraryDirectory;
+ (void)addSkipBackupAttributeToLibraryDirectory;

//+ (float)cacheSize;

@end
